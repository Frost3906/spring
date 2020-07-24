package com.spring.domain;

import lombok.Data;

@Data
public class AttachFileVO {
	private String uuid; //고유 id 값
	private String uploadPath; //날짜별로 파일 저장
	private String fileName; //원본 파일명
	private boolean fileType; //이미지 여부
	private int bno; // 원본글번호
	
}
