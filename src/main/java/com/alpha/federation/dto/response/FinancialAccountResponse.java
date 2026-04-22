package com.alpha.federation.dto.response;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import lombok.Getter;
import lombok.Setter;

@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "type")
@JsonSubTypes({
    @JsonSubTypes.Type(value = CashAccountResponse.class, name = "CASH"),
    @JsonSubTypes.Type(value = MobileBankingAccountResponse.class, name = "MOBILE_BANKING"),
    @JsonSubTypes.Type(value = BankAccountResponse.class, name = "BANK")
})
@Getter @Setter
public abstract class FinancialAccountResponse {
    private String id;
    private Double amount;
}