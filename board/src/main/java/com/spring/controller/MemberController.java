package com.spring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/member/*")
public class MemberController {
	
	@GetMapping("/login")
	public void loginForm() {
		log.info("로그인폼 요청");
	}
	
	@GetMapping("/admin")
	public void adminFomr() {
		log.info("관리자 페이지 요청");
	}
	
}
