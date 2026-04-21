package com.alpha.federation.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class CollectivityStructureResponse {
    private MemberResponse president;
    private MemberResponse vicePresident;
    private MemberResponse treasurer;
    private MemberResponse secretary;
}