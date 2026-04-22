package com.alpha.federation.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.util.List;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class CollectivityResponse {
    private String id;
    private String location;
    private String uniqueNumber;
    private String uniqueName;
    private CollectivityStructureResponse structure;
    private List<MemberResponse> members;
}