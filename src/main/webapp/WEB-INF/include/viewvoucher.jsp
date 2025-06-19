<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Voucher" %>
<%@ page import="java.util.ArrayList" %>
<%
    ArrayList<Voucher> list = (ArrayList<Voucher>) request.getAttribute("voucherList");
%>
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
            .shadowed-navbar {
                border-bottom: 2px solid black; /* Solid black line */
                box-shadow: 0px 8px 8px -4px rgba(0, 0, 0, 0.4); /* Dark shadow */
                z-index: 1030; /* Keeps it on top */
                padding: 0 10px;
                margin-bottom: 20px;
            }
            .annie-use-your-telescope {
                font-family: "Annie Use Your Telescope", cursive;
            }

        </style>
    <body>

        <nav class="navbar navbar-expand-lg navbar-light bg-light shadowed-navbar">
            <div class="container-fluid">
                <a class="navbar-brand fw-bold annie-use-your-telescope" 
                   href="${pageContext.request.contextPath}/home" 
                   style="font-size: 4rem;">
                    <span style="color: orange;">PC</span><span style="color: black;"> Store</span>
                </a>

                <%@include file="../include/top-nav.jsp" %>
                <form action="/search" method="GET" style="width: 30%; margin-top: 10px; margin-right: 10px">
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/my-orders"><i class="fas fa-receipt"></i> Đơn hàng của tôi</a>
                </div>
            </div>
        </nav>

    </head>
<head>
    <title>Danh sách voucher</title>
</head>
<body>
    <h2>Danh sách mã giảm giá</h2>
    <table border="1" cellpadding="10">
        <tr>
            <th>Mã</th>
            <th>Mô tả</th>
            <th>Ngày hết hạn</th>
            <th>Giảm (%)</th>
        </tr>
        <%
            if (list != null) {
                for (Voucher v : list) {
        %>
        <tr>
            <td><%= v.getCode()%></td>
            <td><%= v.getDescription()%></td>
            <td><%= v.getExpiryDate()%></td>
            <td><%= v.getDiscountPercent()%></td>
        </tr>
        <%
                }
            }
        %>
    </table>
</body>
</html>
