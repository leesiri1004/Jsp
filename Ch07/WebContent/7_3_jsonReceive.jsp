<%@page import="com.google.gson.JsonObject"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%


	// 데이터 수신
	request.setCharacterEncoding("UTF-8");
	
	String uid  = request.getParameter("uid");
	String name = request.getParameter("name");
	String hp   = request.getParameter("hp");
	String age  = request.getParameter("age");
	
	// DB정보
	String HOST = "jdbc:mysql://192.168.10.114:3306/lse";
	String USER = "lse";
	String PASS = "1234";

	// 1단계
	Class.forName("com.mysql.jdbc.Driver");
	
	// 2단계
	Connection conn = DriverManager.getConnection(HOST, USER, PASS);
	
	// 3단계
	Statement stmt = conn.createStatement();
	
	// 4단계
	int result = 0;
	try{
		String sql = "INSERT INTO `USER3` VALUES ('"+uid+"', '"+name+"', '"+hp+"', "+age+");";
		result = stmt.executeUpdate(sql);
	} catch (Exception e){
		e.printStackTrace();
	}
	
	// 5단계
	
	// 6단계
	stmt.close();
	conn.close();
	
	// 브라우저로 결과(JSON) 리턴
	JsonObject json = new JsonObject();
	json.addProperty("result", result);
	
	out.print(json);

%>