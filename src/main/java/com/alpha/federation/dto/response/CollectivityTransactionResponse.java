package com.alpha.federation.dto.response;

import com.alpha.federation.model.enums.PaymentMode;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDate;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class CollectivityTransactionResponse {
    private String id;
    private LocalDate creationDate;
    private Double amount;
    private PaymentMode paymentMode;
    private FinancialAccountResponse accountCredited;
    private MemberResponse memberDebited;
}