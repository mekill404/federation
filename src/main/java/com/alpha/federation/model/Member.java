package com.alpha.federation.model;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.alpha.federation.model.enums.Genre;
import com.alpha.federation.model.enums.StatutMembre;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class Member {
    private Long id;
    private String name;
    private String firstname;
    private LocalDate birthdate;
    private Genre genre;
    private String adresse;
    private String phone;
    private LocalDate AdmissionDate;
    private StatutMembre status;
    private String email;
    private int collectiviteID;

    private boolean registrationFeePaid;
    private boolean membershipDuesPaid;

    private List<Member> refere = new ArrayList<>();
}
