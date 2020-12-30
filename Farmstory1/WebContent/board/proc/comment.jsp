<%@page import="kr.co.farmstory1.dao.ArticleDao"%>
<%@page import="kr.co.farmstory1.bean.ArticleBean"%>
<%@page import="kr.co.farmstory1.bean.MemberBean"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 파라미터 수신
	request.setCharacterEncoding("UTF-8");

	String gnb     = request.getParameter("gnb");
	String cate    = request.getParameter("cate");
	String parent  = request.getParameter("parent");
	String comment = request.getParameter("comment");
	String regip   = request.getRemoteAddr();
	
	// 현재 댓글을 작성하는 사용자 아이디 구하기
	MemberBean smember = (MemberBean)session.getAttribute("smember");
	String uid = smember.getUid();
	
	// 댓글 쓰기 기능
	ArticleBean ab = new ArticleBean();
	ab.setParent(parent);
	ab.setContent(comment);
	ab.setUid(uid);
	ab.setRegip(regip);

	// 댓글 INSERT
	ArticleDao.getInstance().insertComment(ab);
	
	// 원글 댓글 카운트 UPDATE
	ArticleDao.getInstance().updateCommentCount(parent);
	
	// 리다이렉트
	response.sendRedirect("/Farmstory1/board/view.jsp?gnb="+gnb+"&cate="+cate+"&seq="+parent);
%>