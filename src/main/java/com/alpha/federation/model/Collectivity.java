package com.alpha.federation.model;



import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDate;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class Collectivity {
    private String id;
    private String uniqueNumber;
    private String uniqueName;
    private String specialty;
    private LocalDate creationDate;
    private boolean federationApproval;


    private Member president;
    private Member vicePresident;
    private Member secretary;
    private Member treasurer;
}