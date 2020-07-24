<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%--
	custom Login page 작성 규칙
	1. method = "post" , action="/login" 으로 주기
	2. csrf 토큰값 무조건 포함
	3. 아이디를 입력받는 부분의 이름은 반드시 username으로 하기
	4. 비밀번호를 입력받는 부분의 이름은 반드시 password로 주기

 --%>    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" >
<link rel="stylesheet" href="/resources/css/login.css" />
</head>
<body>
	<form action="/login" method="post" class="form-signin">
		<h1 class="h3 mb-3 font-weight-normal">Sign in</h1>
		<div>
			<label for="id" class="sr-only">아이디</label>
			<input type="text" name="username" placeholder="아이디" class="form-control"  required="required" autofocus="autofocus"/>
		</div>
		<div>
			<label for="password" class="sr-only">비밀번호</label>
			<input type="password" name="password" placeholder="비밀번호" class="form-control"  required="required" />
		</div>
		<div class="checkbox mb-3">
			<label for="remember-me">
				<input type="checkbox" name="remember-me"/>Remember me
			</label>
		</div>		
		<div>
			<button class="btn btn-primary btn-block">Sign in</button>
		</div>
		<div>${error}</div>
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	</form>
</body>
</html>