package com.alpha.federation.model;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import com.alpha.federation.model.enums.Frequency;
import com.alpha.federation.model.enums.ActivityStatus;

@Getter @Setter
public class MembershipFeeEntity {
    private String id;
    private String collectivityId;
    private String label;
    private Double amount;
    private Frequency frequency;
    private LocalDate eligibleFrom;
    private ActivityStatus status;
}