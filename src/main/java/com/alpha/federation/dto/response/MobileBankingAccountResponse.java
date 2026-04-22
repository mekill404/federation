package com.alpha.federation.dto.response;

import com.alpha.federation.model.enums.MobileBankingService;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class MobileBankingAccountResponse extends FinancialAccountResponse {
    private String holderName;
    private MobileBankingService mobileBankingService;
    private Integer mobileNumber;
}