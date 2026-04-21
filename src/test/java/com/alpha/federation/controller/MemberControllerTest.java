package com.alpha.federation.controller;

import com.alpha.federation.model.Member;
import com.alpha.federation.service.MemberService;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Collections;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(MemberController.class) // On teste uniquement le Controller
public class MemberControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Mock
    private MemberService memberService; 

    @Autowired
    private tools.jackson.databind.ObjectMapper objectMapper;

    @Test
    void testCreateMembers() throws Exception {
        Member member = new Member();
        member.setId("M-001");
        member.setFirstName("Rindra");
        member.setLastName("Andria");
        
        List<Member> memberList = Collections.singletonList(member);

        when(memberService.registerMembers(any())).thenReturn(memberList);

        mockMvc.perform(post("/members")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(memberList)))
                .andExpect(status().isCreated());
    }
}