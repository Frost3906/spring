package com.spring.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.domain.AttachFileVO;
import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;
import com.spring.mapper.AttachMapper;
import com.spring.mapper.BoardMapper;


@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardMapper mapper;
	@Autowired
	private AttachMapper attach;
	
	
	@Override
	public List<BoardVO> list(Criteria cri) {
		return mapper.list(cri);
	}
	@Override
	public int total(Criteria cri) {
		return mapper.total(cri);
	}
	
	@Transactional
	@Override
	public boolean register(BoardVO vo) {
		
		//게시글  db 저장 요청
		boolean result =  mapper.register(vo)>0?true:false;
		
		//첨부파일 db 저장 요청
		
		if(vo.getAttachList() == null || vo.getAttachList().size() <= 0) {
			return result;
		}
		vo.getAttachList().forEach(attach1 -> {
			attach1.setBno(vo.getBno());
			attach.insert(attach1);
		});
		return true;
		
		
	}
	@Override
	public BoardVO read(int bno) {
		return mapper.read(bno);
	}
	
	@Transactional
	@Override
	public boolean modify(BoardVO vo) {
		//현재 bno의 게시물 db에서 삭제
		attach.delete(vo.getBno());
		//첨부 파일을 삽입
		if(vo.getAttachList() != null && vo.getAttachList().size() >= 0) {
			for(AttachFileVO attach1 : vo.getAttachList()) {
				attach1.setBno(vo.getBno());
				attach.insert(attach1);
			}
		}
		
		
		return mapper.modify(vo)>0?true:false;
	}
	
	@Transactional
	@Override
	public boolean delete(int bno) {
		attach.delete(bno);
		return mapper.delete(bno)>0?true:false;
	}
	@Override
	public int updateReplyCnt(int bno, int amount) {
		return mapper.updateReplyCnt(bno, amount);
	}
	@Override
	public List<AttachFileVO> attachList(int bno) {
		return attach.select(bno);
	}

}
