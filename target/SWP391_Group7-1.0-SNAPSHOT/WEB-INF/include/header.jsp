<%-- 
    Document   : header
    Created on : Jun 17, 2025, 7:59:35 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>PC Store</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Annie+Use+Your+Telescope&display=swap" rel="stylesheet">

        <style>
            body {
                font-family: Arial, sans-serif;
            }
            .product-card img {
                max-width: 100%;
            }
            .pc-bestseller {
                padding: 5px 15px;
                overflow: auto;
            }
            .shadowed-navbar {
                border-bottom: 2px solid black; /* Solid black line */
                box-shadow: 0px 8px 8px -4px rgba(0, 0, 0, 0.4); /* Dark shadow */
                z-index: 1030; /* Keeps it on top */
                margin-bottom: 20px;
            }
            .annie-use-your-telescope {
                font-family: "Annie Use Your Telescope", cursive;
            }

        </style>
    </head>
    <body>

        <nav class="navbar navbar-expand-lg navbar-light bg-light shadowed-navbar ">
            <div class="container-fluid">
                <a class="navbar-brand fw-bold annie-use-your-telescope" 
                   href="${pageContext.request.contextPath}/home" 
                   style="font-size: 4rem;">
                    <span style="color: orange;">PC</span><span style="color: black;"> Store</span>
                </a>

                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <form action="/search" method="GET" class="w-50">
                    <div class="position-relative">
                        <input type="text" name="query" class="form-control pe-5" placeholder="Bạn cần tìm kiếm gì?" required style="border-radius: 16px">
                        <button type="submit" class="btn position-absolute top-50 end-0 translate-middle-y pe-3 border-0 bg-transparent">
                            <i class="fas fa-search text-muted"></i>
                        </button>
                    </div>
                </form>


                <div class="d-flex gap-5">    
                    <a class="nav-link" href="#"><i class="fa-regular fa-user"></i> Đăng nhập/Đăng ký</a>
                    <a class="nav-link" href="#"><i class="fas fa-desktop"></i> build PC</a>
                    <a class="nav-link" href="#"><i class="fas fa-shopping-cart"></i> Giỏ hàng</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/my-orders">
    <i class="fas fa-receipt"></i> Đơn hàng của tôi
</a>

                </div>
            </div>
        </nav>

