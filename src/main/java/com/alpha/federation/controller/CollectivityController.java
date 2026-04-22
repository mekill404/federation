package com.alpha.federation.controller;

import com.alpha.federation.dto.request.AssignIdentifiersRequest;
import com.alpha.federation.dto.request.CreateCollectivityRequest;
import com.alpha.federation.dto.response.CollectivityResponse;
import com.alpha.federation.service.CollectivityService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/collectivities")
public class CollectivityController {

	private final CollectivityService collectivityService;

	public CollectivityController(CollectivityService collectivityService) {
		this.collectivityService = collectivityService;
	}

	@PostMapping
	@ResponseStatus(HttpStatus.CREATED)
	public List<CollectivityResponse> createCollectivities(@RequestBody List<CreateCollectivityRequest> requests) {
		return collectivityService.createCollectivities(requests);
	}

	@PatchMapping("/{id}")
	public ResponseEntity<CollectivityResponse> assignIdentifiers(
			@PathVariable String id,
			@RequestBody AssignIdentifiersRequest request) {
		CollectivityResponse response = collectivityService.assignIdentifiers(id, request);
		return ResponseEntity.ok(response);
	}
}