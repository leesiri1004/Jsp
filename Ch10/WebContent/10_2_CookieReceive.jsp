<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>10-2</title>
</head>
<body>

	<!--
		날짜 : 2020/12/02
		이름 : 이슬이
		내용 : 쿠키 실습하기 교재 p390

		Cookie
		 - 클라이언트와 서버간의 식별을 위해 사용하는 조각파이
		 - 서버에서 쿠키를 생성하고 클라이언트로 전달
		 - 클라이언트는 전달된 쿠키를 보관, 해당 서버로 다시 요청할때 보관된 쿠키를 전송	
	 -->

	<h3>10-2. 쿠키 수신하기</h3>
	<%
	
		Cookie [] cookies = request.getCookies();
	
		for (Cookie cookie : cookies){
	%>
		<p>
			쿠키명 : <%= cookie.getName() %><br />
			쿠키값 : <%= cookie.getValue() %><br />
		</p> 
	<%
		}
	%>
		
</body>
</html>