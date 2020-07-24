package com.spring.mapper;

import com.spring.domain.MemberVO;

public interface MemberMapper {
	
	MemberVO read(String userid);
}
