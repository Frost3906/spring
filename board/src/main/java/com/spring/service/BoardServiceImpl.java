package com.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;
import com.spring.mapper.BoardMapper;


@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardMapper mapper;
	@Override
	public List<BoardVO> list(Criteria cri) {
		return mapper.list(cri);
	}
	@Override
	public int total(Criteria cri) {
		return mapper.total(cri);
	}
	@Override
	public boolean register(BoardVO vo) {
		return mapper.register(vo)>0?true:false;
	}
	@Override
	public BoardVO read(int bno) {
		return mapper.read(bno);
	}
	@Override
	public boolean modify(BoardVO vo) {
		return mapper.modify(vo)>0?true:false;
	}
	@Override
	public boolean delete(BoardVO vo) {
		return mapper.delete(vo)>0?true:false;
	}

}
