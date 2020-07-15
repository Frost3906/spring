package com.spring.service;

import java.util.List;

import com.spring.domain.Criteria;
import com.spring.domain.ReplyVO;

/*
 * 변수명, 메소드명 규칙(카멜케이스)
 * 소문자 시작
 * 두단어가 연결되었을 때 두번째 단어의 첫 시작부분을 대문자로 주기
 * 
 * 데이터 베이스 규칙(스네이크 케이스)
 * reply_service / reply_insert
 * 
 * 
 * */
public interface ReplyService {
	public boolean replyInsert(ReplyVO vo);
	public ReplyVO replyGet(int rno);
	public boolean replyModify(ReplyVO vo);
	public boolean replyDelete(int rno);
	public List<ReplyVO> replyList(Criteria cri, int bno);
	public int getCountByBno(int bno);
}
