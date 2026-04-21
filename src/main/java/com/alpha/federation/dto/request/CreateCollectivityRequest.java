package com.alpha.federation.dto.request;

import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Getter @Setter
public class CreateCollectivityRequest {
    private String location;
    private List<String> members;
    private boolean federationApproval;
    private StructureInput structure;

    @Getter @Setter
    public static class StructureInput {
        private String president;
        private String vicePresident;
        private String treasurer;
        private String secretary;
    }
}