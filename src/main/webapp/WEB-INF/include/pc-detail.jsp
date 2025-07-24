<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ page import="model.Rating" %>

<%
    Product pc = (Product) request.getAttribute("pc");
    List<Rating> ratings = (List<Rating>) request.getAttribute("ratings");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8"/>
        <title>Chi tiết PC - <%= (pc != null ? pc.getName() : "Không tìm thấy")%></title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
        <style>
            body {
                background: #f8fafc;
            }
            .detail-card {
                max-width: 900px;
                margin: 38px auto;
                background: #fff;
                border-radius: 16px;
                box-shadow: 0 4px 32px #0001;
                padding: 32px 18px;
            }
            .img-area {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 260px;
            }
            .pc-img {
                max-width: 350px;
                max-height: 230px;
                object-fit: cover;
                border-radius: 10px;
                background: #eee;
                box-shadow: 0 2px 8px #0002;
            }
            .pc-name {
                font-size: 2.2em;
                font-weight: bold;
                margin-bottom: 10px;
            }
            .pc-price {
                color: #e22323;
                font-size: 1.3em;
                font-weight: bold;
                margin-bottom: 8px;
            }
            .pc-stock {
                color: #198754;
                font-size: 1.04em;
                margin-bottom: 8px;
            }
            .pc-desc {
                font-size: 1.08em;
                color: #444;
                margin-bottom: 18px;
            }
            .action-btns .btn {
                min-width: 140px;
                font-size: 1.07em;
            }
            .action-btns {
                gap: 20px;
            }
            @media (max-width: 900px) {
                .detail-card {
                    padding: 16px 4px;
                }
                .pc-name {
                    font-size: 1.4em;
                }
            }
        </style>
    </head>
    <body>

        <% if (pc == null) { %>
        <div class="container text-center mt-5">
            <div class="alert alert-danger">Không tìm thấy sản phẩm này!</div>
            <a href="javascript:history.back()" class="btn btn-secondary mt-3">Quay lại</a>
        </div>
        <% } else {%>

        <!-- Thông tin sản phẩm -->
        <div class="detail-card row">
            <div class="col-md-5 img-area mb-3 mb-md-0">
                <img class="pc-img"
                     src="<%= (pc.getImageUrl() == null || pc.getImageUrl().isEmpty()) ? "images/default-pc.png" : "images/" + pc.getImageUrl()%>"
                     alt="<%= pc.getName()%>">
            </div>
            <div class="col-md-7">
                <div class="pc-name"><%= pc.getName()%></div>
                <div class="pc-price">Giá: <%= String.format("%,.0f", pc.getPrice())%> VNĐ</div>
                <div class="pc-stock">Tồn kho: <%= pc.getStock()%> sản phẩm</div>
                <div class="pc-desc"><%= pc.getDescription()%></div>
                <div class="action-btns d-flex flex-row mt-4">
                    <a href="javascript:history.back()" class="btn btn-secondary">
                        &lt; Quay lại
                    </a>
                    <button class="btn btn-success ms-2"
                            onclick="alert('Chức năng thêm vào giỏ sẽ sớm hoàn thiện!')">
                        <i class="fa fa-cart-plus"></i> Thêm vào giỏ hàng 
                    </button>

                    <!-- Nút mua ngay -->
                    <form method="post" action="${pageContext.request.contextPath}/checkout" class="ms-2">
                        <input type="hidden" name="productId" value="<%= pc.getProductId()%>" />
                        <button type="submit" class="btn btn-primary">
                            Mua ngay
                        </button>
                    </form>

                </div>
            </div>
        </div>

        <!-- Đánh giá sản phẩm -->
        <div class="detail-card mt-5">
            <h5 class="fw-bold mb-4">Đánh giá sản phẩm</h5>

            <% if (ratings == null || ratings.isEmpty()) { %>
            <p class="text-muted">Chưa có đánh giá nào cho sản phẩm này.</p>
            <% } else {
                for (Rating r : ratings) {
            %>
            <div class="d-flex align-items-start mb-4 border-bottom pb-3">
                <!-- Avatar -->
                <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png"
                     alt="avatar" width="48" height="48" class="rounded-circle me-3 bg-light p-1" />

                <!-- Nội dung đánh giá -->
                <div class="flex-grow-1">
                    <!-- Tên người dùng + sao + ngày -->
                    <div class="d-flex flex-column flex-md-row align-items-md-center mb-1">
                        <strong class="me-3"><%= r.getUserName()%></strong>

                        <!-- Sao đánh giá -->
                        <div class="text-warning me-3">
                            <% for (int i = 1; i <= 5; i++) { %>
                            <% if (i <= r.getStars()) { %>
                            <i class="fas fa-star text-warning"></i>
                            <% } else { %>
                            <i class="far fa-star text-warning"></i>
                            <% } %>
                            <% }%>
                        </div>

                        <!-- Thời gian -->
                        <small class="text-muted">
                            <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(r.getCreatedAt())%>
                        </small>
                    </div>

                    <!-- Comment -->
                    <div class="text-dark"><%= r.getComment()%></div>
                </div>
            </div>
            <% }
                } %>
        </div>
        <% }%>

    </body>
</html>
