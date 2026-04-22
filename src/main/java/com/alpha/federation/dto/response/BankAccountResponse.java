package com.alpha.federation.dto.response;

import com.alpha.federation.model.enums.Bank;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class BankAccountResponse extends FinancialAccountResponse {
    private String holderName;
    private Bank bankName;
    private Integer bankCode;
    private Integer bankBranchCode;
    private Integer bankAccountNumber;
    private Integer bankAccountKey;
}