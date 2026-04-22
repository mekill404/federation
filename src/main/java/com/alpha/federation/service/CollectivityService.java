package com.alpha.federation.service;

import com.alpha.federation.dto.request.AssignIdentifiersRequest;
import com.alpha.federation.dto.request.CollectivityInformationRequest;
import com.alpha.federation.dto.request.CreateCollectivityRequest;
import com.alpha.federation.dto.request.CreateCollectivityStructure;
import com.alpha.federation.dto.response.CollectivityResponse;
import com.alpha.federation.exception.BadRequestException;
import com.alpha.federation.exception.ConflictException;
import com.alpha.federation.exception.NotFoundException;
import com.alpha.federation.mapper.CollectivityMapper;
import com.alpha.federation.model.CollectivityEntity;
import com.alpha.federation.model.MemberEntity;
import com.alpha.federation.repository.CollectivityRepository;
import com.alpha.federation.repository.MemberRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

@Service
public class CollectivityService {

    private final CollectivityRepository collectivityRepository;
    private final MemberRepository memberRepository;
    private final CollectivityMapper collectivityMapper;

    public CollectivityService(CollectivityRepository collectivityRepository,
            MemberRepository memberRepository,
            CollectivityMapper collectivityMapper) {
        this.collectivityRepository = collectivityRepository;
        this.memberRepository = memberRepository;
        this.collectivityMapper = collectivityMapper;
    }

    public List<CollectivityResponse> createCollectivities(List<CreateCollectivityRequest> requests) {
        List<CollectivityResponse> responses = new ArrayList<>();
        for (CreateCollectivityRequest req : requests) {
            responses.add(createSingleCollectivity(req));
        }
        return responses;
    }

    private CollectivityResponse createSingleCollectivity(CreateCollectivityRequest request) {
        if (!request.isFederationApproval()) {
            throw new BadRequestException("Federation approval is required.");
        }

        List<String> memberIds = request.getMembers();
        if (memberIds == null || memberIds.size() < 10) {
            throw new BadRequestException("At least 10 members are required to create a collectivity.");
        }

        long anciens = memberIds.stream()
                .map(id -> {
                    MemberEntity m = memberRepository.findById(id);
                    if (m == null) {
                        throw new NotFoundException("Member not found: " + id);
                    }
                    return m;
                })
                .filter(m -> ChronoUnit.MONTHS.between(m.getCreatedAt(), LocalDate.now()) >= 6)
                .count();
        if (anciens < 5) {
            throw new BadRequestException("At least 5 members must have 6 months of seniority.");
        }

        CreateCollectivityStructure struct = request.getStructure();
        if (struct == null ||
                struct.getPresident() == null || struct.getVicePresident() == null ||
                struct.getTreasurer() == null || struct.getSecretary() == null) {
            throw new BadRequestException("All positions in the board must be filled.");
        }

        CollectivityEntity entity = collectivityMapper.toEntity(request);
        entity = collectivityRepository.save(entity);

        int currentYear = LocalDate.now().getYear();
        collectivityRepository.saveStructure(
                entity.getId(),
                struct.getPresident(),
                struct.getVicePresident(),
                struct.getTreasurer(),
                struct.getSecretary(),
                currentYear);

        for (String memberId : memberIds) {
            collectivityRepository.addMembership(entity.getId(), memberId, "JUNIOR");
        }

        CollectivityEntity fullEntity = collectivityRepository.findById(entity.getId());
        return collectivityMapper.toResponse(fullEntity);
    }

    public CollectivityResponse assignIdentifiers(String collectivityId, AssignIdentifiersRequest request) {
        CollectivityEntity entity = collectivityRepository.findById(collectivityId);
        if (entity == null) {
            throw new NotFoundException("Collectivity not found with id: " + collectivityId);
        }

        if (entity.getUniqueNumber() != null || entity.getUniqueName() != null) {
            throw new ConflictException("Identifiers have already been assigned and cannot be modified.");
        }

        if (collectivityRepository.existsByUniqueNumber(request.getUniqueNumber())) {
            throw new BadRequestException("Unique number '" + request.getUniqueNumber() + "' already exists.");
        }
        if (collectivityRepository.existsByUniqueName(request.getUniqueName())) {
            throw new BadRequestException("Unique name '" + request.getUniqueName() + "' already exists.");
        }

        collectivityRepository.updateIdentifiers(collectivityId, request.getUniqueNumber(), request.getUniqueName());

        CollectivityEntity updatedEntity = collectivityRepository.findById(collectivityId);
        return collectivityMapper.toResponse(updatedEntity);
    }

    public CollectivityResponse assignInformations(String collectivityId, CollectivityInformationRequest request) {
        CollectivityEntity entity = collectivityRepository.findById(collectivityId);
        if (entity == null)
            throw new NotFoundException("Collectivity not found");

        if (entity.getUniqueNumber() != null || entity.getUniqueName() != null) {
            throw new ConflictException("Informations already assigned");
        }

        String uniqueNumber = String.valueOf(request.getNumber());
        if (collectivityRepository.existsByUniqueNumber(uniqueNumber)) {
            throw new BadRequestException("Number already exists");
        }
        if (collectivityRepository.existsByUniqueName(request.getName())) {
            throw new BadRequestException("Name already exists");
        }

        collectivityRepository.updateIdentifiers(collectivityId, uniqueNumber, request.getName());
        return collectivityMapper.toResponse(collectivityRepository.findById(collectivityId));
    }
}