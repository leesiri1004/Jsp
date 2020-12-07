<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	String uid 		= request.getParameter("uid");
	String pass1 	= request.getParameter("pass1");
	String pass2 	= request.getParameter("pass2");
	String name 	= request.getParameter("name");
	String nick 	= request.getParameter("nick");
	String email 	= request.getParameter("email");
	String hp 		= request.getParameter("hp");
	String zip 		= request.getParameter("zip");
	String addr1 	= request.getParameter("addr1");
	String addr2 	= request.getParameter("addr2");
	String regip 	= request.getRemoteAddr();

	// DB정보
	String host = "jdbc:mysql://192.168.10.114:3306/lse";
	String user = "lse";
	String pass = "1234";
	
	// 1단계 - JDBC 드라이버 로드
	Class.forName("com.mysql.jdbc.Driver");

	// 2단계 - 데이터베이스 접속
	Connection conn = DriverManager.getConnection(host, user, pass);
	
	// 3단계 - SQL 실행객체 생성
	Statement stmt = conn.createStatement();
	
	// 4단계 - SQL 실행
	String sql  = "INSERT INTO `JBOARD_MEMBER` SET ";
		   sql += "`uid`='"+uid+"',";
		   sql += "`pass`= PASSWORD('"+pass1+"'),";
		   sql += "`name`='"+name+"',";
		   sql += "`nick`='"+nick+"',";
		   sql += "`email`='"+email+"',";
		   sql += "`hp`='"+hp+"',";
		   sql += "`zip`='"+zip+"',";
		   sql += "`addr1`='"+addr1+"',";
		   sql += "`addr2`='"+addr2+"',";
		   sql += "`regip`='"+regip+"',";
		   sql += "`rdate`= NOW();";
		  
	stmt.executeUpdate(sql); // 이 구문을 해줘야 sql 데이터베이스에 전송이 됨
	
	// 5단계 - 결과셋 처리 (SELECT일 경우)

	
	// 6단계 - 데이터베이스 종료
	stmt.close();
	conn.close();
	
	// 리다이렉트
	response.sendRedirect("/Jboard1/user/login.jsp");


%>