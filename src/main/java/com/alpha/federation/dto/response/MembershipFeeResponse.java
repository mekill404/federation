package com.alpha.federation.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDate;
import com.alpha.federation.model.enums.Frequency;
import com.alpha.federation.model.enums.ActivityStatus;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class MembershipFeeResponse {
    private String id;
    private LocalDate eligibleFrom;
    private Frequency frequency;
    private Double amount;
    private String label;
    private ActivityStatus status;
}