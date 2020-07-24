package com.spring.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.spring.domain.Criteria;
import com.spring.domain.ReplyPageVO;
import com.spring.domain.ReplyVO;
import com.spring.service.ReplyService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/replies/*")
public class ReplyController {
	
	@Autowired
	private ReplyService service;
	
	
	@PostMapping("/new") //http://localhost:8080//replies/new + post
	public ResponseEntity<String> reply(@RequestBody ReplyVO vo) {
		log.info("댓글등록 : "+vo);
		return service.replyInsert(vo)?
				new ResponseEntity<String>("success",HttpStatus.OK):
				new ResponseEntity<String>("fail",HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@GetMapping("/{rno}")
	public ResponseEntity<ReplyVO> replyGet(@PathVariable("rno")int rno){
		log.info("댓글 가져오기 : "+rno);
		return new ResponseEntity<>(service.replyGet(rno),HttpStatus.OK);
		
	}

	@PutMapping("/{rno}")
	public ResponseEntity<String> replyModify(@PathVariable("rno") int rno, @RequestBody ReplyVO vo) {
		log.info("댓글 수정 요청  "+rno);
		vo.setRno(rno);
		return service.replyModify(vo)?
				new ResponseEntity<String>("success",HttpStatus.OK):
				new ResponseEntity<String>("fail", HttpStatus.BAD_REQUEST);
	}
	
	@DeleteMapping("/{rno}")
	public ResponseEntity<String> replyDelete(@PathVariable("rno") int rno) {
		log.info("댓글 삭제 요청 : "+rno);
		return service.replyDelete(rno)?
				new ResponseEntity<String>("success",HttpStatus.OK):
				new ResponseEntity<String>("fail", HttpStatus.BAD_REQUEST);
	}
	
	@GetMapping("/pages/{bno}/{page}")
	public ResponseEntity<ReplyPageVO> replyList(@PathVariable("bno") int bno, @PathVariable("page") int page){
		
		log.info("댓글 리스트 가져오기 "+bno+" page = "+page);
		
		Criteria cri = new Criteria(page,10);
		
		return new ResponseEntity<ReplyPageVO>(service.replyList(cri, bno),HttpStatus.OK);
	}
	
	
}
