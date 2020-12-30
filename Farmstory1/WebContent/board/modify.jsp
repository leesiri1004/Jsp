<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_header.jsp"%>
<%
	request.setCharacterEncoding("utf-8");
	String gnb  = request.getParameter("gnb");
	String cate = request.getParameter("cate");
	
	String path = "./_aside_"+gnb+".jsp";
%>

<jsp:include page="<%= path %>">
	<jsp:param value="<%= cate %>" name="cate" />
</jsp:include>

        <section id="board" class="modify">
            <h3>글수정</h3>
            <article>
                <form action="/Farmstory1/board/proc/modify.jsp" method="post">
                    <table>
                        <tr>
                            <td>제목</td>
                            <td><input type="text" name="title" value="제목입니다." placeholder="제목을 입력하세요."/></td>
                        </tr>
                        <tr>
                            <td>내용</td>
                            <td>
                                <textarea name="content">내용입니다.</textarea>                                
                            </td>
                        </tr>
                        <tr>
                            <td>첨부</td>
                            <td><input type="file" name="file"/></td>
                        </tr>
                    </table>
                    <div>
                        <a href="/Farmstory1/board/view.jsp?gnb=<%= gnb %>&cate=<%= cate %>" class="btnCancel">취소</a>
                        <input type="submit"  class="btnWrite" value="수정완료">
                    </div>
                </form>
            </article>
        </section>
        
   	<!-- 내용 끝 -->
		</article>
	</section>
</div>
<%@ include file="../_footer.jsp"%>