package com.alpha.federation.service;

import com.alpha.federation.model.Collectivity;
import com.alpha.federation.model.CollectivityStructure;
import com.alpha.federation.model.Member;
import com.alpha.federation.repository.CollectivityRepository;
import com.alpha.federation.repository.MemberRepository;

import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class CollectivityService {

	private final CollectivityRepository collectivityRepository;
	private final MemberRepository memberRepository;

	public CollectivityService(CollectivityRepository collectivityRepository, MemberRepository memberRepository) {
		this.collectivityRepository = collectivityRepository;
		this.memberRepository = memberRepository;
	}

	public List<Collectivity> createCollectivities(List<Collectivity> requests) {
		List<Collectivity> result = new ArrayList<>();
		int currentYear = LocalDate.now().getYear();

		for (Collectivity req : requests) {
			if (!req.isFederationApproval()) {
				throw new IllegalArgumentException("L'approbation de la fédération est obligatoire.");
			}

			List<String> memberIds = req.getMembers().stream()
					.map(Member::getId)
					.toList();
			if (memberIds == null || memberIds.size() < 10) {
				throw new IllegalArgumentException("Au moins 10 membres sont requis pour créer une collectivité.");
			}

			long anciens = memberIds.stream()
					.filter(id -> {
						LocalDate adhesion = memberRepository.getAdhesionDate(id);
						return adhesion != null &&
								ChronoUnit.MONTHS.between(adhesion, LocalDate.now()) >= 6;
					})
					.count();
			if (anciens < 5) {
				throw new IllegalArgumentException("Au moins 5 membres doivent avoir 6 mois d'ancienneté.");
			}

			CollectivityStructure structInput = req.getStructure();
			if (structInput == null ||
					structInput.getPresident() == null || structInput.getVicePresident() == null ||
					structInput.getTreasurer() == null || structInput.getSecretary() == null) {
				throw new IllegalArgumentException("Tous les postes du bureau doivent être pourvus.");
			}

			Collectivity col = new Collectivity();
			col.setId(UUID.randomUUID().toString());
			col.setLocation(req.getLocation());

			collectivityRepository.save(col);
			collectivityRepository.saveStructure(col.getId(),
					structInput.getPresident(),
					structInput.getVicePresident(),
					structInput.getTreasurer(),
					structInput.getSecretary(),
					currentYear);
			collectivityRepository.addMemberships(col.getId(), memberIds);

			List<Member> members = collectivityRepository.getMembers(col.getId());
			col.setMembers(members);

			CollectivityStructure structResp = new CollectivityStructure();
			structResp.setPresident(structInput.getPresident());
			structResp.setVicePresident(structInput.getVicePresident());
			structResp.setTreasurer(structInput.getTreasurer());
			structResp.setSecretary(structInput.getSecretary());
			col.setStructure(structResp);
			col.setStructure(structResp);

			result.add(col);
		}
		return result;
	}
}