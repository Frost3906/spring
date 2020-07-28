<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@include file="../includes/header.jsp" %>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board Modify</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>            
            <div class="row">
                <div class="col-lg-12">
                	<div class="panel panel-default">
                        <div class="panel-heading">
                           Board Modify Page
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                			<form action="" method="post" role="form">
                				<div class="form-group">
                					<label>Bno</label>
                					<input class="form-control" name="bno" readonly="readonly"  value="${vo.bno}">                				
                				</div> 
                				<div class="form-group">
                					<label>Title</label>
                					<input class="form-control" name="title" value="${vo.title}">                				
                				</div>  
                				<div class="form-group">
                					<label>Content</label>
                					<textarea class="form-control" rows="3" name="content">${vo.content}</textarea>               				
                				</div> 
                				<div class="form-group">
                					<label>Writer</label>
                					<input class="form-control" name="writer" readonly="readonly" value="${vo.writer}">                				
                				</div>
                				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                				<sec:authentication property="principal" var="info"/>
                				<sec:authorize access="isAuthenticated()">
                					<c:if test="${info.username == vo.writer}">
	    	            				<button type="submit" data-oper='modify' class="btn btn-default">Modify</button>              			
    	    	        				<button type="submit" data-oper='delete' class="btn btn-danger">Remove</button>              			
                					</c:if>
                				</sec:authorize>  
                				<button type="submit" data-oper='list' class="btn btn-info">List</button>              			
                			</form>
                		</div>
                	</div>
                </div>
            </div>
<!-- 첨부파일 영역 -->            
<div class="bigPictureWrapper">
	<div class="bigPicture"></div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading"><i class="fa fas fa-file"></i> Files</div>
			<div class="panel-body">
						<div class="form-group uploadDiv">
							<input type="file" name="uploadFile" multiple="multiple" />
						</div>				
				<div class="uploadResult">
					<ul></ul>
				</div>
			</div>
		</div>
	</div>
</div> 

            
			<%-- remove와 list를 위한 폼--%>
<form method="post" id="myform">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	<input type="hidden" name="bno" value="${vo.bno}"/>
	<input type="hidden" name="writer" value="${vo.writer}"/>
	<input type="hidden" name="pageNum" value="${cri.pageNum}"/>
	<input type="hidden" name="amount" value="${cri.amount}"/>
	<input type="hidden" name="type" value="${cri.type}"/>
	<input type="hidden" name="keyword" value="${cri.keyword}"/>
