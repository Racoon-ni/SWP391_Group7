<%-- 
    Document   : listPCmax5
    Created on : Jun 29, 2025, 11:09:45 PM
    Author     : ThinhLVCE181726 <your.name at your.org>
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.Product" %>
<!DOCTYPE html>
<html>
<head>
    <title>PC</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f3f3f3;}
        .pc-container { display: flex; flex-wrap: wrap; gap: 24px; justify-content: center; margin-top: 30px;}
        .pc-card {
            background: #fff; border-radius: 10px; box-shadow: 0 2px 12px #0002;
            width: 270px; padding: 16px 12px 22px 12px; display: flex; flex-direction: column; align-items: center;
            transition: box-shadow 0.2s, transform 0.2s;
        }
        .pc-card:hover { transform: translateY(-5px) scale(1.02); box-shadow: 0 8px 28px #3332;}
        .pc-img { width: 195px; height: 120px; object-fit: cover; border-radius: 7px; background: #e7e7e7; }
        .pc-title { font-size: 1.12em; font-weight: bold; margin: 6px 0 4px 0; text-align: center;}
        .pc-desc { font-size: 0.98em; color: #444; height: 36px; overflow: hidden;}
        .pc-price { color: #c1121f; font-weight: bold; margin: 8px 0;}
        .pc-stock { color: #097b18; font-size: 0.99em; margin-bottom: 7px;}
        .pc-detail-btn, .pc-cart-btn {
            display: inline-block; padding: 8px 18px; margin-top: 6px; border: none; border-radius: 4px; font-weight: 600;
            font-size: 1em; text-decoration: none; cursor: pointer; transition: background 0.14s;
        }
        .pc-detail-btn { background: #005fff; color: #fff; margin-right: 8px;}
        .pc-detail-btn:hover { background: #003fa3;}
        .pc-cart-btn { background: #1dbf36; color: #fff;}
        .pc-cart-btn:hover { background: #189a29;}
        .view-all-btn {
            display:block; margin: 36px auto 0 auto; padding:12px 38px;
            font-weight: bold; font-size: 1.07em; background: #005fff;
            color: #fff; border-radius: 8px; text-align: center;
            width: fit-content; text-decoration: none; letter-spacing: 0.5px;
            box-shadow: 0 2px 8px #005fff14;
        }
        .view-all-btn:hover { background: #003fa3;}
        @media (max-width:900px) {.pc-container{gap:18px;}.pc-card{width:98vw;max-width:340px;}}
    </style>
</head>
<body>
    <h2 style="text-align:center;margin-top:28px;">Top 5 Sản Phẩm</h2>
    <div class="pc-container">
    <%
        List<Product> pcList = (List<Product>)request.getAttribute("pcList");
        if (pcList == null || pcList.size() == 0) {
    %>
        <div style="width:100%;text-align:center;color:#888;font-size:1.09em;">Chưa có sản phẩm nào trong cửa hàng.</div>
    <%
        } else {
            int maxShow = 5;
            int count = 0;
            for (Product pc : pcList) {
                if (count >= maxShow) break;
    %>
        <div class="pc-card">
            <img class="pc-img" src="<%= (pc.getImageUrl() == null ? "images/default-pc.png" : "images" + pc.getImageUrl()) %>" alt="<%= pc.getName() %>">
            <div class="pc-title"><%= pc.getName() %></div>
            <div class="pc-desc"><%= pc.getDescription() %></div>
            <div class="pc-price">Giá: <%= String.format("%,.0f", pc.getPrice()) %> VNĐ</div>
            <div class="pc-stock">Còn hàng: <%= pc.getStock() %></div>
            <a class="pc-detail-btn" href="pcDetail?pcId=<%= pc.getProductId() %>">Xem chi tiết</a>
            <button class="pc-cart-btn" onclick="alert('Chức năng sẽ sớm hoàn thiện!')">Thêm vào giỏ</button>
        </div>
    <%
                count++;
            }
        }
    %>
    </div>
    <!-- Nút Xem tất cả sản phẩm -->
    <a href="listPC" class="view-all-btn">Xem tất cả sản phẩm &gt;&gt;</a>
</body>
</html>

