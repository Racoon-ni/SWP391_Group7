<%-- 
    Document   : pc-detail
    Created on : Jun 29, 2025, 11:54:53 PM
    Author     : ThinhLVCE181726 <your.name at your.org>
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Product" %>
<%
    Product pc = (Product) request.getAttribute("pc");
    if (pc == null) {
%>
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8"/>
        <title>Không tìm thấy sản phẩm</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"/>
    </head>
    <body>
        <div class="container text-center mt-5">
            <div class="alert alert-danger">Không tìm thấy sản phẩm này!</div>
            <a href="javascript:history.back()" class="btn btn-secondary mt-3">Quay lại</a>
        </div>
    </body>
    </html>
<%
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"/>
    <title>Chi tiết PC - <%= pc.getName() %></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"/>
    <style>
        body { background: #f8fafc; }
        .detail-card {
            max-width: 900px; margin: 38px auto;
            background: #fff; border-radius: 16px;
            box-shadow: 0 4px 32px #0001;
            padding: 32px 18px;
        }
        .img-area {
            display: flex; justify-content: center; align-items: center;
            min-height: 260px;
        }
        .pc-img {
            max-width: 350px; max-height: 230px;
            object-fit: cover; border-radius: 10px; background: #eee;
            box-shadow: 0 2px 8px #0002;
        }
        .pc-name {
            font-size: 2.2em; font-weight: bold; margin-bottom: 10px;
        }
        .pc-price {
            color: #e22323; font-size: 1.3em; font-weight: bold; margin-bottom: 8px;
        }
        .pc-stock {
            color: #198754; font-size: 1.04em; margin-bottom: 8px;
        }
        .pc-desc {
            font-size: 1.08em; color: #444; margin-bottom: 18px;
        }
        .action-btns .btn {
            min-width: 140px; font-size: 1.07em;
        }
        .action-btns { gap: 20px; }
        @media (max-width: 900px) {
            .detail-card { padding: 16px 4px;}
            .pc-name { font-size: 1.4em;}
        }
    </style>
</head>
<body>
    <div class="detail-card row">
        <!-- Ảnh sản phẩm -->
        <div class="col-md-5 img-area mb-3 mb-md-0">
            <img class="pc-img"
                src="<%= (pc.getImageUrl() == null || pc.getImageUrl().isEmpty()) ? "images/default-pc.png" : "images/" + pc.getImageUrl() %>"
                alt="<%= pc.getName() %>">
        </div>
        <!-- Thông tin chi tiết -->
        <div class="col-md-7">
            <div class="pc-name"><%= pc.getName() %></div>
            <div class="pc-price">Giá: <%= String.format("%,.0f", pc.getPrice()) %> VNĐ</div>
            <div class="pc-stock">Tồn kho: <%= pc.getStock() %> sản phẩm</div>
            <div class="pc-desc"><%= pc.getDescription() %></div>
            <div class="action-btns d-flex flex-row mt-4">
                <a href="javascript:history.back()" class="btn btn-secondary">
                    &lt; Quay lại
                </a>
                <button class="btn btn-success ms-2"
                        onclick="alert('Chức năng thêm vào giỏ sẽ sớm hoàn thiện!')">
                    <i class="fa fa-cart-plus"></i> Thêm vào giỏ hàng
                </button>
            </div>
        </div>
    </div>
</body>
</html>

