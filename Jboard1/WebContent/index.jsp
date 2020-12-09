<%@page import="kr.co.jboard1.bean.MemberBean"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%

	MemberBean mb = (MemberBean)session.getAttribute("smember");

	if(mb == null){
		// if 로그인을 안했으면 login으로 포워드
		pageContext.forward("./user/login.jsp");
		
	}else{
		// 로그인을 했으면 list로 포워드
		pageContext.forward("./list.jsp");
	}

	pageContext.forward("./user/login.jsp");
	//response.sendRedirect("./user/login.jsp");

%>