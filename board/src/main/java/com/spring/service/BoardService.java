package com.spring.service;

import java.util.List;

import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;

public interface BoardService {
	public List<BoardVO> list(Criteria cri);
	public int total(Criteria cri);
	public boolean register(BoardVO vo);
	public BoardVO read(int bno);
	public boolean modify(BoardVO vo);
	public boolean delete(BoardVO vo);
}
