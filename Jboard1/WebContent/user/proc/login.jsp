<%@page import="kr.co.jboard1.bean.MemberBean"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	String uid 	= request.getParameter("uid");
	String pass = request.getParameter("pass");
	
	// DB정보
	String host = "jdbc:mysql://192.168.10.114:3306/lse";
	String user = "lse";
	String pw	= "1234";
	
	// 1단계 - JDBC 드라이버 로드
	Class.forName("com.mysql.jdbc.Driver");

	// 2단계 - 데이터베이스 접속
	Connection conn = DriverManager.getConnection(host, user, pw);
	
	// 3단계 - SQL 실행객체 생성
	Statement stmt = conn.createStatement();
	
	// 4단계 - SQL 실행
	String sql  = "SELECT * FROM `JBOARD_MEMBER` ";
		   sql += "WHERE `uid`='"+uid+"' AND `pass`=PASSWORD('"+pass+"');";
		  
	ResultSet rs = stmt.executeQuery(sql); // 이 구문을 해줘야 sql 데이터베이스에 전송이 됨
	
	// 5단계 - 결과셋 처리 (SELECT일 경우)
	if(rs.next()){
		// 회원이 맞을 경우
		MemberBean mb = new MemberBean();
		mb.setUid(rs.getString(1));
		mb.setPass(rs.getString(2));
		mb.setName(rs.getString(3));
		mb.setNick(rs.getString(4));
		mb.setEmail(rs.getString(5));
		mb.setHp(rs.getString(6));
		mb.setGrade(rs.getInt(7));
		mb.setZip(rs.getString(8));
		mb.setAddr1(rs.getString(9));
		mb.setAddr2(rs.getString(10));
		mb.setRegip(rs.getString(11));
		mb.setRdate(rs.getString(12));
		
		// 세션 저장
		session.setAttribute("smember", mb);
		
		// 리다이렉트
		response.sendRedirect("/Jboard1/list.jsp");
		
	}else{
		// 회원이 아닐 경우
		response.sendRedirect("/Jboard1/user/login.jsp");
	}
	
	// 6단계 - 데이터베이스 종료
	rs.close();
	stmt.close();
	conn.close();
	
%>