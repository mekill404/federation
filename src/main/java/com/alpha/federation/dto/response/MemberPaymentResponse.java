package com.alpha.federation.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDate;
import com.alpha.federation.model.enums.PaymentMode;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class MemberPaymentResponse {
    private String id;
    private Integer amount;
    private PaymentMode paymentMode;
    private FinancialAccountResponse accountCredited;
    private LocalDate creationDate;
}