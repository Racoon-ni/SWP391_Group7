<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
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
    </head>
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
        <div class="container py-5">
            <div class="row">
                <!-- Ảnh sản phẩm và ảnh nhỏ -->
                <div class="col-md-5 text-center">
                    <img src="${product.imageUrl}" class="img-fluid mb-3" alt="${product.name}" style="max-height: 250px; object-fit: cover;">
                    <div class="d-flex justify-content-center gap-2">
                        <img src="${product.imageUrl}" class="thumbnail-img" alt="">
                        <img src="img/ssd_other1.jpg" class="thumbnail-img" alt="">
                    </div>
                </div>

                <!-- Thông tin sản phẩm -->
                <div class="col-md-7">
                    <h4 class="fw-bold">${product.name}</h4>
                    <p>Thương hiệu: <strong>Kingston</strong> | Mã sản phẩm: <strong>SNV3S/500G</strong></p>

                    <!-- Giá -->
                    <div class="mb-2">
                        <span class="price">${product.price}</span>
                        <span class="old-price">1.440.000₫</span>
                        <span class="text-danger">-25%</span>
                    </div>

                    <!-- Dung lượng -->
                    <div class="mb-3">
                        <label class="fw-bold">Dung lượng:</label><br>
                        <button class="btn btn-outline-secondary btn-sm">2TB</button>
                        <button class="btn btn-outline-secondary btn-sm active">500GB</button>
                        <button class="btn btn-outline-secondary btn-sm">1TB</button>
                    </div>

                    <!-- Khuyến mãi -->
                    <div class="promo-box mb-3">
                        <p class="mb-1"><strong>🎁 Giảm 100.000₫</strong> (áp dụng trực tiếp vào giá sản phẩm)</p>
                        <small>HSD: 10/07/2025</small>
                    </div>

                    <!-- Nút hành động (có thêm Yêu thích) -->
                    <div class="d-flex gap-3">
                        <button class="btn btn-primary px-4">MUA NGAY</button>
                        <button class="btn btn-outline-secondary px-4">THÊM VÀO GIỎ HÀNG</button>
                        <button class="btn btn-outline-danger px-3">
                            <i class="fas fa-heart"></i> Yêu thích
                        </button>
                    </div>

                </div>
            </div>

            <!-- Thông số kỹ thuật -->
            <div class="row mt-5">
                <div class="col-md-6">
                    <h5 class="fw-bold mb-3">Thông số kỹ thuật</h5>
                    <ul class="list-unstyled specs">
                        <li><strong>Dung lượng:</strong> 500GB</li>
                        <li><strong>Kích thước:</strong> M.2 2280</li>
                        <li><strong>Kết nối:</strong> M.2 NVMe</li>
                        <li><strong>NAND:</strong> 3D-NAND</li>
                        <li><strong>Tốc độ đọc/ghi:</strong> 5000MB/s | 3000MB/s</li>
                    </ul>
                </div>
            </div>
        </div>

    </body>
</html>
