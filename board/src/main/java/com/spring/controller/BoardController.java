package com.spring.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
	
	
	@GetMapping("/register")
	public String register() {
		log.info("register form 요청");
		return "/board/register";
	}
	
	
	@PostMapping("/register")
	public String registerPost(BoardVO vo, RedirectAttributes rttr) {
		log.info("글쓰기 요청");
		
		if(service.register(vo)) {
			rttr.addFlashAttribute("result",vo.getBno());
			return "redirect:list";
		}
		return "register";
	}
	
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
			return "redirect:/board/modify?bno="+vo.getBno();
		}
	}
	@PostMapping("/delete")
	public String delete(BoardVO vo, RedirectAttributes rttr, Criteria cri) {
		log.info("삭제 요청 : 글번호-"+vo.getBno()+" "+cri);
		if(service.delete(vo)) {
			rttr.addAttribute("amount",cri.getAmount());
			rttr.addAttribute("pageNum",cri.getPageNum());
			rttr.addAttribute("type",cri.getType());
			rttr.addAttribute("keyword",cri.getKeyword());
			rttr.addFlashAttribute("result","success");
			return "redirect:list";
		}
		return "/board/modify";
	}
	
	
}
