package com.alpha.federation.mapper;

import com.alpha.federation.dto.request.CreateCollectivityRequest;
import com.alpha.federation.dto.response.CollectivityResponse;
import com.alpha.federation.dto.response.CollectivityStructureResponse;
import com.alpha.federation.model.CollectivityEntity;
import org.springframework.stereotype.Component;
import java.util.stream.Collectors;

@Component
public class CollectivityMapper {

    private final MemberMapper memberMapper;

    public CollectivityMapper(MemberMapper memberMapper) {
        this.memberMapper = memberMapper;
    }

    public CollectivityEntity toEntity(CreateCollectivityRequest request) {
        CollectivityEntity entity = new CollectivityEntity();
        entity.setLocation(request.getLocation());
        entity.setFederationApproval(request.isFederationApproval());
        // Les membres et le bureau seront ajoutés plus tard
        return entity;
    }

    public CollectivityResponse toResponse(CollectivityEntity entity) {
        CollectivityResponse response = new CollectivityResponse();
        response.setId(entity.getId());
        response.setLocation(entity.getLocation());

        CollectivityStructureResponse structure = new CollectivityStructureResponse();
        structure.setPresident(memberMapper.toResponse(entity.getPresident()));
        structure.setVicePresident(memberMapper.toResponse(entity.getVicePresident()));
        structure.setTreasurer(memberMapper.toResponse(entity.getTreasurer()));
        structure.setSecretary(memberMapper.toResponse(entity.getSecretary()));
        response.setStructure(structure);

        response.setMembers(entity.getMembers().stream()
                .map(memberMapper::toResponse)
                .collect(Collectors.toList()));
        return response;
    }
}