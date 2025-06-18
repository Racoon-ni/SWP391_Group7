<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = (String) request.getAttribute("userRole");
%>
<!DOCTYPE html>
<html>
<head>
    <title>404 - Không tìm thấy trang</title>
</head>
<body>
    <h1>404 - Không tìm thấy trang</h1>
    <%
        if ("admin".equals(role)) {
    %>
        <p>Xin lỗi Quản trị viên! Trang bạn yêu cầu không tồn tại.</p>
        <a href="admin-dashboard.jsp">Quay về quản lý</a>
    <%
        } else if ("customer".equals(role)) {
    %>
        <p>Xin lỗi! Trang bạn đang truy cập không hợp lệ.</p>
        <a href="home.jsp">Về trang chủ</a>
    <%
        } else {
    %>
        <p>Trang này không tồn tại hoặc bạn không có quyền truy cập.</p>
        <a href="home.jsp">Trang chủ</a>
    <%
        }
    %>
</body>
</html>
