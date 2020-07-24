package com.spring.service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.domain.Criteria;
import com.spring.domain.ReplyPageVO;
import com.spring.domain.ReplyVO;
import com.spring.mapper.BoardMapper;
import com.spring.mapper.ReplyMapper;

@Service
public class ReplyServiceImpl implements ReplyService{

	@Autowired
	private ReplyMapper mapper;
	@Autowired
	private BoardMapper b_mapper;
	
	@Override
	@Transactional
	public boolean replyInsert(ReplyVO vo) {
		//댓글 게시물 수 변경
		b_mapper.updateReplyCnt(vo.getBno(),1);
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
	
	@Override
	@Transactional
	public boolean replyDelete(int rno) {
	
		//rno 를 이용해 bno 알아내기
		ReplyVO vo = mapper.get(rno);
		//댓글 게시물 수 변경
	
		b_mapper.updateReplyCnt(vo.getBno(),-1);
		return mapper.delete(rno)>0?true:false;
	}

	@Override
	public ReplyPageVO replyList(Criteria cri, int bno) {
		return new ReplyPageVO(mapper.getCountByBno(bno),mapper.list(cri, bno));
	}

	@Override
	public int getCountByBno(int bno) {
		return mapper.getCountByBno(bno);
	}

}
