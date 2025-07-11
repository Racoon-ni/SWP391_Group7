<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Order, model.OrderDetail, model.ShippingInfo" %>


<%
    List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("orderDetails");
%>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết đơn hàng</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    </head>
    <body>

        <div class="container mt-5">
            <h2>Chi tiết tài khoản </h2>

            <div class="mb-3">
                <strong>Tên đăng nhập:</strong> ${user.username}<br>
                <strong>Email:</strong> ${user.email} <br>
                <strong>Vai trò:</strong> ${user.role} <br>
                <strong>Trạng thái:</strong> ${user.status ? "Còn hoạt động" : "Dừng hoạt động"} <br>
            </div>

            <div class="mb-4">
                <h5>Thông tin giao người dùng</h5>
                <strong>Họ và Tên:</strong> ${user.fullname} <br>
                <strong>SĐT:</strong> ${user.phone} <br>
                <strong>Địa chỉ:</strong> ${user.address} <br>
                <strong>Ngày sinh:</strong> ${user.dateOfBirth} <br>
                <strong>Giới tính:</strong> ${user.gender} <br>
            </div>

            <h4>Lịch sử mua hàng:</h4>
            <table class="table table-bordered">
                <thead class="table-secondary">
                    <tr>
                        <th>Ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Số lượng</th>
                        <th>Đơn giá (VNĐ)</th>
                        <th>Thành tiền (VNĐ)</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (OrderDetail item : details) {%>
                    <tr>
                        <td><img src="<%= item.getImageUrl()%>" alt="Ảnh" width="60"/></td>
                        <td><%= item.getProductName()%></td>
                        <td><%= item.getQuantity()%></td>
                        <td><%= String.format("%,.0f", item.getUnitPrice())%></td>
                        <td><%= String.format("%,.0f", item.getUnitPrice() * item.getQuantity())%></td>
                    </tr>
                    <% }%>
                </tbody>
            </table>

            <a href="manage-user" class="btn btn-secondary mt-3">← Quay lại</a>
        </div>
    </body>
</html>
