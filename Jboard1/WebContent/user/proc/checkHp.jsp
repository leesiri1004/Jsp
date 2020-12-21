<%@page import="com.google.gson.JsonObject"%>
<%@page import="kr.co.jboard1.dao.UserDao"%>
<%@ page contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	
	String hp = request.getParameter("hp");

    // 휴대전화번호 중복확인
	int count = UserDao.getInstance().selectCountHp(hp);
	
	// JSON 출력
	JsonObject json = new JsonObject();
	json.addProperty("result", count);
	
	out.print(json);
%>