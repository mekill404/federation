package com.alpha.federation.controller;

import com.alpha.federation.model.Member;
import com.alpha.federation.service.MemberService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
    public ResponseEntity<List<Member>> createMembers(@RequestBody List<Member> members) {
        try {
            List<Member> createdMembers = memberService.registerMembers(members);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdMembers);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }
}
