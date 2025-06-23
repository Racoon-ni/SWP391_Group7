<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String category = request.getParameter("category") != null ? request.getParameter("category") : "tat-ca";
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= category.toUpperCase() %> | Sản phẩm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
    <style>
        .product-card img {
            height: 180px;
            object-fit: cover;
        }
        .filter-label {
            font-weight: bold;
            margin-top: 10px;
        }
        .price-range-wrapper {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<div class="container-fluid mt-4">
    <div class="row">
        <!-- BỘ LỌC -->
        <div class="col-md-3">
            <form method="get" action="product.jsp">
                <input type="hidden" name="category" value="<%= category %>">
                <h5>Bộ lọc (<%= category %>)</h5>

                <!-- Bộ lọc chung -->
                <div class="price-range-wrapper">
                    <label class="filter-label">Khoảng giá</label>
                    <input type="range" class="form-range" min="0" max="100000000" name="price"
                           oninput="document.getElementById('priceOut').value = this.value">
                    <div class="d-flex justify-content-between mb-1">
                        <small>0đ</small><small>100tr</small>
                    </div>
                    <div class="mb-2">
                        <output id="priceOut">50000000</output> đ
                    </div>
                </div>

                <%
                    if ("pc".equals(category)) {
                %>
                <!-- BỘ LỌC DÀNH CHO PC -->
                <label class="filter-label">Loại hàng</label>
                <div><input type="checkbox"> Hàng thông thường</div>
                <div><input type="checkbox"> Hàng thanh lý</div>

                <label class="filter-label">Nhu cầu</label>
                <div><input type="checkbox"> Gaming</div>
                <div><input type="checkbox"> Văn phòng</div>
                <div><input type="checkbox"> Học sinh</div>

                <label class="filter-label">Series CPU</label>
                <div><input type="checkbox"> Core i3</div>
                <div><input type="checkbox"> Core i5</div>
                <div><input type="checkbox"> Core i7</div>
                <div><input type="checkbox"> Core i9</div>

                <label class="filter-label">RAM</label>
                <div><input type="checkbox"> 8GB</div>
                <div><input type="checkbox"> 16GB</div>
                <div><input type="checkbox"> 32GB</div>

                <label class="filter-label">Card đồ họa</label>
                <div><input type="checkbox"> RTX 3050</div>
                <div><input type="checkbox"> RTX 4060</div>
                <div><input type="checkbox"> GTX 1660</div>

                <%
                    } else if ("cpu".equals(category)) {
                %>
                <!-- BỘ LỌC CPU -->
                <label class="filter-label">Thương hiệu</label>
                <div><input type="checkbox"> Intel</div>
                <div><input type="checkbox"> AMD</div>

                <label class="filter-label">Socket</label>
                <div><input type="checkbox"> LGA 1200</div>
                <div><input type="checkbox"> AM4</div>

                <label class="filter-label">Thế hệ</label>
                <div><input type="checkbox"> 10th</div>
                <div><input type="checkbox"> 12th</div>
                <div><input type="checkbox"> Ryzen 5</div>

                <%
                    } else if ("ram".equals(category)) {
                %>
                <!-- BỘ LỌC RAM -->
                <label class="filter-label">Dung lượng</label>
                <div><input type="checkbox"> 8GB</div>
                <div><input type="checkbox"> 16GB</div>
                <div><input type="checkbox"> 32GB</div>

                <label class="filter-label">Chuẩn RAM</label>
                <div><input type="checkbox"> DDR4</div>
                <div><input type="checkbox"> DDR5</div>

                <label class="filter-label">Bus</label>
                <div><input type="checkbox"> 2666</div>
                <div><input type="checkbox"> 3200</div>
                <div><input type="checkbox"> 3600</div>

                <%
                    } else if ("ssd".equals(category)) {
                %>
                <!-- BỘ LỌC SSD -->
                <label class="filter-label">Loại ổ</label>
                <div><input type="checkbox"> SATA</div>
                <div><input type="checkbox"> M.2 NVMe</div>

                <label class="filter-label">Dung lượng</label>
                <div><input type="checkbox"> 256GB</div>
                <div><input type="checkbox"> 512GB</div>
                <div><input type="checkbox"> 1TB</div>

                <label class="filter-label">NAND</label>
                <div><input type="checkbox"> 3D-NAND</div>
                <div><input type="checkbox"> TLC</div>

                <%
                    } else if ("mainboard".equals(category)) {
                %>
                <!-- BỘ LỌC MAIN -->
                <label class="filter-label">Socket</label>
                <div><input type="checkbox"> LGA 1200</div>
                <div><input type="checkbox"> AM4</div>

                <label class="filter-label">Chipset</label>
                <div><input type="checkbox"> B460</div>
                <div><input type="checkbox"> B660</div>
                <div><input type="checkbox"> H510</div>

                <label class="filter-label">Kích thước</label>
                <div><input type="checkbox"> ATX</div>
                <div><input type="checkbox"> mATX</div>

                <%
                    } else if ("gpu".equals(category)) {
                %>
                <!-- BỘ LỌC GPU -->
                <label class="filter-label">Thương hiệu</label>
                <div><input type="checkbox"> MSI</div>
                <div><input type="checkbox"> ASUS</div>
                <div><input type="checkbox"> GIGABYTE</div>

                <label class="filter-label">Dòng</label>
                <div><input type="checkbox"> GTX 1660</div>
                <div><input type="checkbox"> RTX 3050</div>
                <div><input type="checkbox"> RTX 4060</div>

                <label class="filter-label">VRAM</label>
                <div><input type="checkbox"> 4GB</div>
                <div><input type="checkbox"> 6GB</div>
                <div><input type="checkbox"> 8GB</div>
                <%
                    }
                %>

                <button class="btn btn-primary mt-3 w-100">Áp dụng</button>
            </form>
        </div>

        <!-- DANH SÁCH SẢN PHẨM -->
        <div class="col-md-9">
            <h4 class="mb-3">Sản phẩm - <%= category.toUpperCase() %></h4>
            <div class="row g-4">
                <% for (int i = 1; i <= 8; i++) { %>
                    <div class="col-md-3">
                        <div class="card product-card h-100">
                            <img src="https://via.placeholder.com/300x200?text=<%=category%>+<%=i%>" class="card-img-top">
                            <div class="card-body">
                                <h6 class="card-title">Sản phẩm <%= i %></h6>
                                <p class="text-danger fw-bold">15.000.000đ</p>
                                <a href="#" class="btn btn-outline-primary btn-sm w-100">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</div>
</body>
</html>
