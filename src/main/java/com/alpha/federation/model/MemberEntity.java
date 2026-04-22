package com.alpha.federation.model;

import com.alpha.federation.model.enums.Gender;
import com.alpha.federation.model.enums.Occupation;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class MemberEntity {
    private String id, firstName, lastName;
    private LocalDate createdAt, birthDate;
    private String address, profession, phoneNumber, email;
    private Occupation occupation;
    private Gender gender;
    private List<MemberEntity> referees = new ArrayList<>();
}
