package com.alpha.federation.controller;

import com.alpha.federation.dto.request.CreateMemberRequest;
import com.alpha.federation.dto.request.CreateMemberPaymentRequest;
import com.alpha.federation.dto.response.MemberPaymentResponse;
import com.alpha.federation.dto.response.MemberResponse;
import com.alpha.federation.service.FinanceService;
import com.alpha.federation.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/members")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;
    private final FinanceService financeService;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public List<MemberResponse> createMembers(@RequestBody List<CreateMemberRequest> requests) {
        return memberService.registerMembers(requests);
    }

    @PostMapping("/{id}/payments")
    @ResponseStatus(HttpStatus.CREATED)
    public List<MemberPaymentResponse> addPayments(@PathVariable String id,
                                                   @RequestBody List<CreateMemberPaymentRequest> requests) {
        return financeService.addPayments(id, requests);
    }
}