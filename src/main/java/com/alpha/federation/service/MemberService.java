package com.alpha.federation.service;

import com.alpha.federation.model.Member;
import com.alpha.federation.repository.MemberRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class MemberService {

    private final MemberRepository memberRepository;

    public MemberService(MemberRepository memberRepository) {
        this.memberRepository = memberRepository;
    }
    
    public List<Member> registerMembers(List<Member> memberRequests) {
        List<Member> savedMembers = new ArrayList<>();
        for (Member member : memberRequests) {
            if (member.getReferees() == null || member.getReferees().size() < 2) {
                throw new RuntimeException("the member must have at least 2 referees.");
            }
            if (!member.isRegistrationFeePaid() || !member.isMembershipDuesPaid()) {
                throw new RuntimeException("the registration fee and membership dues must be paid.");
            }
            List<Member> fullReferees = new ArrayList<>();
            for (Member refShort : member.getReferees()) {
                Member existingRef = memberRepository.findById(refShort.getId());
                if (existingRef == null) {
                    throw new RuntimeException("Referee not found : " + refShort.getId());
                }
                fullReferees.add(existingRef);
            }
            member.setReferees(fullReferees);
            memberRepository.save(member);
            savedMembers.add(member);
        }
        return savedMembers;
    }
}
