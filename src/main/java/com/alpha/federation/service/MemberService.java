package com.alpha.federation.service;

import com.alpha.federation.model.Member;
import com.alpha.federation.repository.CollectivityRepository;
import com.alpha.federation.repository.MemberRepository;

import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class MemberService {

    private final MemberRepository memberRepository;
    private final CollectivityRepository collectivityRepository;

    public MemberService(MemberRepository memberRepository, CollectivityRepository collectivityRepository) {
        this.memberRepository = memberRepository;
        this.collectivityRepository = collectivityRepository;
    }

    public List<Member> registerMembers(List<Member> members) {
        List<Member> created = new ArrayList<>();
        for (Member member : members) {
            List<String> refereeIds = member.getRefereeIds();
            if (refereeIds == null || refereeIds.size() < 2) {
                throw new IllegalArgumentException("Au moins 2 parrains sont requis.");
            }

            List<Member> referees = new ArrayList<>();
            for (String refId : refereeIds) {
                Member ref = memberRepository.findById(refId);
                if (ref == null) {
                    throw new IllegalArgumentException("Parrain introuvable: " + refId);
                }
                referees.add(ref);
            }

            String targetCollectivityId = member.getCollectivityIdentifier();
            if (targetCollectivityId == null) {
                throw new IllegalArgumentException("L'identifiant de la collectivité cible est requis.");
            }

            long internalCount = referees.stream()
                    .filter(ref -> collectivityRepository.isMemberOfCollectivity(ref.getId(), targetCollectivityId))
                    .count();
            long externalCount = referees.size() - internalCount;
            if (internalCount < externalCount) {
                throw new IllegalArgumentException("La majorité des parrains doit appartenir à la collectivité cible.");
            }

            if (!member.isRegistrationFeePaid() || !member.isMembershipDuesPaid()) {
                throw new IllegalArgumentException("Les frais d'adhésion et les cotisations annuelles doivent être payés.");
            }

            member.setId(UUID.randomUUID().toString());
            memberRepository.save(member);
            memberRepository.saveReferees(member.getId(), refereeIds);
            collectivityRepository.addMemberships(targetCollectivityId, List.of(member.getId()));

            member.getReferees().clear();
            member.getReferees().addAll(memberRepository.findReferees(member.getId()));

            created.add(member);
        }
        return created;
    }
}