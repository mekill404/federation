package com.alpha.federation.service;

import com.alpha.federation.dto.request.CreateMemberRequest;
import com.alpha.federation.dto.response.MemberResponse;
import com.alpha.federation.exception.BadRequestException;
import com.alpha.federation.exception.NotFoundException;
import com.alpha.federation.mapper.MemberMapper;
import com.alpha.federation.model.MemberEntity;
import com.alpha.federation.repository.CollectivityRepository;
import com.alpha.federation.repository.MemberRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class MemberService {

    private final MemberRepository memberRepository;
    private final CollectivityRepository collectivityRepository;
    private final MemberMapper memberMapper;

    public MemberService(MemberRepository memberRepository, CollectivityRepository collectivityRepository, MemberMapper memberMapper) {
        this.memberRepository = memberRepository;
        this.collectivityRepository = collectivityRepository;
        this.memberMapper = memberMapper;
    }

    public List<MemberResponse> registerMembers(List<CreateMemberRequest> requests) {
        List<MemberResponse> responses = new ArrayList<>();
        for (CreateMemberRequest req : requests) {
            responses.add(registerSingleMember(req));
        }
        return responses;
    }

    private MemberResponse registerSingleMember(CreateMemberRequest request) {
        if (request.getReferees() == null || request.getReferees().size() < 2) {
            throw new BadRequestException("At least 2 referees are required.");
        }

        List<MemberEntity> referees = new ArrayList<>();
        for (String refId : request.getReferees()) {
            MemberEntity ref = memberRepository.findById(refId);
            if (ref == null) {
                throw new NotFoundException("Referee not found: " + refId);
            }
            referees.add(ref);
        }

        String targetCollectivityId = request.getCollectivityIdentifier();
        if (targetCollectivityId == null || targetCollectivityId.isEmpty()) {
            throw new BadRequestException("The identifier of the target collectivity is required.");
        }

        long internalCount = referees.stream()
                .filter(ref -> collectivityRepository.isMemberOfCollectivity(ref.getId(), targetCollectivityId))
                .count();
        long externalCount = referees.size() - internalCount;
        if (internalCount < externalCount) {
            throw new BadRequestException("The majority of referees must belong to the target collectivity.");
        }

        if (!request.isRegistrationFeePaid() || !request.isMembershipDuesPaid()) {
            throw new BadRequestException("The registration fee and annual dues must be paid.");
        }

        MemberEntity newMember = memberMapper.toEntity(request);
        newMember = memberRepository.save(newMember);
        memberRepository.saveReferees(newMember.getId(), request.getReferees(), targetCollectivityId);

        collectivityRepository.addMembership(targetCollectivityId, newMember.getId(), "JUNIOR");

        newMember.setReferees(memberRepository.findReferees(newMember.getId()));

        return memberMapper.toResponse(newMember);
    }
}