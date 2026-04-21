package com.alpha.federation.service;

import com.alpha.federation.model.Collectivity;
import com.alpha.federation.repository.CollectivityRepository;
import com.alpha.federation.repository.MemberRepository;
import org.springframework.stereotype.Service;


@Service
public class CollectivityService {
    private final CollectivityRepository collectivityRepository;
    private final MemberRepository memberRepository;

    public CollectivityService(CollectivityRepository collectivityRepository, MemberRepository memberRepository) {
        this.collectivityRepository = collectivityRepository;
        this.memberRepository = memberRepository;
    }

    public Collectivity createCollectivity(Collectivity col) {

        if (!col.isFederationApproval()) {
            throw new RuntimeException("Une collectivité doit avoir l'approbation de la fédération.");
        }

        // Hydratation du bureau (pour renvoyer les infos complètes comme demandé)
        col.setPresident(memberRepository.findById(col.getPresident().getId()));
        col.setVicePresident(memberRepository.findById(col.getVicePresident().getId()));
        col.setSecretary(memberRepository.findById(col.getSecretary().getId()));
        col.setTreasurer(memberRepository.findById(col.getTreasurer().getId()));

        collectivityRepository.save(col);
        return col;
    }
}
