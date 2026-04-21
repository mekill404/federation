package com.alpha.federation.dto.response;

import com.alpha.federation.model.enums.Gender;
import com.alpha.federation.model.enums.Occupation;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDate;
import java.util.List;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class MemberResponse {
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
    private List<MemberResponse> referees;
}