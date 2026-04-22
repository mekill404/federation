package com.alpha.federation.dto.request;

import lombok.Getter;
import lombok.Setter;
import com.alpha.federation.model.enums.PaymentMode;

@Getter @Setter
public class CreateMemberPaymentRequest {
    private Integer amount;
    private String membershipFeeIdentifier;
    private String accountCreditedIdentifier;
    private PaymentMode paymentMode;
}