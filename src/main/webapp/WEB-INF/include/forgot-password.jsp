<%-- 
    Document   : forgot-password
    Created on : Aug 21, 2025, 2:44:54 AM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
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
            background-color: rgba(255,255,255,0.85);
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
                    <i class="bi bi-key-fill"></i>
                </div>
                <h3 class="fw-bold mb-3">Quên mật khẩu</h3>
                <p class="small mb-4">Nhập email đã đăng ký để nhận hướng dẫn đặt lại mật khẩu.</p>

                <% String error = (String) request.getAttribute("error");
                   String message = (String) request.getAttribute("message");
                   if (error != null) { %>
                    <div class="alert alert-danger py-2"><%= error %></div>
                <% } else if (message != null) { %>
                    <div class="alert alert-success py-2"><%= message %></div>
                <% } %>

                <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                    <div class="mb-3 text-start">
                        <label class="form-label text-white-50"><i class="bi bi-envelope-at-fill"></i> Email</label>
                        <input type="email" name="email" class="form-control" placeholder="Nhập email của bạn" required/>
                    </div>
                    <button type="submit" class="btn btn-light w-100 btn-custom">
                        <i class="bi bi-send-fill me-2"></i>Gửi yêu cầu
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


