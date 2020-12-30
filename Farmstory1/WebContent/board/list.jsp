<%@page import="kr.co.farmstory1.dao.ArticleDao"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.util.ArrayList"%>
<%@page import="kr.co.farmstory1.bean.ArticleBean"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="kr.co.farmstory1.db.Sql"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="kr.co.farmstory1.db.DBConfig"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_header.jsp"%>
<%
	request.setCharacterEncoding("utf-8");
	String gnb    = request.getParameter("gnb");
	String cate   = request.getParameter("cate");
	String pg 	  = request.getParameter("pg");
	
	String path = "./_aside_"+gnb+".jsp";
	
	
	// 1, 2단계
	Connection conn = DBConfig.getInstance().getConnection();
	// 3단계
	PreparedStatement psmt = conn.prepareStatement(Sql.SELECT_ARTICLES);
	psmt.setString(1, cate);
	// 4단계
	ResultSet rs = psmt.executeQuery();
	// 5단계
	List<ArticleBean> articles = new ArrayList<>();
	
	while(rs.next()){
		ArticleBean article = new ArticleBean();
		article.setSeq(rs.getInt(1));
		article.setParent(rs.getInt(2));
		article.setComment(rs.getInt(3));
		article.setCate(rs.getString(4));
		article.setTitle(rs.getString(5));
		article.setContent(rs.getString(6));
		article.setFile(rs.getInt(7));
		article.setHit(rs.getInt(8));
		article.setUid(rs.getString(9));
		article.setRegip(rs.getString(10));
		article.setRdate(rs.getString(11));
		article.setNick(rs.getString(12));
		
		articles.add(article);
	}

	rs.close();
	psmt.close();
	conn.close();
	
	ArticleDao dao = ArticleDao.getInstance();
	
	// 글 전체 갯수 구하기
	int total = dao.selectCountArticle();
	
	// 전체 페이지 번호 구하기
	int lastPgNum = dao.getLastPgNum(total);

	// 현재 페이지 번호 구하기
	int currentPg = dao.getCurrentPg(pg);
	
	// 게시물 LIMIT 시작번호 구하기
	int limitStart = dao.getLimitStart(currentPg);
	
	// 현재 페이지 글 시작번호 구하기
	int currentStartNum = dao.getCurrentStartNum(total, limitStart);
	
	// 페이지번호 그룹 구하기
	int[] groups = dao.getPageGroup(currentPg, lastPgNum);
%>

<jsp:include page="<%= path %>">
	<jsp:param value="<%= cate %>" name="cate" />
</jsp:include>

<section id="board" class="list">
	<h3>글목록</h3>
	<article>
		<table border="0">
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>글쓴이</th>
				<th>날짜</th>
				<th>조회</th>
			</tr>

			<% for(ArticleBean article : articles){ %>
			<tr>
				<td><%= currentStartNum-- %></td>
				<td><a href="/Farmstory1/board/view.jsp?gnb=<%= gnb %>&cate=<%= cate %>"><%= article.getTitle() %></a>&nbsp;[<%= article.getComment() %>]</td>
				<td><%= article.getNick() %></td>
				<td><%= article.getRdate().substring(2, 10) %></td>
				<td><%= article.getHit() %></td>
			</tr>
			<% } %>

		</table>
	</article>

           <!-- 페이지 네비게이션 -->
            <div class="paging">
                <a href="/Farmstory1/board/list.jsp?gnb=<%= gnb %>&cate=<%= cate %>&pg=<%= groups[0] - 1 %>" class="prev">이전</a>
                <% } %>
                
                <% for(int num=groups[0]; num<=groups[1]; num++){ %>
                <a href="/Farmstory1/board/list.jsp?gnb=<%= gnb %>&cate=<%= cate %>&pg=<%= num %>" class="num <%= (currentPg == num) ? "current" : ""  %>"><%= num %></a>
                <% } %>           
                
                <% if(groups[1] < lastPgNum){ %>                    
                <a href="/Farmstory1/board/list.jsp?gnb=<%= gnb %>&cate=<%= cate %>&pg=<%= groups[1] + 1 %>" class="next">다음</a>
                <% } %>
            </div>

	<!-- 글쓰기 버튼 -->
	<a href="/Farmstory1/board/write.jsp?gnb=<%= gnb %>&cate=<%= cate %>" class="btnWrite">글쓰기</a>
</section>

	<!-- 내용 끝 -->
		</article>
	</section>
</div>
<%@ include file="../_footer.jsp"%>