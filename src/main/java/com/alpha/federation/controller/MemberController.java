package com.alpha.federation.controller;

import com.alpha.federation.dto.request.CreateMemberRequest;
import com.alpha.federation.dto.response.MemberResponse;
import com.alpha.federation.service.MemberService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/members")
public class MemberController {

    private final MemberService memberService;

    public MemberController(MemberService memberService) {
        this.memberService = memberService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public List<MemberResponse> createMembers(@RequestBody List<CreateMemberRequest> requests) {
        return memberService.registerMembers(requests);
    }
}