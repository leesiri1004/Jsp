<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_header.jsp"%>
<%
	request.setCharacterEncoding("utf-8");
	String gnb  = request.getParameter("gnb");
	String cate = request.getParameter("cate");
	
	String path = "./_aside_"+gnb+".jsp";
	
	// 로그인 여부 확인 - 세션에서 사용자 구하기
	MemberBean smember = (MemberBean)session.getAttribute("smember");
	
	if(smember == null){
		// 로그인을 안했으면 로그인 페이지로 이동
		response.sendRedirect("/Farmstory1/user/login.jsp");
		return;
	}	
%>

<jsp:include page="<%= path %>">
	<jsp:param value="<%= cate %>" name="cate" />
</jsp:include>

        <section id="board" class="write">
            <h3>글쓰기</h3>
            <article>
                <form action="/Farmstory1/board/proc/write.jsp" method="post" enctype="multipart/form-data">
                	<input type="hidden" name="gnb" value="<%= gnb %>"/>
                	<input type="hidden" name="cate" value="<%= cate %>"/>
                	<input type="hidden" name="uid" value="<%= smember.getUid() %>"/>
                    <table>
                        <tr>
                            <td>제목</td>
                            <td><input type="text" name="title" placeholder="제목을 입력하세요."/></td>
                        </tr>
                        <tr>
                            <td>내용</td>
                            <td>
                                <textarea name="content"></textarea>                                
                            </td>
                        </tr>
                        <tr>
                            <td>첨부</td>
                            <td><input type="file" name="fName"/></td>
                        </tr>
                    </table>
                    <div>
                        <a href="/Farmstory1/board/list.jsp?gnb=<%= gnb %>&cate=<%= cate %>" class="btnCancel">취소</a>
                        <input type="submit"  class="btnWrite" value="작성완료">
                    </div>
                </form>
            </article>
        </section>
	<!-- 내용 끝 -->
		</article>
	</section>
</div>
<%@ include file="../_footer.jsp"%>