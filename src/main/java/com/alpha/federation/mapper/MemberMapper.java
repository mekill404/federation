package com.alpha.federation.mapper;

import com.alpha.federation.dto.request.CreateMemberRequest;
import com.alpha.federation.dto.response.MemberResponse;
import com.alpha.federation.model.MemberEntity;
import org.springframework.stereotype.Component;
import java.util.stream.Collectors;

@Component
public class MemberMapper {

    public MemberEntity toEntity(CreateMemberRequest request) {
        MemberEntity entity = new MemberEntity();
        entity.setFirstName(request.getFirstName());
        entity.setLastName(request.getLastName());
        entity.setBirthDate(request.getBirthDate());
        entity.setGender(request.getGender());
        entity.setAddress(request.getAddress());
        entity.setProfession(request.getProfession());
        entity.setPhoneNumber(request.getPhoneNumber());
        entity.setEmail(request.getEmail());
        entity.setOccupation(request.getOccupation());
        return entity;
    }

    public MemberResponse toResponse(MemberEntity entity) {
        if (entity == null) return null;
        MemberResponse response = new MemberResponse();
        response.setId(entity.getId());
        response.setFirstName(entity.getFirstName());
        response.setLastName(entity.getLastName());
        response.setBirthDate(entity.getBirthDate());
        response.setGender(entity.getGender());
        response.setAddress(entity.getAddress());
        response.setProfession(entity.getProfession());
        response.setPhoneNumber(entity.getPhoneNumber());
        response.setEmail(entity.getEmail());
        response.setOccupation(entity.getOccupation());
        response.setReferees(entity.getReferees().stream()
                .map(this::toResponse)
                .collect(Collectors.toList()));
        return response;
    }
}