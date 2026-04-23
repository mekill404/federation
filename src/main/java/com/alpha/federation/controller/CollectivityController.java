package com.alpha.federation.controller;

import com.alpha.federation.dto.request.*;
import com.alpha.federation.dto.response.*;
import com.alpha.federation.service.CollectivityService;
import com.alpha.federation.service.FinanceService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/collectivities")
@RequiredArgsConstructor
public class CollectivityController {

	private final CollectivityService collectivityService;
	private final FinanceService financeService;

	@PostMapping
	@ResponseStatus(HttpStatus.CREATED)
	public List<CollectivityResponse> createCollectivities(@RequestBody List<CreateCollectivityRequest> requests) {
		return collectivityService.createCollectivities(requests);
	}

	@PutMapping("/{id}/informations")
	public CollectivityResponse updateInformations(@PathVariable String id,
			@RequestBody CollectivityInformationRequest request) {
		return collectivityService.assignInformations(id, request);
	}

	@GetMapping("/{id}/membershipFees")
	public List<MembershipFeeResponse> getMembershipFees(@PathVariable String id) {
		return financeService.getMembershipFees(id);
	}

	@PostMapping("/{id}/membershipFees")
	public List<MembershipFeeResponse> createMembershipFees(@PathVariable String id,
			@RequestBody List<CreateMembershipFeeRequest> requests) {
		return financeService.createMembershipFees(id, requests);
	}

	@GetMapping("/{id}/transactions")
	public List<CollectivityTransactionResponse> getTransactions(
			@PathVariable String id,
			@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
			@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
		return financeService.getTransactions(id, from, to);
	}

	@GetMapping("/{id}")
	public CollectivityResponse getCollectivityById(@PathVariable String id) {
		return collectivityService.getCollectivityById(id);
	}

	@GetMapping("/{id}/financialAccounts")
	public List<FinancialAccountResponse> getFinancialAccounts(
			@PathVariable String id,
			@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate at) {
		return financeService.getFinancialAccountsAtDate(id, at);
	}
}