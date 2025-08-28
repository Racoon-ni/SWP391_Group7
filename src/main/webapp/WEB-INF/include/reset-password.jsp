<%-- 
    Document   : reset-password
    Created on : Aug 21, 2025, 2:45:28 AM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đặt lại mật khẩu</title>
</head>
<body>
<h2>Đặt lại mật khẩu</h2>

<% String error = (String) request.getAttribute("error");
   String message = (String) request.getAttribute("message");
   if (error != null) { %>
    <p style="color:red;"><%= error %></p>
<% } else if (message != null) { %>
    <p style="color:green;"><%= message %></p>
<% } %>

<form action="reset-password" method="post">
    <input type="hidden" name="token" value="<%= request.getParameter("token") %>"/>
    
    <label>Mật khẩu mới:</label><br>
    <input type="password" name="password" required/><br><br>
    
    <label>Xác nhận mật khẩu:</label><br>
    <input type="password" name="confirmPassword" required/><br><br>
    
    <button type="submit">Đặt lại mật khẩu</button>
</form>
</body>
</html>
