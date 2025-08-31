<%-- 
    Document   : reset-password
    Created on : Aug 21, 2025, 2:45:28 AM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt lại mật khẩu</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: "Poppins", sans-serif;
        }
        .card {
            border-radius: 20px;
            backdrop-filter: blur(15px);
            background: rgba(255, 255, 255, 0.15);
            box-shadow: 0 8px 25px rgba(0,0,0,0.25);
            color: #fff;
        }
        .form-control {
            border-radius: 12px;
            background-color: rgba(255,255,255,0.9);
            border: none;
            padding: 12px 15px;
            font-size: 15px;
        }
        .form-control:focus {
            box-shadow: 0 0 8px rgba(255,255,255,0.8);
        }
        .btn-custom {
            border-radius: 12px;
            font-weight: 600;
            padding: 12px;
            transition: 0.3s;
        }
        .btn-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(0,0,0,0.3);
        }
        .icon-box {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 35px;
            margin: 0 auto 20px auto;
            color: #fff;
        }
        .back-link {
            display: block;
            margin-top: 15px;
            text-align: center;
            font-size: 14px;
            color: #eee;
            text-decoration: none;
        }
        .back-link:hover {
            color: #fff;
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card p-4 text-center">
                <div class="icon-box">
                    <i class="bi bi-shield-lock-fill"></i>
                </div>
                <h3 class="fw-bold mb-3">Đặt lại mật khẩu</h3>
                <p class="small mb-4">Nhập mật khẩu mới để hoàn tất quá trình đặt lại.</p>

                <% String error = (String) request.getAttribute("error");
                   String message = (String) request.getAttribute("message");
                   if (error != null) { %>
                    <div class="alert alert-danger py-2"><%= error %></div>
                <% } else if (message != null) { %>
                    <div class="alert alert-success py-2"><%= message %></div>
                <% } %>

                <form action="reset-password" method="post">
                    <input type="hidden" name="token" value="<%= request.getParameter("token") %>"/>

                    <div class="mb-3 text-start">
                        <label class="form-label text-white-50"><i class="bi bi-lock-fill"></i> Mật khẩu mới</label>
                        <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu mới" required/>
                    </div>

                    <div class="mb-3 text-start">
                        <label class="form-label text-white-50"><i class="bi bi-shield-check"></i> Xác nhận mật khẩu</label>
                        <input type="password" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu" required/>
                    </div>

                    <button type="submit" class="btn btn-light w-100 btn-custom">
                        <i class="bi bi-arrow-repeat me-2"></i> Đặt lại mật khẩu
                    </button>
                </form>

                <a href="${pageContext.request.contextPath}/login" class="back-link">
                    <i class="bi bi-arrow-left-circle me-1"></i> Quay lại đăng nhập
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
