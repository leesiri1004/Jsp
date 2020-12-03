<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 전송되는 파라미터 인코딩 설정
	request.setCharacterEncoding("UTF-8");
	
	// 전송되어 전달되는 데이터 (파라미터) 수신
	String uid 		= request.getParameter("uid");
	String pass 	= request.getParameter("pass");
	
	String name 	= request.getParameter("name");
	String gender 	= request.getParameter("gender");
	String[] hobbies= request.getParameterValues("hobby"); //values=>배열 []
	String addr 	= request.getParameter("addr");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>4-1</title>
</head>
<body>

	<!-- 
		날짜 : 2020/12/01
		이름 : 이슬이
		내용 : request 내장객체 교재 p143
		
		request 내장객체
		 - Client의 요청 정보를 갖는 객체
		 - Client의 전송 데이터(Parameter)를 수신하는 기능을 갖음 (.getParameter)
	 -->


	<h3>4-1. JSP Request 내장객체</h3>

	<% if(uid != null){%>
	<h4>로그인 정보</h4>
	<p>
		입력한 아이디	 : <%= uid %><br/>
		입력한 비밀번호 	 : <%= pass %><br/>
	</p>
	
	<a href="./user/login.jsp">로그인 하기</a>
	<a href="/Ch04/user/register.jsp">회원가입 하기</a>
	
	<% }else {%>
	<h4>회원가입 정보</h4>
	<p>
		입력한 이름 : <%= name %><br/>
		입력한 성별 : <%= gender %><br/>
		입력한 취미 :
		<% 
			for(String hobby : hobbies){
				out.print(hobby+", ");
			}
		%>
		<br/>
		입력한 주소 : <%= addr %><br/>
	</p>
	
	<a href="./user/login.jsp">로그인 하기</a>	
	<a href="/Ch04/user/register.jsp">회원가입 하기</a>
	
	<% } %>
	
	
	<h3>Client 정보 출력</h3>
	<p>
		헤더정보 	: <%= request.getHeader("User-Agent") %><br />
		통신규약 	: <%= request.getProtocol() %><br />
		서버이름 	: <%= request.getServerName() %><br />
		요청주소 	: <%= request.getRequestURL() %><br />
		요청경로 	: <%= request.getRequestURI() %><br />
		사용자 IP : <%= request.getRemoteAddr() %><br />
		
		
	</p>
</body>
</html>






