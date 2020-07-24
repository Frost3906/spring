package com.spring.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.domain.AttachFileVO;
import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;
import com.spring.domain.PageVO;
import com.spring.service.BoardService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/board")
public class BoardController {

	@Autowired
	private BoardService service;
	
	

	
	@GetMapping("/list")
	public String list(Model model, @ModelAttribute("cri") Criteria cri) {
		log.info("글목록 요청");
		
		List<BoardVO> list = service.list(cri);
		//현재 페이지에 보여줄 게시물
		model.addAttribute("list",list);
		//페이지 하단의 페이지 나누기와 관련한 정보
		model.addAttribute("PageVO",new PageVO(cri, service.total(cri)));
		
		
		
		return "/board/list";
	}
	
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/register")
	public void register() {
		log.info("register form 요청");
	}
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/register")
	public String registerPost(BoardVO vo, RedirectAttributes rttr) {
		log.info("글쓰기 요청");
		
		if(vo.getAttachList()!=null) {
			vo.getAttachList().forEach(attach -> log.info(attach+""));
		}
		
		if(service.register(vo)) {
			rttr.addFlashAttribute("result",vo.getBno());
			return "redirect:list";
		}else {
			return "register";
		}
	}
	@PreAuthorize("isAuthenticated()")
	@GetMapping(value = {"/read","/modify"})
	public void read(int bno, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info("글 읽기 요청 : 글번호-"+bno+"..."+cri);
		model.addAttribute("cri",cri);
		model.addAttribute("vo",service.read(bno));
		//http://localhost:8080/board/read
		//http://localhost:8080/board/modify
		
	}
	
	@PostMapping("/modify")
	public String modifyPost(BoardVO vo, RedirectAttributes rttr, @ModelAttribute("cri") Criteria cri) {
		log.info("삭제 요청 : 글번호-"+vo+"..."+cri);
		if(service.modify(vo)) {
			rttr.addAttribute("amount",cri.getAmount());
			rttr.addAttribute("pageNum",cri.getPageNum());
			rttr.addAttribute("type",cri.getType());
			rttr.addAttribute("keyword",cri.getKeyword());
			rttr.addAttribute("bno",vo.getBno());
			return "redirect:read";
		}else {
			rttr.addAttribute("amount",cri.getAmount());
			rttr.addAttribute("pageNum",cri.getPageNum());
			rttr.addAttribute("type",cri.getType());
			rttr.addAttribute("keyword",cri.getKeyword());
			rttr.addAttribute("bno",vo.getBno());

			return "redirect:modify";
		}
	}
	

	@PostMapping("/delete")
	public String delete(int bno, RedirectAttributes rttr, Criteria cri) {
		log.info("삭제 요청 : 글번호-"+bno+" "+cri);
		
		
		//현재 글 번호에 해당하는 첨부파일 목록을 서버에서 삭제하기 위해서
		//bno에 해당하는 첨부파일 리스트 가져오기
		List<AttachFileVO> attachList = service.attachList(bno);
		
		
		
		service.delete(bno);
		deleteFiles(attachList);
		rttr.addAttribute("amount",cri.getAmount());
		rttr.addAttribute("pageNum",cri.getPageNum());
		rttr.addAttribute("type",cri.getType());
		rttr.addAttribute("keyword",cri.getKeyword());
		rttr.addFlashAttribute("result","success");
		return "redirect:list";
		
	}
	
	
	@GetMapping("/getAttachList")
	public ResponseEntity<List<AttachFileVO>> getAttachList(int bno){
		log.info("첨부물 가져오기  : "+bno);
		return new ResponseEntity<List<AttachFileVO>>(service.attachList(bno),HttpStatus.OK);
	}
	
	//게시글 삭제시 서버 폴더에 첨부물 삭제
	private void deleteFiles(List<AttachFileVO> attachList) {
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		for(AttachFileVO vo : attachList) {
			Path file = Paths.get("d:\\upload\\",vo.getUploadPath()+"\\"+vo.getUuid()+"_"+vo.getFileName());
		
			try {
				//일반파일, 이미지 원본 파일 삭제
				Files.deleteIfExists(file);
				
				//섬네일 삭제
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumb = Paths.get("d:\\upload\\",vo.getUploadPath()+"\\s_"+vo.getUuid()+"_"+vo.getFileName());
					Files.delete(thumb);
				}
				
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	
}
