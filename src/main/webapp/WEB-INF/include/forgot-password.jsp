<%-- 
    Document   : forgot-password
    Created on : Aug 21, 2025, 2:44:54 AM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Quên mật khẩu</title>
    </head>
    <body>
        <h2>Quên mật khẩu</h2>

        <% String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
    if (error != null) {%>
        <p style="color:red;"><%= error%></p>
        <% } else if (message != null) {%>
        <p style="color:green;"><%= message%></p>
        <% }%>

        <form action="${pageContext.request.contextPath}/forgot-password" method="post">
            <label>Email:</label><br>
            <input type="email" name="email" required/><br><br>
            <button type="submit">Gửi yêu cầu</button>
        </form>

        <a href="${pageContext.request.contextPath}/login">Quay lại đăng nhập</a>
    </body>
</html>

