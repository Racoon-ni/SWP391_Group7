<%-- 
    Document   : voucherlist
    Created on : Jun 24, 2025, 6:22:15 PM
    Author     : Admin
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@include file="/WEB-INF/include/customer-view-profile.jsp" %>--%>
<%@include file="/WEB-INF/include/header.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Voucher" %>
<%@ page import="model.Customer" %>
<%
    // Lấy danh sách voucher từ request
    List<Voucher> voucherList = (List<Voucher>) request.getAttribute("voucherList");
    String error = (String) request.getAttribute("error");
%>
<%
    Customer customer = (Customer) request.getAttribute("customer");
%>
<title>Thông tin khách hàng</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f6f9;
        margin: 0;
        padding: 0;
    }

    /* Phần header */
    .header {
        background-color: #fff;
        padding: 20px;
        border-bottom: 1px solid #e1e1e1;
        display: flex;
        justify-content: space-between;
        align-items: center;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        z-index: 1000;
    }

    .header .logo {
        font-size: 24px;
        font-weight: bold;
        color: #005cbf;
    }

    .header .search-bar {
        border: 1px solid #ccc;
        padding: 8px;
        border-radius: 5px;
        width: 300px;
    }

    .header .user-info {
        font-size: 16px;
        color: #333;
    }

    /* Sidebar */
    .sidebar {
        position: fixed;
        top: 80px; /* Khoảng cách từ header */
        left: 0;
        width: 250px;
        height: calc(100% - 80px); /* Chiều cao sidebar */
        background-color: #f8f9fa;
        padding-top: 20px;
        border-right: 1px solid #ddd;
        z-index: 500;
    }

    .sidebar a {
        display: block;
        padding: 15px;
        color: #333;
        text-decoration: none;
        font-size: 18px;
    }

    .sidebar a:hover {
        background-color: #007bff;
        color: white;
    }

    /* Phần chính */
    .main-content {
        margin-left: 250px;
        margin-top: 80px; /* Khoảng cách từ header */
        padding: 40px;
        max-width: 800px;
        margin: auto;
    }

    .container {
        background-color: white;
        border-radius: 10px;
        padding: 30px;
        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
    }

    .container h2 {
        color: #333;
        text-align: center;
        margin-bottom: 20px;
    }

    .form-field {
        margin-bottom: 20px;
    }

    .form-field label {
        font-weight: bold;
        font-size: 16px;
        display: block;
        margin-bottom: 5px;
    }

    .form-field input {
        width: 100%;
        padding: 10px;
        border-radius: 5px;
        border: 1px solid #ccc;
        background-color: #f1f1f1;
        font-size: 14px;
        color: #555;
    }

    .update-btn {
        width: 100%;
        padding: 12px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
    }

    .update-btn:hover {
        background-color: #0056b3;
    }

    .back-link {
        display: block;
        text-align: center;
        margin-top: 20px;
        font-size: 16px;
        color: #007bff;
        text-decoration: none;
    }

    .back-link:hover {
        text-decoration: underline;
    }

    /* Pop-up modal */
    .modal {
        display: none; /* Ẩn modal mặc định */
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }

    .modal-content {
        background-color: white;
        padding: 20px;
        border-radius: 10px;
        width: 400px;
        max-width: 90%;
    }

    .modal-content input {
        width: 100%;
        padding: 10px;
        margin-bottom: 10px;
        border-radius: 5px;
        border: 1px solid #ccc;
    }

    .close-btn {
        background-color: #dc3545;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
    }

    .close-btn:hover {
        background-color: #c82333;
    }

    .edit-btn {
        background-color: #28a745;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    .edit-btn:hover {
        background-color: #218838;
    }
</style>

<!-- Header Section -->
<div class="header">
    <div class="logo">PC Store</div>
    <input type="text" class="search-bar" placeholder="Tìm kiếm...">
    <div class="user-info">
        <span>Chào bạn Long</span>
    </div>
</div>

<!-- Sidebar Section -->
<div class="sidebar">
    <a href="view-profile">Thông tin tài khoản</a>
    <a href="#">Quản lý đơn hàng</a>
    <a href="#">Sở địa chỉ</a>
    <a href="#">Thông báo</a>
    <a href="#">Điểm thành viên</a>
    <!-- Thêm mục Kho voucher -->
    <a href="ViewVouchers">Kho voucher</a>
        <a href="View-Wishlist">Danh sách yêu thích</a>
</div>

<html>

    <head>
        <title>Danh sách mã giảm giá</title>
        <style>
            table {
                border-collapse: collapse;
                width: 80%;
                margin: 20px 0;
            }
            th, td {
                border: 1px solid #888;
                padding: 8px 12px;
                text-align: center;
            }
            th {
                background: #eee;
            }
            .expired {
                color: red;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div>

            <div class="main-content">
                <div class="container">
                    <h2>Danh sách mã giảm giá</h2>

                    <% if (error != null) {%>
                    <div style="color:red"><%= error%></div>
                    <% } %>

                    <% if (voucherList == null || voucherList.isEmpty()) { %>
                    <p>Không có voucher khả dụng!</p>
                    <% } else { %>
                    <table>
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã voucher</th>
                                <th>Phần trăm giảm</th>
                                <th>Giá trị đơn tối thiểu</th>
                                <th>Ngày hết hạn</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% int i = 1;
                                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
                                java.util.Date today = new java.util.Date();
                                for (Voucher v : voucherList) {%>
                            <tr>
                                <td><%= i++%></td>
                                <td><strong><%= v.getCode()%></strong></td>
                                <td><%= v.getDiscountPercent()%> %</td>
                                <td><%= String.format("%,.0f", v.getMinOrderValue())%> đ</td>
                                <td<% if (v.getExpiredAt().before(today)) { %> class="expired"<% }%>>
                                    <%= sdf.format(v.getExpiredAt())%>
                                    <% if (v.getExpiredAt().before(today)) { %> (Đã hết hạn) <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <% }%>
                    </body>
                </div>
                <%@include file="/WEB-INF/include/footer.jsp" %>
                </html>