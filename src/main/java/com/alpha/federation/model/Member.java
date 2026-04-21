package com.alpha.federation.model;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.alpha.federation.model.enums.Genre;
import com.alpha.federation.model.enums.StatutMembre;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class Member {
    private String id;
    private String lastName;
    private String firstName;
    private LocalDate birthDate;
    private Genre genre;
    private String adresse;
    private String phoneNumber;
    private LocalDate AdmissionDate;
    private StatutMembre status;
    private String email;
    private int collectiviteID;

    private boolean registrationFeePaid;
    private boolean membershipDuesPaid;

    private List<Member> referees = new ArrayList<>();
}
