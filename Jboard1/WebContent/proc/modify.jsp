<%@page import="kr.co.jboard1.dao.ArticleDao"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="kr.co.jboard1.bean.ArticleBean"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 파라미터 수신
	request.setCharacterEncoding("UTF-8");
	
	String seq		= request.getParameter("seq");
	String title 	= request.getParameter("title");
	String content  = request.getParameter("content");
	String file		= request.getParameter("file");
	
	// 글 업데이트
	ArticleDao.getInstance().updateArticle(title, content, seq);
	
	// Redirect
	response.sendRedirect("/Jboard1/view.jsp?seq="+seq); // 다른 방법은: "../view.jsp?seq="+seq
%>