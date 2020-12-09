<%@page import="kr.co.jboard1.bean.ArticleBean"%>
<%@page import="kr.co.jboard1.dao.ArticleDao"%>
<%@page import="kr.co.jboard1.bean.MemberBean"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 파라미터 수신
	request.setCharacterEncoding("UTF-8");
	
	String title 	= request.getParameter("title");
	String content  = request.getParameter("content");
	String regip	= request.getRemoteAddr();
	
	// 세션에서 사용자 구하기
	MemberBean mb = (MemberBean)session.getAttribute("smember");
	String uid = mb.getUid();
	
	// 게시물 insert 하기
	ArticleBean ab = new ArticleBean();
	ab.setTitle(title);
	ab.setContent(content);
	ab.setRegip(regip);
	ab.setUid(uid);
	
	ArticleDao.getInstance().insertArticle(ab);
	
	// Redirect
	response.sendRedirect("/Jboard1/list.jsp");
%>