</form>
<script>
$(function(){
	
	//csrf 토큰 값 생성
	let csrfHeaderName = "${_csrf.headerName}";
	let csrfTokenValue = "${_csrf.token}";
	
	
	$("input[type='file']").change(function(){
		
		
		
		//form의 형태로 데이터를 구성할 수 있음
		let formData = new FormData();
		
		//첨부파일 목록 가져오기
		let uploadFile = $("input[name='uploadFile']");
		console.log(uploadFile);
		let files= uploadFile[0].files;
		console.log(files);
		
		//form의 형태로 붙이기
		for(var i=0;i<files.length;i++){
			if(!checkExtension(files[i].name, files[i].size)){
				return false;
			}
			
			formData.append("uploadFile",files[i]);
		}
		
		
		//processData : 데이터를 query string으로 변환할 것인지 결정
		//				기본값은 application/x-www-form-urlencoded로 true 이므로 false 지정
		
		
		//contentType : 기본값은 application/x-www-form-urlencoded
		//				파일의 경우에 enctype은  multipart/form-data로 보내야 하기 때문에 false로 지정
		
		
		$.ajax({
			url : '/upload',
			type : 'post',
			beforeSend : function(xhr){
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			processData : false,
			contentType : false,
			data : formData,

			success:function(result){
				console.log(result);
				showUploadFile(result);
			},
			error:function(xhr,status,error){
				alert(xhr.responseText);
			}
		})
		
	})
	
	
	//업로드 된 파일 보여주기
	function showUploadFile(uploadResultArr){
		//결과를 보여줄 영역 가져오기
		let str = "";
		let uploadResult = $(".uploadResult ul");
		$(uploadResultArr).each(function(i,element){
			if(element.fileType){//이미지 파일
				//섬네일 이미지 경로
				var fileCallPath = encodeURIComponent(element.uploadPath+"\\s_"+element.uuid+"_"+element.fileName);
				//원본 이미지 경로
				var oriPath = element.uploadPath+"\\"+element.uuid+"_"+element.fileName;
				oriPath = oriPath.replace(new RegExp(/\\/g),"/");
				
				str += "<li data-path='"+element.uploadPath+"' data-uuid='"+element.uuid+"'";
				str += " data-filename='"+element.fileName+"' data-type='"+element.fileType+"'>";					
				str += "<a href=\"javascript:showImage(\'"+oriPath+"\')\">";
				str += "<img src='/display?fileName="+ fileCallPath+"'><div>"+element.fileName+"</a>";
				str += "<button type='button' class='btn btn-danger btn-circle btn-sm'>";
				str += "<i class = 'fa fa-times'></i></button>";
				str += "</div></li>";
			}else{
				var fileCallPath = encodeURIComponent(element.uploadPath+"\\"+element.uuid+"_"+element.fileName);
				str += "<li data-path='"+element.uploadPath +"' data-uuid='"+element.uuid+"'";
				str += " data-filename='"+element.fileName+"' data-type='"+element.fileType+"'>";
				str += "<a href='/download?fileName="+fileCallPath+"'>";
				str += "<img src='/resources/img/attach.png'><div>" + element.fileName+"</a>"
				str += "<button type='button' class='btn btn-danger btn-circle btn-sm'>";
				str += "<i class = 'fa fa-times'></i></button>";
				str += "</div></li>";
			}				
		})
		uploadResult.append(str);
	}
	
	
	
	
	
	
	//첨부파일 제한 / 크기 제한
	function checkExtension(fileName, fileSize){
		let regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		let maxSize = 2097152;
		
		if(fileSize > maxSize){
			alert("파일 사이즈 초과");
			return false;
		}
		if(regex.test(fileName)){
			alert("해당 종류의 파일은 업로드 할 수 없습니다.");
			return false;
		}
		return true;
	}

	
	//현재글의 글번호 가져오기
	let bno = ${vo.bno};
	
	
	
	//첨부파일 스크립트 시작
	
	//bno를 보내서 해당 게시물의 첨부파일 내역 가져오기 => ajax
	//http://~~~~/board/getAttachList
	$.getJSON("getAttachList",{bno:bno}, function(data){
		console.log(data); //json 현태로 데이터 도착
	
	
		let str = "";
		//첨부파일 목록을 보여줄 영역 찾아오기
		let uploadResult = $(".uploadResult ul");
	
		$(data).each(function(i,element){
			if(element.fileType){
				var fileCallPath = encodeURIComponent(element.uploadPath+"\\s_"+element.uuid+"_"+element.fileName);
			
				str += "<li data-path='"+ element.uploadPath + "' data-uuid='"+element.uuid+"'";
				str += " data-filename='"+element.fileName+"' data-type='" +element.fileType+"'>";
				str += "<div><span><a>"+element.fileName+"</span></a>";
				str += "<button type='button' class='btn btn-danger btn-circle btn-sm' data-file='"+fileCallPath+"' data-type='image'>";
				str += "<i class = 'fa fa-times'></i></button>";
				str += "</div>";
				str += "<img src='/display?fileName="+fileCallPath+"'></li>";
			}else{//일반파일
				var fileCallPath = encodeURIComponent(element.uploadPath+"\\"+element.uuid+"_"+element.fileName);
				
				str += "<li data-path='"+ element.uploadPath + "' data-uuid='"+element.uuid+"'";
				str += " data-filename='"+element.fileName+"' data-type='" +element.fileType+"'>";
				str += "<div><span><a>"+element.fileName+"</span></a>";
				str += "<button type='button' class='btn btn-danger btn-circle btn-sm' data-file='"+fileCallPath+"' data-type='file'>";
				str += "<i class = 'fa fa-times'></i></button>";
				str += "</div>";
				str += "<img src='/resources/img/attach.png'></li>";
			}	
		
		
		})
		uploadResult.html(str);
	
	})//첨부파일 내역 종료
	
	
	//이벤트 위임(li태그가 나주엥 생기는 부분이기 때문에)
	$(".uploadResult").on("click","li",function(){
		//이미지 파일은 크게 보여주고, 일반 파일은 다운로드 창 띄우기
		
		
		//클릭된 객체 가져오기
		let liObj = $(this);
		
		var fileCallPath = encodeURIComponent(liObj.data("path")+"\\"+liObj.data("uuid")+"_"+liObj.data("filename"));
		if(liObj.data("type")){
			showImage(fileCallPath.replace(new RegExp(/\\/g),"/"));
		}else{
			location.href="/download?fileName="+fileCallPath;
		}
		
	
	}) //첨부파일 처리 종료
	//확대사진 닫기
	$(".bigPictureWrapper").on("click",function(){
		$(".bigPicture").animate({width: '0%', height:'0%'},1000);
		setTimeout(function(){
			$(".bigPictureWrapper").hide();				
		}, 1000);
	})
	
	//X를 누르면 목록에서 삭제 하기
	$(".uploadResult").on("click","button",function(e){
	
		if(confirm("파일을 삭제하시겠습니까?")){
			
			let targetLi = $(this).closest("li");
			targetLi.remove();		
		}
		
		//다음 이벤트 발생을 막기
		e.stopPropagation();
	})
	
	
	//첨부파일 스크립트 종료
	
	
})
	
	
	
</script>



<script>
$(function(){
	let form = $("#myform");
	
	$("button").click(function(e){
		//submit 속성 중지
		e.preventDefault();	
		
		//버튼 판별
		let oper = $(this).data("oper");
		if(oper==='modify'){
			form = $("form[role='form']");
			//첨부파일 정보를 수집해서 수정버튼이 눌러지면 다시 보내기
			let str = "";
			
			$(".uploadResult ul li").each(function(i,ele){
				let job = $(ele);
				console.log(job);
				
				str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+job.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+job.data("path")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+job.data("filename")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+job.data("type")+"'>";			
			})
			console.log(str);
			form.append(str);
			
			
		}
		else if(oper==='delete'){
			form.attr('action','delete');
		}
		else if(oper==='list'){
			form.attr('action','list');
			form.attr('method','get')
			form.find("input[name='bno']").remove();
		}
		form.submit();
	})
		
})

</script>
			<%-- 스크립트 --%>
<%@include file="../includes/footer.jsp" %>       