package com.alpha.federation.model;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import com.alpha.federation.model.enums.PaymentMode;

@Getter @Setter
public class PaymentEntity {
    private String id;
    private String memberId;
    private String membershipFeeId;
    private Double amount;
    private PaymentMode paymentMode;
    private String accountCreditedId;
    private LocalDate creationDate;
}