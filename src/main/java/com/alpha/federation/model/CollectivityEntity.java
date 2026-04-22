package com.alpha.federation.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class CollectivityEntity {

    private String uniqueNumber, uniqueName, id, location;
    private boolean federationApproval;
    private LocalDate approvalDate;
    private MemberEntity president, vicePresident, treasurer, secretary;
    private List<MemberEntity> members = new ArrayList<>();
}