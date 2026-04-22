package com.alpha.federation.dto.request;

import lombok.Getter;
import lombok.Setter;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

@Getter @Setter
public class CollectivityInformationRequest {
    @NotBlank
    private String name;
    @NotNull
    private Integer number;
}