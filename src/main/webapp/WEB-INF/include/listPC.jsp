<%-- 
    Document   : listPC
    Created on : Jun 29, 2025, 9:57:26 PM
    Author     : ThinhLVCE181726 <your.name at your.org>
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Product" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Danh Sách PC Bộ</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f3f3f3;
                margin: 0;
            }
            h2 {
                text-align: center;
                margin-top: 24px;
            }
            .pc-container {
                max-width: 1200px;
                margin: 24px auto;
                display: flex;
                flex-wrap: wrap;
                gap: 24px;
                justify-content: center;
            }
            .pc-card {
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 4px 24px rgba(0,0,0,0.08);
                width: 290px;
                padding: 16px;
                display: flex;
                flex-direction: column;
                align-items: center;
                transition: transform 0.2s;
            }
            .pc-card:hover {
                transform: translateY(-6px) scale(1.02);
                box-shadow: 0 8px 36px rgba(60,60,60,0.12);
            }
            .pc-img {
                width: 240px;
                height: 150px;
                object-fit: cover;
                border-radius: 8px;
                margin-bottom: 10px;
            }
            .pc-title {
                font-size: 1.2em;
                margin: 4px 0;
                text-align: center;
            }
            .pc-desc {
                font-size: 0.95em;
                color: #333;
                height: 36px;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            .pc-price {
                color: #cc1d1d;
                font-weight: bold;
                margin: 10px 0;
            }
            .pc-stock {
                color: #007800;
                font-size: 0.97em;
            }
            .pc-detail-btn {
                display: inline-block;
                padding: 8px 18px;
                margin-top: 8px;
                background: #005fff;
                color: #fff;
                border: none;
                border-radius: 4px;
                text-decoration: none;
                font-weight: 600;
                transition: background 0.15s;
            }
            .pc-detail-btn:hover {
                background: #003fa3;
            }
            .no-pc {
                text-align: center;
                margin-top: 50px;
                font-size: 1.2em;
                color: #999;
            }
        </style>
    </head>
    <body>
        <h2>Danh Sách PC Bộ Đang Bán</h2>
        <div class="pc-container">
            <%
                List<Product> pcList = (List<Product>) request.getAttribute("pcList");
                if (pcList == null || pcList.size() == 0) {
            %>
            <div class="no-pc">Hiện chưa có PC bộ nào trong cửa hàng.</div>
            <%
            } else {
                for (Product pc : pcList) {
            %>
            <div class="pc-card">
                <img class="pc-img" src="<%= (pc.getImageUrl() == null ? "images/default-pc.png" : "images/" + pc.getImageUrl())%>" alt="<%= pc.getName()%>">
                <div class="pc-title"><%= pc.getName()%></div>
                <div class="pc-desc"><%= pc.getDescription()%></div>
                <div class="pc-price">Giá: <%= String.format("%,.0f", pc.getPrice())%> VNĐ</div>
                <div class="pc-stock">Còn hàng: <%= pc.getStock()%></div>
               <a class="pc-detail-btn" href="pcDetail?pcId=<%= pc.getProductId() %>">Xem chi tiết</a>

                <button type="submit" class="pc-detail-btn" style="background:#1dbf36;">Thêm vào giỏ</button>
            </div>
            <%
                    }
                }
            %>
        </div>
    </body>
</html>

