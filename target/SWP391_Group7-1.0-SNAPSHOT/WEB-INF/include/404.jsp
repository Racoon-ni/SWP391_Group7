<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = (String) request.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Không tìm thấy trang</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f1f1f1;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            text-align: center;
            padding: 30px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            width: 100%;
        }

        h1 {
            font-size: 100px;
            color: #2c3e50;
            margin-bottom: 20px;
        }

        h2 {
            font-size: 24px;
            color: #7f8c8d;
            margin-bottom: 20px;
        }

        p {
            font-size: 18px;
            color: #34495e;
        }

        .icon {
            margin: 20px 0;
        }

        .icon img {
            width: 80px;
            height: 80px;
        }

        a {
            text-decoration: none;
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            border-radius: 5px;
            font-size: 18px;
            margin-top: 20px;
            transition: background-color 0.3s;
        }

        a:hover {
            background-color: #2980b9;
        }

        .btn-back {
            display: inline-block;
            margin-top: 20px;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>404</h1>
        <h2>Không tìm thấy trang</h2>

        <div class="icon">
            <img src="https://img.icons8.com/ios/452/search.png" alt="magnifying-glass">
        </div>

        <%
            if ("admin".equals(role)) {
        %>
        <p>Xin lỗi Quản trị viên! Trang bạn yêu cầu không tồn tại.</p>
        <a href="admin-dashboard.jsp" class="btn-back">Quay về quản lý</a>
        <%
            } else if ("customer".equals(role)) {
        %>
        <p>Xin lỗi! Trang bạn đang truy cập không hợp lệ.</p>
        <a href="home.jsp" class="btn-back">Về trang chủ</a>
        <%
            } else {
        %>
        <p>Trang này không tồn tại hoặc bạn không có quyền truy cập.</p>
        <a href="home.jsp" class="btn-back">Trang chủ</a>
        <%
            }
        %>
    </div>

</body>
</html>
