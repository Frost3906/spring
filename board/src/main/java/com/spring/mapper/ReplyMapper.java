package com.spring.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.domain.Criteria;
import com.spring.domain.ReplyVO;

public interface ReplyMapper {
	int insert(ReplyVO vo);
	ReplyVO get(int rno);
	int modify(ReplyVO vo);
	int delete(int rno);
	List<ReplyVO> list(@Param("cri") Criteria cri, @Param("bno") int bno);
	int getCountByBno(int bno);
}
