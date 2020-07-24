<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@include file="../includes/header.jsp" %>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board List</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Board List Page
                            <button id='regBtn' type='button' class='btn btn-xs btn-primary pull-right' onclick="location.href='register'">Register New Board</button>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <table class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>번 호</th>
                                        <th>제 목</th>
                                        <th>작성자</th>
                                        <th>작성일</th>
                                        <th>수정일</th>
                                    </tr>									
                                </thead>
								<!-- 게시판 리스트 반복문 -->
								   <c:forEach var="vo" items="${list}">
								   <tr>
                                        <th>${vo.bno}</th>
                                        <th><a href="<c:out value='${vo.bno}'/>" class="move">${vo.title}</a><strong>[${vo.replycnt}]</strong></th>
                                        <th>${vo.writer}</th>
                                        <th><fmt:formatDate pattern="yyyy-MM-dd-HH:mm" value="${vo.regdate}"/></th>
                                        <th><fmt:formatDate pattern="yyyy-MM-dd-HH:mm" value="${vo.updatedate}"/></th>
                                    </tr>
								   </c:forEach>
                            </table>
							<div class="row"> <!-- start search -->
                            	<div class="col-md-12">
                            	  <div class="col-md-8"><!--search Form-->
                            		<form action="" id="searchForm">
                            			<input type="hidden" name="pageNum" value="${cri.pageNum}"/>                            			
                            			<input type="hidden" name="amount" value="${cri.amount}"/>                            			
                            			<select name="type" id="">
                            				<option value="" <c:out value="${empty cri.type?'selected':''}"/>>-------</option>
                            				<option value="T" <c:out value="${cri.type=='T'?'selected':''}"/>>제목
                            				<option value="C" <c:out value="${cri.type=='C'?'selected':''}"/>>내용</option>
                            				<option value="W" <c:out value="${cri.type=='W'?'selected':''}"/>>작성자</option>
                            				<option value="TC" <c:out value="${cri.type=='TC'?'selected':''}"/>>제목 or 내용</option>
                            				<option value="TW" <c:out value="${cri.type=='TW'?'selected':''}"/>>제목 or 작성자</option>
                            				<option value="TCW" <c:out value="${cri.type=='TCW'?'selected':''}"/>>제목 or 내용 or 작성자</option>
                            			</select>
                            			<input type="text" name="keyword" value="${cri.keyword}"/>
                            			<button class="btn btn-default">검색</button>
                            		</form>
                            	   </div>
                            	   <div class="col-md-2 col-md-offset-2">
                            	   	<!--페이지 목록 갯수 지정하는 폼-->
                            	   	<select class="form-control" name="amount" >
                            	   		<option value="10" <c:out value="${cri.amount == 10?'selected':'' }"/>>10</option>
                            	   		<option value="20" <c:out value="${cri.amount == 20?'selected':'' }"/>>20</option>
                            	   		<option value="30" <c:out value="${cri.amount == 30?'selected':'' }"/>>30</option>
                            	   		<option value="40" <c:out value="${cri.amount == 40?'selected':'' }"/>>40</option>
                            	   		<option value="50" <c:out value="${cri.amount == 50?'selected':'' }"/>>50</option>
                            	   	</select>
								  </div>
                             	 </div>                             	 
                      		 </div><!-- end search -->
                            <!-- start Pagination -->
                            <div class="text-center">
                            	<ul class="pagination">
                            	
                            		<c:if test="${PageVO.prev}">
                            		<li class="paginate_button previous"><a href="${PageVO.startPage-1}">Previous</a>
                            		</c:if>
                            		<c:forEach var="idx" begin="${PageVO.startPage}" end="${PageVO.endPage}">
										<li class="paginate_button ${PageVO.cri.pageNum==idx?'active':''}"><a href="${idx}">${idx}</a></li>                            		</c:forEach>
                            		<c:if test="${PageVO.next}">
                            		<li class="paginate_button next"><a href="${PageVO.endPage+1}">Next</a>
                            		</c:if>
                            	</ul>
                            </div>
                            <!-- end Pagination -->   
                            </div>
                            <!-- end panel-body -->
                        </div>
                        <!-- end panel -->
                    </div>                   
                </div>               
            <!-- /.row -->
            
<%--페이지 번호를 누르면 동작하는 폼 --%>  
<form action="list" id="actionForm">
	<input type="hidden" name="pageNum" value="${PageVO.cri.pageNum}"/>
	<input type="hidden" name="amount" value="${PageVO.cri.amount}"/>
	<input type="hidden" name="type" value="${cri.type}"/>
	<input type="hidden" name="keyword" value="${cri.keyword}"/>
	
</form>          
<!-- 모달 추가 -->
<div class="modal" tabindex="-1" role="dialog" id="myModal">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">게시글 등록</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p>처리가 완료되었습니다.</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <!-- <button type="button" class="btn btn-primary">Save changes</button> -->
      </div>
    </div>
  </div>
</div>
<!-- 스크립트 -->
<script>
	$(function(){
		let result = '${result}';
		
		checkModal(result);
		history.replaceState({}, null,null);
		
		function checkModal(result){
			if(result===''||history.state){
				return;
			}
			
			if(parseInt(result)>0){
				$(".modal-body").html("게시글 "+parseInt(result)+" 번이 등록되었습니다.");
			}
			$("#myModal").modal("show");
		}
	
		//사용자가 페이지 번호를 누르면 동작하는 스크립트
		let actionForm = $("#actionForm");
		
		$(".paginate_button a").click(function(e){
			//a태그 동작 막기
			e.preventDefault();

			//전송해야 할 폼 가져온 후 pageNum 의 값과 amount 값을 변경한 후 
			actionForm.find("input[name='pageNum']").val($(this).attr("href"));
			
			//폼 전송하기
			actionForm.submit();
			
		})
		
		$(".form-control").change(function(){
			//전송해야 할 폼 가져온 후 amount 값을 변경한 후
			actionForm.find("input[name='amount']").val($(this).val());			
			//폼 전송하기
			actionForm.submit();			
		})
		
		//타이틀 클릭시 페이지 나누기 정보가 있는 폼 보내기
		$(".move").click(function(e){
			//태그 동작 막기
			e.preventDefault();
			
			//
			actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'/>");
			
			actionForm.attr('action','read');
			actionForm.submit();
			
			
		})
		
		//검색 버튼 클릭시 동작하는 스크립트
		$(".btn-default").click(function(e){
			let searchForm = $("#searchForm");
			let type = $("select[name='type']").val();
			let keyword = $("input[name='keyword']").val();
			console.log(type);
			//type과 keyword가 비어있는지 확인
			if(type===''){
			//비어 있으면 메세지 띄워준 후 return
				alert("검색조건을 확인해 주세요");
				return false;				
			}else if(keyword===''){
			//비어 있으면 메세지 띄워준 후 return
				alert("검색어를 확인해 주세요");
				return false;				
			}
			searchForm.find("input[name='pageNum']").val("1");
			searchForm.submit();
			
		})
		
		
		
	})
</script>
<%@include file="../includes/footer.jsp" %>       