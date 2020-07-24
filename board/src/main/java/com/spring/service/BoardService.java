package com.spring.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.domain.AttachFileVO;
import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;

public interface BoardService {
	public List<BoardVO> list(Criteria cri);
	public int total(Criteria cri);
	public boolean register(BoardVO vo);
	public BoardVO read(int bno);
	public boolean modify(BoardVO vo);
	public boolean delete(int bno);
	public int updateReplyCnt(int bno, int amount);
	
	//첨부물 기능
	List<AttachFileVO> attachList(int bno);
}
