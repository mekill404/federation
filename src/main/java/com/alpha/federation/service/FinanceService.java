package com.alpha.federation.service;

import com.alpha.federation.dto.request.CreateMemberPaymentRequest;
import com.alpha.federation.dto.request.CreateMembershipFeeRequest;
import com.alpha.federation.dto.response.*;
import com.alpha.federation.exception.BadRequestException;
import com.alpha.federation.exception.NotFoundException;
import com.alpha.federation.model.*;
import com.alpha.federation.model.enums.AccountType;
import com.alpha.federation.model.enums.ActivityStatus;
import com.alpha.federation.repository.*;
import com.alpha.federation.mapper.MemberMapper;
import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FinanceService {

    /*remove all comment */
    private final PaymentRepository paymentRepository;
    private final CollectivityTransactionRepository transactionRepository;
    private final FinancialAccountRepository financialAccountRepository;
    private final MembershipFeeRepository membershipFeeRepository;
    private final MemberRepository memberRepository;
    private final CollectivityRepository collectivityRepository;
    private final MemberMapper memberMapper;

    public List<MemberPaymentResponse> addPayments(String memberId, List<CreateMemberPaymentRequest> requests) {
        MemberEntity member = memberRepository.findById(memberId);
        if (member == null)
            throw new NotFoundException("Member not found");

        String collectivityId = collectivityRepository.findCollectivityIdByMemberId(memberId);
        if (collectivityId == null)
            throw new NotFoundException("Member not linked to any collectivity");

        List<MemberPaymentResponse> responses = new ArrayList<>();

        for (CreateMemberPaymentRequest req : requests) {
            FinancialAccountEntity account = financialAccountRepository.findById(req.getAccountCreditedIdentifier());
            if (account == null)
                throw new NotFoundException("Financial account not found");
            if (req.getAmount() <= 0)
                throw new BadRequestException("Amount must be positive");

            if (req.getMembershipFeeIdentifier() != null) {
                if (membershipFeeRepository.findById(req.getMembershipFeeIdentifier()) == null) {
                    throw new NotFoundException("Membership fee not found");
                }
            }

            PaymentEntity payment = new PaymentEntity();
            payment.setMemberId(memberId);
            payment.setMembershipFeeId(req.getMembershipFeeIdentifier());
            payment.setAmount(Double.valueOf(req.getAmount()));
            payment.setPaymentMode(req.getPaymentMode());
            payment.setAccountCreditedId(account.getId());
            payment.setCreationDate(LocalDate.now());
            paymentRepository.save(payment);

            double newAmount = account.getAmount() + req.getAmount();
            financialAccountRepository.updateAmount(account.getId(), newAmount);
            account.setAmount(newAmount); 

            CollectivityTransactionEntity transaction = new CollectivityTransactionEntity();
            transaction.setCollectivityId(collectivityId);
            transaction.setMemberDebitedId(memberId);
            transaction.setAmount(Double.valueOf(req.getAmount()));
            transaction.setPaymentMode(req.getPaymentMode());
            transaction.setAccountCreditedId(account.getId());
            transaction.setCreationDate(LocalDate.now());
            transactionRepository.save(transaction);

            responses.add(mapToMemberPaymentResponse(payment, account));
        }
        return responses;
    }

    public List<MembershipFeeResponse> getMembershipFees(String collectivityId) {
        if (collectivityRepository.findById(collectivityId) == null)
            throw new NotFoundException("Collectivity not found");

        return membershipFeeRepository.findByCollectivityId(collectivityId).stream()
                .map(this::mapToMembershipFeeResponse)
                .collect(Collectors.toList());
    }

    public List<MembershipFeeResponse> createMembershipFees(String collectivityId,
            List<CreateMembershipFeeRequest> requests) {
        if (collectivityRepository.findById(collectivityId) == null)
            throw new NotFoundException("Collectivity not found");

        List<MembershipFeeResponse> responses = new ArrayList<>();
        for (CreateMembershipFeeRequest req : requests) {
            if (req.getAmount() <= 0)
                throw new BadRequestException("Amount must be positive");

            MembershipFeeEntity fee = new MembershipFeeEntity();
            fee.setCollectivityId(collectivityId);
            fee.setLabel(req.getLabel());
            fee.setAmount(req.getAmount());
            fee.setFrequency(req.getFrequency());
            fee.setEligibleFrom(req.getEligibleFrom());
            fee.setStatus(ActivityStatus.ACTIVE);

            membershipFeeRepository.save(fee);
            responses.add(mapToMembershipFeeResponse(fee));
        }
        return responses;
    }

    public List<CollectivityTransactionResponse> getTransactions(String collectivityId, LocalDate from, LocalDate to) {
        if (collectivityRepository.findById(collectivityId) == null)
            throw new NotFoundException("Collectivity not found");
        if (from.isAfter(to))
            throw new BadRequestException("'from' date must be before 'to' date");

        return transactionRepository.findByCollectivityIdAndPeriod(collectivityId, from, to).stream()
                .map(t -> {
                    CollectivityTransactionResponse resp = new CollectivityTransactionResponse();
                    resp.setId(t.getId());
                    resp.setCreationDate(t.getCreationDate());
                    resp.setAmount(t.getAmount());
                    resp.setPaymentMode(t.getPaymentMode());

                    FinancialAccountEntity acc = financialAccountRepository.findById(t.getAccountCreditedId());
                    resp.setAccountCredited(mapFinancialAccountToResponse(acc));

                    MemberEntity member = memberRepository.findById(t.getMemberDebitedId());
                    resp.setMemberDebited(memberMapper.toResponse(member));

                    return resp;
                })
                .collect(Collectors.toList());
    }

    public List<FinancialAccountResponse> getFinancialAccountsAtDate(String collectivityId, LocalDate at) {
        if (collectivityRepository.findById(collectivityId) == null) {
            throw new NotFoundException("Collectivity not found");
        }

        List<FinancialAccountEntity> accounts = financialAccountRepository.findByCollectivityId(collectivityId);
        List<FinancialAccountResponse> responses = new ArrayList<>();

        for (FinancialAccountEntity account : accounts) {
            Double totalAfter = transactionRepository.sumAmountByAccountAfterDate(account.getId(), at);
            double balanceAtDate = account.getAmount() - (totalAfter != null ? totalAfter : 0.0);

            FinancialAccountEntity adjustedAccount = new FinancialAccountEntity();
            adjustedAccount.setId(account.getId());
            adjustedAccount.setCollectivityId(account.getCollectivityId());
            adjustedAccount.setAccountType(account.getAccountType());
            adjustedAccount.setHolderName(account.getHolderName());
            adjustedAccount.setAmount(balanceAtDate);
            adjustedAccount.setBankName(account.getBankName());
            adjustedAccount.setBankCode(account.getBankCode());
            adjustedAccount.setBankBranchCode(account.getBankBranchCode());
            adjustedAccount.setBankAccountNumber(account.getBankAccountNumber());
            adjustedAccount.setBankAccountKey(account.getBankAccountKey());
            adjustedAccount.setMobileBankingService(account.getMobileBankingService());
            adjustedAccount.setMobileNumber(account.getMobileNumber());

            responses.add(mapFinancialAccountToResponse(adjustedAccount));
        }
        return responses;
    }

    private MemberPaymentResponse mapToMemberPaymentResponse(PaymentEntity payment, FinancialAccountEntity account) {
        MemberPaymentResponse resp = new MemberPaymentResponse();
        resp.setId(payment.getId());
        resp.setAmount(payment.getAmount().intValue());
        resp.setPaymentMode(payment.getPaymentMode());
        resp.setAccountCredited(mapFinancialAccountToResponse(account));
        resp.setCreationDate(payment.getCreationDate());
        return resp;
    }

    private MembershipFeeResponse mapToMembershipFeeResponse(MembershipFeeEntity fee) {
        MembershipFeeResponse resp = new MembershipFeeResponse();
        resp.setId(fee.getId());
        resp.setLabel(fee.getLabel());
        resp.setAmount(fee.getAmount());
        resp.setFrequency(fee.getFrequency());
        resp.setEligibleFrom(fee.getEligibleFrom());
        resp.setStatus(fee.getStatus());
        return resp;
    }

    private FinancialAccountResponse mapFinancialAccountToResponse(FinancialAccountEntity entity) {
        if (entity == null) return null;

        if (entity.getAccountType() == AccountType.CASH) {
            CashAccountResponse cash = new CashAccountResponse();
            cash.setId(entity.getId());
            cash.setAmount(entity.getAmount());
            return cash;
        } else if (entity.getAccountType() == AccountType.MOBILE_MONEY) {
            MobileBankingAccountResponse mobile = new MobileBankingAccountResponse();
            mobile.setId(entity.getId());
            mobile.setAmount(entity.getAmount());
            mobile.setHolderName(entity.getHolderName());
            mobile.setMobileBankingService(entity.getMobileBankingService());
            // conversion sécurisée du numéro de téléphone
            String mobileNumber = entity.getMobileNumber();
            if (mobileNumber != null && !mobileNumber.isEmpty()) {
                try {
                    mobile.setMobileNumber(Integer.parseInt(mobileNumber));
                } catch (NumberFormatException e) {
                    mobile.setMobileNumber(0);
                }
            } else {
                mobile.setMobileNumber(0);
            }
            return mobile;
        } else { 
            BankAccountResponse bank = new BankAccountResponse();
            bank.setId(entity.getId());
            bank.setAmount(entity.getAmount());
            bank.setHolderName(entity.getHolderName());
            bank.setBankName(entity.getBankName());
            bank.setBankCode(parseIntSafe(entity.getBankCode()));
            bank.setBankBranchCode(parseIntSafe(entity.getBankBranchCode()));
            bank.setBankAccountNumber(parseIntSafe(entity.getBankAccountNumber()));
            bank.setBankAccountKey(parseIntSafe(entity.getBankAccountKey()));
            return bank;
        }
    }

    private int parseIntSafe(String value) {
        if (value != null && !value.isEmpty()) {
            try {
                return Integer.parseInt(value);
            } catch (NumberFormatException e) {
                return 0;
            }
        }
        return 0;
    }
}