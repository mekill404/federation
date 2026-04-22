package com.alpha.federation.dto.request;

import lombok.Getter;
import lombok.Setter;
import jakarta.validation.constraints.NotBlank;

@Getter @Setter
public class AssignIdentifiersRequest {
    @NotBlank
    private String uniqueNumber;
    @NotBlank
    private String uniqueName;
}