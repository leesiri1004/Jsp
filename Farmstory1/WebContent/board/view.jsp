<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="kr.co.farmstory1.db.Sql"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="kr.co.farmstory1.db.DBConfig"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.farmstory1.bean.ArticleBean"%>
<%@page import="kr.co.farmstory1.dao.ArticleDao"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_header.jsp"%>
<%
	request.setCharacterEncoding("utf-8");
	String gnb  = request.getParameter("gnb");
	String cate = request.getParameter("cate");
	String seq = request.getParameter("seq");
	
	String path = "./_aside_"+gnb+".jsp";
	
	// 조회글 가져오기
	// 1, 2단계
	Connection conn = DBConfig.getInstance().getConnection();
	// 3단계
	PreparedStatement psmt = conn.prepareStatement(Sql.SELECT_ARTICLE);
	psmt.setString(1, seq);
	// 4단계
	ResultSet rs = psmt.executeQuery();
	// 5단계
	ArticleBean ab = new ArticleBean();

	if (rs.next()) {
		ab.setSeq(rs.getInt(1));
		ab.setParent(rs.getInt(2));
		ab.setComment(rs.getInt(3));
		ab.setCate(rs.getString(4));
		ab.setTitle(rs.getString(5));
		ab.setContent(rs.getString(6));
		ab.setFile(rs.getInt(7));
		ab.setHit(rs.getInt(8));
		ab.setUid(rs.getString(9));
		ab.setRegip(rs.getString(10));
		ab.setRdate(rs.getString(11));
		ab.setFileSeq(rs.getInt(12));
		ab.setOldName(rs.getString(13));
		ab.setDownload(rs.getInt(14));
		}

	rs.close();
	psmt.close();
	conn.close();
	
	// 조회수 업데이터
	ArticleDao.getInstance().updateHit(seq);
	
	// 댓글 가져오기
	List<ArticleBean> comments = ArticleDao.getInstance().selectComments(seq);
%>

<jsp:include page="<%= path %>">
	<jsp:param value="<%= cate %>" name="cate" />
</jsp:include>

        <section id="board" class="view">
            <h3>글보기</h3>
            <table>
                <tr>
                    <td>제목</td>
                    <td><input type="text" name="title" value="<%= ab.getTitle() %>" readonly/></td>
                </tr>
                <% if(ab.getFile() != 0){ %>
                <tr>
                    <td>첨부파일</td>
                    <td>
                        <a href="/Farmstory1/board/proc/download.jsp?seq=<%= ab.getFileSeq() %>"><%= ab.getOldName()%></a>
                        <span><%= ab.getDownload() %>회 다운로드</span>
                    </td>
                </tr>
                <% } %>
                <tr>
                    <td>내용</td>
                    <td>
                        <textarea name="content" readonly><%= ab.getContent() %></textarea>
                    </td>
                </tr>
            </table>
            <div>
                <a href="/Farmstory1/board/proc/delete.jsp?seq=<%= ab.getSeq() %>" class="btnDelete">삭제</a>
                <a href="/Farmstory1/board/modify.jsp?gnb=<%= gnb %>&cate=<%= cate %>" class="btnModify">수정</a>
                <a href="/Farmstory1/board/list.jsp?gnb=<%= gnb %>&cate=<%= cate %>" class="btnList">목록</a>
            </div>
            
            <!-- 댓글리스트 -->
            <section class="commentList">
                <h3>댓글목록</h3>
                <article class="comment">
                    <span>
                        <span>길동이</span>
                        <span>20-12-29</span>
                    </span>
                    <textarea name="comment" readonly>댓글입니다.</textarea>
                    <div>
                        <a href="#" class="cmtDelete">삭제</a>
                        <a href="#" class="cmtModify">수정</a>                        
                    </div>
                </article>
                <p class="empty">
                    등록된 댓글이 없습니다.
                </p>
            </section>

            <!-- 댓글입력폼 -->
            <section class="commentForm">
                <h3>댓글쓰기</h3>
                <form action="#" method="post">                	
                    <textarea name="comment"></textarea>
                    <div>
                        <a href="#" class="btnCancel">취소</a>
                        <input type="submit" class="btnWrite" value="작성완료"/>
                    </div>
                </form>
            </section>
<!-- 내용 끝 -->
		</article>
	</section>
</div>
<%@ include file="../_footer.jsp"%>