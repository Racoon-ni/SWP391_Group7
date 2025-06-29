<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Product" %>
<%@ page import="model.Rating" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết sản phẩm</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
        <style>
            .product-img {
                max-width: 400px;
                max-height: 400px;
                object-fit: contain;
            }
            .rating-comment {
                border-bottom: 1px solid #eee;
                padding: 18px 0 12px 0;
                display: flex;
            }
            .rating-avatar {
                width:48px;
                height:48px;
                background:#f2f2f2;
                border-radius:50%;
                display:flex;
                align-items:center;
                justify-content:center;
                margin-right:16px;
            }
            .rating-content {
                flex:1;
            }
            .rating-stars {
                color: #ffc107;
                font-weight: bold;
            }
            .rating-user {
                font-weight: bold;
            }
            .rating-date {
                color:#999;
                font-size: 0.9em;
                margin-left: 10px;
            }
            .rating-comment-text {
                margin-top: 4px;
            }
        </style>
    </head>
    <body>
        <div class="container py-5">
            <%
                Product product = (Product) request.getAttribute("product");
                List<Rating> ratings = (List<Rating>) request.getAttribute("ratings");
                DecimalFormat df = new DecimalFormat("#,###");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            %>
            <h2 class="mb-4">Chi tiết sản phẩm: <%= product.getName()%></h2>
            <div class="row mb-5">
                <div class="col-md-6 d-flex justify-content-center">
                    <img src="<%= product.getImageUrl() != null ? product.getImageUrl() : "https://via.placeholder.com/400"%>" alt="Product Image" class="product-img">
                </div>
                <div class="col-md-6">
                    <h3><%= product.getName()%></h3>
                    <p><strong>Mô tả:</strong> <%= product.getDescription()%></p>
                    <p><strong>Giá:</strong> <%= df.format(product.getPrice())%> đ</p>
                    <p><strong>Số lượng trong kho:</strong> <%= product.getStock()%></p>
                    <p><strong>Loại sản phẩm:</strong> <%= product.getProductType()%></p>
                    <p><strong>Danh mục:</strong> <%= product.getCategoryId()%></p>
                    <div class="my-3">
                        <a href="#" class="btn btn-primary">Thêm vào giỏ</a>
                    </div>
                </div>
            </div>

            <!-- ĐÁNH GIÁ SẢN PHẨM -->
            <div class="bg-white rounded-3 shadow-sm p-4" style="max-width: 650px;margin:auto;">
                <h4 class="mb-4">Đánh giá sản phẩm</h4>
                <%
                    if (ratings == null || ratings.isEmpty()) {
                %>
                <p class="text-muted fst-italic">Chưa có đánh giá nào cho sản phẩm này.</p>
                <%
                } else {
                    for (Rating rating : ratings) {
                %>
                <div class="rating-comment">
                    <div class="rating-avatar">
                        <i class="fa fa-user fa-2x text-secondary"></i>
                    </div>
                    <div class="rating-content">
                        <span class="rating-user"><%= rating.getUserName() != null ? rating.getUserName() : "Khách"%></span>
                        <span class="rating-stars">
                            <% for (int i = 1; i <= 5; i++) { %>
                            <% if (i <= rating.getStars()) { %>
                            <i class="fa fa-star"></i>
                            <% } else { %>
                            <i class="fa fa-star-o"></i>
                            <% } %>
                            <% } %>
                        </span>
                        <span class="rating-date">
                            <% if (rating.getCreatedAt() != null) {%>
                            <%= sdf.format(rating.getCreatedAt())%>
                            <% }%>
                        </span>
                        <div class="rating-comment-text"><%= rating.getComment()%></div>
                    </div>
                </div>
                <%
                        }
                    }
                %>
            </div>

            <a href="pc-list" class="btn btn-secondary mt-4">Quay lại danh sách sản phẩm</a>
        </div>
    </body>
</html>
