<%@page import="kr.co.jboard1.bean.FileBean"%>
<%@page import="kr.co.jboard1.db.DBConfig"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
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

	// 파일 첨부
	String filePath = request.getServletContext().getRealPath("/file"); // 파일첨부경로
	int maxFileSize = 1024 * 1024 * 10; // 파일첨부사이즈
	MultipartRequest mRequest = new MultipartRequest(request,
													 filePath,
													 maxFileSize,
													 "UTF-8",
													 new DefaultFileRenamePolicy());
	

	String title 	= mRequest.getParameter("title");
	String content  = mRequest.getParameter("content");
	String fName 	= mRequest.getFilesystemName("fName");
	String regip	= request.getRemoteAddr();
	int hasFile		= (fName == null) ? 0 : 1;
	
	
	// 세션에서 사용자 구하기
	MemberBean mb = (MemberBean)session.getAttribute("smember");
	String uid = mb.getUid();
	
	// 게시물 insert 하기	
	ArticleBean ab = new ArticleBean();
	ab.setTitle(title);
	ab.setContent(content);
	ab.setFile(hasFile);
	ab.setRegip(regip);
	ab.setUid(uid);
	
	int parent = ArticleDao.getInstance().insertArticle(ab);
	
	// 파일을 첨부했을 경우 파일명 변경하기
	if(fName != null){
		
		// 수정할 파일명 생성
		int i 				 = fName.lastIndexOf(".");
		String ext 			 = fName.substring(i);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmss_");
		String now 			 = sdf.format(new Date());
		
		String newName 		 = now+uid+ext;
		
		// 저장된 첨부 파일명 수정
		File oldFile = new File(filePath+"/"+fName); // filePath: C:\Users\bigdata\Desktop\workspace\Jsp\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\Jboard1\file
		File newFile = new File(filePath+"/"+newName);
		oldFile.renameTo(newFile);
		
		// 파일 테이블 Insert
		FileBean fb = new FileBean();
		fb.setParent(parent); // 첨부파일 글번호;
		fb.setOldName(fName);
		fb.setNewName(newName);
		
		ArticleDao.getInstance().insertFile(fb);
	}
	
	// Redirect
	response.sendRedirect("/Jboard1/list.jsp");
%>