package com.spring.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString

public class Criteria {
	private int pageNum;
	private int amount;

	private String type;//검색조건
	
	private String keyword;//검색어
	
	
	public Criteria() {
		this(1,10);
	}
	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
	}
	//type값을 배열로 리턴
	//type : T {"T"}, C{"C"}, W {"W"}, TC {"T","C"}, TW {"T","W"}, TCW {"T","C","W"}
	public String[] getTypeArr() {
		return type == null? new String[]{}:type.split("");
	}
}
