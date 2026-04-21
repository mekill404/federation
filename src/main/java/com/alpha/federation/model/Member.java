package com.alpha.federation.model;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.alpha.federation.model.enums.Gender;
import com.alpha.federation.model.enums.Occupation;
import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class Member {

    private String id;

    private String firstName;
    private String lastName;
    private LocalDate birthDate;
    private Gender gender;
    private String address;
    private String profession;
    private String phoneNumber;
    private String email;
    private Occupation occupation;

    private List<Member> referees = new ArrayList<>();

    @JsonIgnore
    private List<String> refereeIds;

    @JsonIgnore
    private String collectivityIdentifier;

    @JsonIgnore
    private boolean registrationFeePaid;

    @JsonIgnore
    private boolean membershipDuesPaid;

    public void setReferees(List<String> refereeIds) {
        this.refereeIds = refereeIds;
    }
}