<!-- header.jsp -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>PC Store</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" />

        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />

        <!-- Google Font -->
        <link href="https://fonts.googleapis.com/css2?family=Annie+Use+Your+Telescope&display=swap" rel="stylesheet" />

        <style>
            body {
                font-family: Arial, sans-serif;
            }
            .shadowed-navbar {
                border-bottom: 2px solid black;
                box-shadow: 0px 8px 8px -4px rgba(0, 0, 0, 0.4);
                z-index: 1030;
                padding: 0 10px;
                margin-bottom: 20px;
            }
            .annie-use-your-telescope {
                font-family: "Annie Use Your Telescope", cursive;
            }
        </style>
    </head>

    <body>
        <nav class="navbar navbar-expand-lg navbar-light bg-light shadowed-navbar">
            <div class="container-fluid">
                <a class="navbar-brand fw-bold annie-use-your-telescope" href="${pageContext.request.contextPath}/home" style="font-size: 4rem">
                    <span style="color: orange">PC</span><span style="color: black"> Store</span>
                </a>

                <%@ include file="../include/top-nav.jsp" %>

                <form action="/search" method="GET" style="width: 30%; margin-top: 10px; margin-right: 10px">
                    <div class="position-relative">
                        <input type="text" name="query" class="form-control pe-5" placeholder="Bạn cần tìm kiếm gì?" required style="border-radius: 16px" />
                        <button type="submit" class="btn position-absolute top-50 end-0 translate-middle-y pe-3 border-0 bg-transparent">
                            <i class="fas fa-search text-muted"></i>
                        </button>
                    </div>
                </form>

                <div class="d-flex gap-5">
                    <c:if test="${not empty user}">
                        <div class="dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                Chào, ${user.username}
                                <i class="fa-regular fa-circle-user" style="font-size: large"></i>
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/view-profile">Thông tin tài khoản</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng Xuất</a></li>
                            </ul>
                        </div>
                    </c:if>
                    <c:if test="${empty user}">
                        <a class="nav-link" href="${pageContext.request.contextPath}/login">
                            <i class="fa-regular fa-user"></i> Đăng nhập/Đăng ký
                        </a>
                    </c:if>

                    <a class="nav-link" href="#"><i class="fas fa-desktop"></i> build PC</a>
                     <a class="nav-link" href="${pageContext.request.contextPath}/my-carts"><i class="fas fa-shopping-cart"></i> Giỏ hàng</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/my-orders"><i class="fas fa-receipt"></i> Đơn hàng của tôi</a>
                </div>
            </div>
        </nav>

        <!-- Bootstrap Bundle JS (Popper included) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
