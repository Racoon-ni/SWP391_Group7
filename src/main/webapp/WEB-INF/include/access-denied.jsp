<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String role = (String) request.getAttribute("userRole");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Truy cập bị từ chối</title>
</head>
<body>
    <h1>403 - Truy cập bị từ chối</h1>
    <%
        if ("customer".equals(role)) {
    %>
        <p>Bạn không có quyền truy cập trang quản trị. Vui lòng quay lại trang chủ.</p>
        <a href="home.jsp">Quay về trang chủ</a>
    <%
        } else {
    %>
        <p>Trang này yêu cầu quyền truy cập đặc biệt.</p>
        <a href="home.jsp">Quay về trang chủ</a>
    <%
        }
    %>
</body>
</html>
