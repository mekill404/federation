package com.alpha.federation.model;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class Collectivity {

    private String id;
    private String location;
    private CollectivityStructure structure;
    private List<Member> members = new ArrayList<>();

    @JsonIgnore
    private List<Member> memberIds;

    @JsonIgnore
    private CollectivityStructure structureInput;

    @JsonIgnore
    private boolean federationApproval;

    public void setMembers(List<Member> members2) {
        this.memberIds = members2;
    }

    public void setStructure(CollectivityStructure structResp) {
        this.structureInput = structResp;
    }

    public void setFederationApproval(boolean approval) {
        this.federationApproval = approval;
    }

    @Getter @Setter
    @NoArgsConstructor
    public static class CreateStructureInput {
        private String president;
        private String vicePresident;
        private String treasurer;
        private String secretary;
    }
}