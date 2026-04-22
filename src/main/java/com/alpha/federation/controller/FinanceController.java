package com.alpha.federation.controller;

import com.alpha.federation.DBConnection.DBConnection;
import com.alpha.federation.service.FinanceService;
import org.springframework.web.bind.annotation.*;

@RestController
public class FinanceController {

    private DBConnection dbConn = new DBConnection();
    private FinanceService financeService = new FinanceService(dbConn);

    @PostMapping("/members/{id}/payments")
    public String addPayment(@PathVariable String id, @RequestParam double amount, @RequestParam String accountId) {
        financeService.savePayment(id, amount, accountId);
        return "Paiement réussi pour le membre " + id;
    }
}