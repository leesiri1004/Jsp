<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>8-2</title>
</head>
<body>
	<!-- 
		날짜 : 2020/12/02
		이름 : 이슬이
		내용 : useBean 태그 실습하기 교재 p262
		
		useBean 태그
		 - 자바빈의 getter, setter를 실행하기 위한 액션태그 (자바 클래스 파일에서 오른쪽 마우스 클릭 -> Source -> Generate Getters Setters)
		 - 기본적으로 데이터(parameter)를 수신하는 기능을 갖음
		 - JSP 에서는 거의 사용하지않음
	 -->
	 
	<h3>8-2. usebean 태그 실습</h3>
	
	<jsp:useBean id="user" class= "sub1.UserBean">
	<jsp:setProperty name="user" property="name"/>
	<jsp:setProperty name="user" property="gender"/>
	<jsp:setProperty name="user" property="hobby"/>
	<jsp:setProperty name="user" property="addr"/>
	</jsp:useBean>
	
	<p>
		이름 : <%= user.getName() %><br />
		성별 : <%= user.getGender() %><br />
		취미 :
		<%
			for (String hobby : user.getHobby()){
				out.print(hobby+", ");
			}
		%><br />
		주소 : <%= user.getAddr() %><br />	
	</p>
</body>
</html>