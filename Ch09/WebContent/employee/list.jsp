<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../9_2_JDBC_Select.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>직원목록</title>
</head>
<body>
	<h3>직원목록</h3> 
	
	<table border="1">
		<tr>
			<th>아이디</th> 
			<th>이름</th>
			<th>휴대폰</th>
			<th>직급</th>
			<th>부서</th>
			<th>등록일</th>
			<th>관리</th>
		</tr>
		<% for(MemberBean mb : members){ %>
		<tr>
			<td><%= mb.getUid() %></td>
			<td><%= mb.getName() %></td>
			<td><%= mb.getHp() %></td>
			<td><%= mb.getPos() %></td>
			<td><%= mb.getDep() %></td>
			<td><%= mb.getRdate().substring(2, 10) %></td>
			<td>
				<a href="./modify.jsp?uid=<%= mb.getUid() %>">수정</a>
				<a href="../9_3_JDBC_Delete.jsp?uid=<%= mb.getUid() %>">삭제</a>
			</td>
		</tr>
		<% } %>
	</table>
</body>
</html>