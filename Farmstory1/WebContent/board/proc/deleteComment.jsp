<%@page import="kr.co.farmstory1.dao.ArticleDao"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");

	String seq    = request.getParameter("seq");
	String parent = request.getParameter("parent");
	
	// 댓글삭제
	ArticleDao.getInstance().deleteComment(seq);
	
	// 원글 댓글 카운트 -1
	ArticleDao.getInstance().updateArticleComment(parent);
	
	// 리다이렉트
	response.sendRedirect("/Farmstory/view.jsp?seq="+parent);
%>