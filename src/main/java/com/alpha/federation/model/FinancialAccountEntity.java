package com.alpha.federation.model;

import lombok.Getter;
import lombok.Setter;
import com.alpha.federation.model.enums.AccountType;
import com.alpha.federation.model.enums.Bank;
import com.alpha.federation.model.enums.MobileBankingService;

@Getter @Setter
public class FinancialAccountEntity {
    private String id;
    private String collectivityId;
    private AccountType accountType;
    private String holderName;
    private Double amount;
    private Bank bankName;
    private String bankCode;
    private String bankBranchCode;
    private String bankAccountNumber;
    private String bankAccountKey;
    private MobileBankingService mobileBankingService;
    private String mobileNumber;
}