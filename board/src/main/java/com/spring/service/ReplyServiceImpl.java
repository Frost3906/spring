package com.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.domain.Criteria;
import com.spring.domain.ReplyVO;
import com.spring.mapper.ReplyMapper;

@Service
public class ReplyServiceImpl implements ReplyService{

	@Autowired
	private ReplyMapper mapper;
	
	@Override
	public boolean replyInsert(ReplyVO vo) {
		return mapper.insert(vo)>0?true:false;
	}

	@Override
	public ReplyVO replyGet(int rno) {
		return mapper.get(rno);
	}

	@Override
	public boolean replyModify(ReplyVO vo) {
		return mapper.modify(vo)>0?true:false;
	}
	
	public boolean replyDelete(int rno) {
		return mapper.delete(rno)>0?true:false;
	}

	@Override
	public List<ReplyVO> replyList(Criteria cri, int bno) {
		return mapper.list(cri, bno);
	}

	@Override
	public int getCountByBno(int bno) {
		return mapper.getCountByBno(bno);
	}

}
