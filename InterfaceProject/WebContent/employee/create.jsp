<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%

	// DB정보
	String host = "jdbc:mysql://192.168.10.114:3306/lse";
	String user = "lse";
	String pass = "1234";
	
	// 1단계 - JDBC 드라이버 로드
	Class.forName("com.mysql.jdbc.Driver");
	
	// 2단계 - 데이터베이스 접속
	Connection conn = DriverManager.getConnection(host,user,pass);
	
	// 3단계 - SQL 실행 객체 생성
	Statement stmt = conn.createStatement();
	
	// 4단계 - SQL 실행 객체
	String sql  = "CREATE TABLE `Employee` (";
		   sql += "`uid` VARCHAR(10) PRIMARY KEY, `name` VARCHAR(10), `gender` TINYINT, `hp` CHAR(13), `email` VARCHAR(25), `pos` VARCHAR(10), `dep` TINYINT, `rdate` DATETIME;)";
	stmt.executeUpdate(sql);

	// 5단계 - 결과셋 처리 (SELECT일 경우)
	// 6단계 - 데이터베이스 종료
	stmt.close();
	conn.close();

%>