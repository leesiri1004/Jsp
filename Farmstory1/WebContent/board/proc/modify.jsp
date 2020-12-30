<%@page import="kr.co.farmstory1.dao.ArticleDao"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 파라미터 수신
	request.setCharacterEncoding("UTF-8");
	
	String gnb      = request.getParameter("gnb");
	String cate     = request.getParameter("cate");
	String seq		= request.getParameter("seq");
	String title 	= request.getParameter("title");
	String content  = request.getParameter("content");
	String file		= request.getParameter("file");
	
	// 글 업데이트
	ArticleDao.getInstance().updateArticle(title, content, seq);
	
	// Redirect
	response.sendRedirect("/Farmstory1/board/view.jsp?gnb="+gnb+"&cate="+cate+"&seq="+seq);
%>