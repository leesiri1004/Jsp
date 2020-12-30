<%@page import="kr.co.farmstory1.bean.ArticleBean"%>
<%@page import="kr.co.farmstory1.dao.ArticleDao"%>
<%@page import="kr.co.farmstory1.bean.FileBean"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="kr.co.farmstory1.db.DBConfig"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="kr.co.farmstory1.db.Sql"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%	
	request.setCharacterEncoding("utf-8");
	
	String filePath = request.getServletContext().getRealPath("/file");
	int maxFileSize = 1024 * 1024 * 10;
	MultipartRequest mRequest = new MultipartRequest(request, 
												 	 filePath, 
		                                         	 maxFileSize, 
		                                         	 "UTF-8", 
		                                         	 new DefaultFileRenamePolicy());
	
	
	String gnb     = mRequest.getParameter("gnb");
	String cate    = mRequest.getParameter("cate");
	String title   = mRequest.getParameter("title");
	String content = mRequest.getParameter("content");
	String fName   = mRequest.getParameter("fName");
	String uid     = mRequest.getParameter("uid");
	String regip   = request.getRemoteAddr();
	
	int file = fName == null ? 0 : 1;
	
	// 1, 2단계
	Connection conn = DBConfig.getInstance().getConnection();
	
	// 3단계	
	PreparedStatement psmt = conn.prepareStatement(Sql.INSERT_ARTICLE);
	psmt.setString(1, cate);
	psmt.setString(2, title);
	psmt.setString(3, content);
	psmt.setInt(4, file);
	psmt.setString(5, uid);
	psmt.setString(6, regip);
	
	// 4단계
	psmt.executeUpdate();
	
	// 5단계
	// 6단계
	psmt.close();
	conn.close();
	
	
	// 게시물 insert 하기	
	ArticleBean ab = new ArticleBean();
	ab.setTitle(title);
	ab.setContent(content);
	ab.setFile(file);
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
	
	response.sendRedirect("/Farmstory1/board/list.jsp?gnb="+gnb+"&cate="+cate);
	
%>