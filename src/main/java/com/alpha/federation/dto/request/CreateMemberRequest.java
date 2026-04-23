package com.alpha.federation.dto.request;

import com.alpha.federation.model.enums.Gender;
import com.alpha.federation.model.enums.Occupation;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
public class CreateMemberRequest {
	private String firstName;
	private String lastName;
	private LocalDate birthDate;
	private Gender gender;
	private String address;
	private String profession;
	private String phoneNumber;
	private String email;
	private Occupation occupation;

	private String collectivityIdentifier;
	private List<String> referees;
	private boolean registrationFeePaid;
	private boolean membershipDuesPaid;
}