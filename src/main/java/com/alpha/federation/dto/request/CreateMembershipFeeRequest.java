package com.alpha.federation.dto.request;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import com.alpha.federation.model.enums.Frequency;

@Getter @Setter
public class CreateMembershipFeeRequest {
    private LocalDate eligibleFrom;
    private Frequency frequency;
    private Double amount;
    private String label;
}