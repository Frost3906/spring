package com.spring.mapper;

import java.util.List;

import com.spring.domain.AttachFileVO;

public interface AttachMapper {

	int insert(AttachFileVO attach);
	int delete(int bno);
	List<AttachFileVO> select(int bno);
	List<AttachFileVO> getYesterdayFiles();
	
	
}
