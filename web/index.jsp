<%--
  Created by IntelliJ IDEA.
  User: Tnze
  Date: 2020/6/5
  Time: 上午 01:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    if (!"login".equals(session.getAttribute("status")))
        response.sendRedirect("login.jsp");
%>
<html>
<head>
    <title>学生信息管理系统</title>
</head>
<body>

</body>
</html>