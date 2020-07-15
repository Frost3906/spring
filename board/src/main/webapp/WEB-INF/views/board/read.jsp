<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@include file="../includes/header.jsp" %>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board Read</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>            
            <div class="row">
                <div class="col-lg-12">
                	<div class="panel panel-default">
                        <div class="panel-heading">
                           Board Read Page
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                			<form action="" role="form">
                				<div class="form-group">
                					<label>Bno</label>
                					<input class="form-control" name="bno" readonly="readonly" value="${vo.bno}">                				
                				</div> 
                				<div class="form-group">
                					<label>Title</label>
                					<input class="form-control" name="title" readonly="readonly" value="${vo.title}">                				
                				</div>  
                				<div class="form-group">
                					<label>Content</label>
                					<textarea class="form-control" rows="3" name="content" readonly="readonly">${vo.content}</textarea>               				
                				</div> 
                				<div class="form-group">
                					<label>Writer</label>
                					<input class="form-control" name="writer" readonly="readonly" value="${vo.writer}">                				
                				</div>  
                				<!--onclick="location.href='modify?bno=${vo.bno}'"-->
                				<!-- 페이지 나누기가 될경우 힘들어지기 때문 -->
                				<button type="button" class="btn btn-default">Modify</button>     			
                				<button type="reset" class="btn btn-info">List</button>          			
                			</form>
                		</div>
                	</div>
                </div>
            </div>        
<!--댓글 영역  -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i>
				Reply
				<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">
					New Reply
				</button>
			</div>
			<div class="panel-body">
				<ul class="chat">
					<li class="left clearfix" data-rno='30'>
						<div>
							<div class="header">
								<strong class="primary-font">댓글러00</strong>
								<small class="pull-right text-muted">
									2020.07.15 12:14
								</small>
							</div>
								<p>Good Job!!!</p>
						</div>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>
<div class="modal" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
		<div class="form-group">
			<label for="">댓글 내용</label>
			<input type="text" class="form-control" name="reply" value="댓글 내용"/>
		</div>
		<div class="form-group">
			<label for="">작성자</label>
			<input type="text" class="form-control" name="replyer" value="작성자"/>
		</div>
		<div class="form-group">
			<label for="">작성일</label>
			<input type="text" class="form-control" name="replydate" value="작성일"/>
		</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-warning" id="modalRegisterBtn">등록</button>
        <button type="button" class="btn btn-secondary" id="modalModBtn">수정</button>
        <button type="button" class="btn btn-danger" id="modalDeleteBtn">삭제</button>
        <button type="button" class="btn btn-primary" id="modalCloseBtn" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>   
<%-- 패이지 나누기와 다른 작업 들을 위해서 폼 작성--%>
<form id="myform">

	<input type="hidden" name="bno" value="${vo.bno}"/>
	<input type="hidden" name="pageNum" value="${cri.pageNum}"/>
	<input type="hidden" name="amount" value="${cri.amount}"/>
	<input type="hidden" name="type" value="${cri.type}"/>
	<input type="hidden" name="keyword" value="${cri.keyword}"/>
</form>
<script>
	$(function(){
		let form = $("#myform");
		
		$(".btn-default").click(function(){
			form.attr('action','modify');
			form.submit();
		})
		$(".btn-info").click(function(){
			form.attr('action','list');
			form.find("input[name='bno']").remove();
			form.submit();
		})
	
	
	})
	
</script>
<script src="/resources/js/reply.js"></script>
<script>
$(function(){
	
	//현재글의 글번호 가져오기
	let bno = ${vo.bno};
	//댓글 영역 가져오기
	let replyUL = $(".chat");
	
	//댓글 영역 내용을 보여주는 함수 호출
	showList(1);
	
	//모달 영역 가져오기
	let modal = $(".modal");
	//모달 영역이 가지고 있는 input 영역 찾기
	let modalInputReply = modal.find("input[name='reply']");
	let modalInputReplyer = modal.find("input[name='replyer']");
	let modalInputReplyDate = modal.find("input[name='replydate']");
	
	//모달 영역이 가지고 있는 버튼 찾기
	let modalModBtn = $("#modalModBtn");
	let modalRemoveBtn = $("#modalRemoveBtn");
	let modalRegisterBtn = $("#modalRegisterBtn");
	
	$("#addReplyBtn").click(function(){
		//input 안의 내용 없애주기
		modal.find("input").val("");
		
		//작성날짜 영역 없애기
		modalInputReplyDate.closest("div").hide();
		//닫기 버튼만 제외하고 모든 버튼을 숨기기
		modal.find("button[id!='modalCloseBtn']").hide();
		//등록 버튼 다시 보이기
		modalRegisterBtn.show();
	
		
		modal.modal("show");
	})
	
	
	//댓글 작업 호출
	//댓글 등록하기
	modalRegisterBtn.on("click",function(){
		var reply = {
				bno:bno,
				replyer:modalInputReplyer.val(),
				reply:modalInputReply.val()
		};

		replyService.add(reply,function(result){
					alert(result);
					//modal에 있는 댓글 내용과 관련된 내용 지우기
					modal.find("input").val("");
					//모달 창 종료
					modal.modal("hide");
					//전체 댓글 리스트 보기
					showList(1);
		
		});//add종료
	})
	 
	

 	//댓글 리스트 요청하기
 	function showList(page){
		replyService.getList({bno:bno,page:page},function(list){
			console.log(list);
			
			if(list=== null || list.length===0){
				replyUL.html("");
				return;
			}
			
			let str="";
			for(var i = 0,len=list.length||0;i<len;i++){
				str+="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
				str+="<div><div class='header'>";
				str+="<strong class='primary-font'>"+list[i].replyer+"</strong>";
				str+="<small class='pull-right text-muted'>"+replyService.displayTime(list[i].replydate)+"</small>";
				str+="</div><p>"+list[i].reply+"</p></div></li>";

			}
			replyUL.html(str);
			
		}); //list 종료 
	}

/* 	replyService.remove(5,
		function(result){console.log(result);},
		function(msg){
			alert("삭제 실패");
	}) //remove 종료*/
	
/* 	replyService.update({rno:4,reply:'댓글수정'},function(result){
			alert(result);
		},function(error){
			alert("수정실패");
	}) //update 종료*/
	
	//댓글 하나 가져오기
	//실제로는 li 에 이벤트를 걸어야 하지만 댓글이 나중에 생기는 부분이기 때문에 존재하는 
	//영역에 댓글을 걸고 나중에 생기는 li태그에 위임하는 방식으로 작성
	$(".chat").on("click","li",function(){
		
		//현재 클릭된 댓글의 rno 가져오기
		var rno = $(this).data("rno");
		
		replyService.get(rno,
				function(result){
					console.log(result);
					//도착한 데이터 모달창에 보여주기
					modalInputReply.val(result.reply);
					modalInputReplyer.val(result.replyer).attr("readonly","readonly");
					modalInputReplyDate.val(replyService.displayTime(result.replydate))
											.attr("readonly","readonly");
					
					//현재 읽어준 rno 담아주기
					modal.data("rno",result.rno);
					
					modal.find("button[id='modalRegisterBtn']").hide();
					modal.modal("show");
				},
				function(error){
					alert("댓글이 없습니다.");
		
		}); //get 종료
	})
	
	
})


</script>


<%@include file="../includes/footer.jsp" %>       