package com.spring.mapper;

import java.util.List;

import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;

public interface BoardMapper {
	public List<BoardVO> list(Criteria cri);
	public int total(Criteria cri);
	public int register(BoardVO vo);
	public BoardVO read(int bno);
	public int modify(BoardVO vo);
	public int delete(BoardVO vo);
}
