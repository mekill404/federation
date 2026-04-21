package com.alpha.federation.controller;



import com.alpha.federation.model.Collectivity;
import com.alpha.federation.service.CollectivityService;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/collectivities")
public class CollectivityController {

    private final CollectivityService collectivityService;

    public CollectivityController(CollectivityService collectivityService) {
        this.collectivityService = collectivityService;
    }

    @PostMapping
    public ResponseEntity<Collectivity> create(@RequestBody Collectivity collectivity) {
        try {
            Collectivity created = collectivityService.createCollectivity(collectivity);

            return new ResponseEntity<>(created, HttpStatus.CREATED);
        } catch (RuntimeException e) {

            return new ResponseEntity<>((HttpHeaders) null, HttpStatus.BAD_REQUEST);
        }
    }
}