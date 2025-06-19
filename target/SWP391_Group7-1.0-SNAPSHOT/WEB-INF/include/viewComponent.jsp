<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
        <!-- US-11: View Components (Bootstrap version) -->
        <section class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
                <h2 class="text-uppercase fw-bold mb-0" style="color: #c5a992;">Linh kiện máy tính</h2>
                <div class="d-flex flex-wrap gap-2">
                    <select class="form-select">
                        <option selected>Loại</option>
                        <option>CPU</option>
                        <option>RAM</option>
                        <option>VGA</option>
                        <option>SSD</option>
                    </select>
                    <select class="form-select">
                        <option selected>Hãng</option>
                        <option>Intel</option>
                        <option>AMD</option>
                        <option>Kingston</option>
                    </select>
                    <select class="form-select">
                        <option selected>Giá</option>
                        <option>0-2tr</option>
                        <option>2-5tr</option>
                        <option>5-10tr</option>
                    </select>
                </div>
            </div>

            <div class="row g-4">
                <c:forEach var="i" begin="1" end="10">
                    <div class="col-sm-6 col-md-4 col-lg-3">
                        <div class="card h-100 shadow-sm">
                            <img src="cpu.jpg" class="card-img-top" alt="CPU" style="height: 180px; object-fit: cover;">
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title fw-semibold">Intel Core i7</h5>
                                <p class="fw-bold mb-2" style="color: #c5a992;">6.500.000₫</p>
                                <a href="#" class="btn btn-sm mt-auto text-white" style="background-color: #c5a992;">Xem chi tiết</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <nav aria-label="Page navigation" class="mt-4">
                <ul class="pagination justify-content-center">
                    <li class="page-item disabled"><a class="page-link">Trang trước</a></li>
                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                    <li class="page-item"><a class="page-link" href="#">Trang sau</a></li>
                </ul>
            </nav>
        </section>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
    </body>
</html>


