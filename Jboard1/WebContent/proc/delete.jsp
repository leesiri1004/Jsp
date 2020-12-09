<%@page import="kr.co.jboard1.dao.ArticleDao"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 파라미터 수신
	request.setCharacterEncoding("UTF-8");

	String seq = request.getParameter("seq");
	
	// 글 삭제하기
	ArticleDao.getInstance().deleteArticle(seq);
	
	// Redirect
	response.sendRedirect("/Jboard1/list.jsp");
%>