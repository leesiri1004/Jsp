<%@page import="kr.co.farmstory1.db.Sql"%>
<%@page import="kr.co.farmstory1.db.DBConfig"%>
<%@page import="kr.co.farmstory1.dao.ArticleDao"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 파라미터 수신
	request.setCharacterEncoding("UTF-8");

	String gnb   = request.getParameter("gnb");
	String cate  = request.getParameter("cate");
	String seq   = request.getParameter("seq");
	
	// 1, 2단계
	Connection conn = DBConfig.getInstance().getConnection();
	// 3단계
	PreparedStatement psmt = conn.prepareStatement(Sql.DELETE_ARTICLE);
	psmt.setString(1, seq);
	// 4단계
	psmt.executeUpdate();
	
	psmt.close();
	conn.close();
	
	// Redirect
	response.sendRedirect("/Farmstory1/board/list.jsp?gnb="+gnb+"&cate="+cate);
%>