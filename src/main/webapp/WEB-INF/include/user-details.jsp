<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Order, model.OrderDetail, model.ShippingInfo" %>


<%
    List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("orderDetails");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết tài khoản</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            color: #212529;
        }
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            border: none;
        }
        .card-header {
            background-color: #0dcaf0;
            color: white;
            border-radius: 10px 10px 0 0 !important;
            font-weight: 600;
        }
        .profile-header {
            background: #0dcaf0;
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .badge-status {
            font-size: 0.9rem;
            padding: 5px 10px;
        }
        .table img {
            border-radius: 5px;
            object-fit: cover;
            border: 1px solid #dee2e6;
        }
        .info-item {
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        .info-item:last-child {
            border-bottom: none;
        }
        .info-label {
            color: #6c757d;
            font-weight: 600;
            width: 140px;
            display: inline-block;
        }
        .back-btn {
            transition: all 0.3s;
        }
        .back-btn:hover {
            transform: translateX(-5px);
        }
        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
        }
        .table {
            margin-bottom: 0;
        }
        .table thead th {
            border-bottom: none;
            background-color: cornflowerblue;
            color: white;
            font-weight: 500;
        }
        .empty-state {
            text-align: center;
            padding: 30px;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="container py-5">
        <div class="profile-header">
            <div class="d-flex justify-content-between align-items-center">
                <h2 class="mb-0"><i class="fas fa-user-circle me-2"></i>Chi tiết tài khoản</h2>
                <span class="badge ${user.status ? 'bg-success' : 'bg-danger'} badge-status">
                    ${user.status ? '<i class="fas fa-check-circle me-1"></i> Đang hoạt động' : '<i class="fas fa-times-circle me-1"></i> Dừng hoạt động'}
                </span>
            </div>
        </div>

        <div class="row">
            <div class="col-md-5">
                <div class="card">
                    <div class="card-header">
                        <i class="fas fa-id-card me-2"></i>Thông tin tài khoản
                    </div>
                    <div class="card-body">
                        <div class="info-item">
                            <span class="info-label"><i class="fas fa-user me-2"></i>Tên đăng nhập:</span>
                            <span class="fw-bold">${user.username}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label"><i class="fas fa-envelope me-2"></i>Email:</span>
                            <span>${user.email}</span>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <i class="fas fa-address-card me-2"></i>Thông tin cá nhân
                    </div>
                    <div class="card-body">
                        <div class="info-item">
                            <span class="info-label"><i class="fas fa-user-tag me-2"></i>Họ và Tên:</span>
                            <span class="fw-bold">${user.fullname}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label"><i class="fas fa-phone me-2"></i>SĐT:</span>
                            <span>${user.phone}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label"><i class="fas fa-map-marker-alt me-2"></i>Địa chỉ:</span>
                            <span>${user.address}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label"><i class="fas fa-birthday-cake me-2"></i>Ngày sinh:</span>
                            <span>${user.dateOfBirth}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label"><i class="fas fa-venus-mars me-2"></i>Giới tính:</span>
                            <span>${user.gender}</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-7">
                <div class="card">
                    <div class="card-header">
                        <i class="fas fa-shopping-bag me-2"></i>Lịch sử mua hàng
                    </div>
                    <div class="card-body p-1">
                        <div class="table-responsive">
                            <% if (details != null && !details.isEmpty()) { %>
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th style="width: 80px;">Ảnh</th>
                                            <th>Tên sản phẩm</th>
                                            <th style="width: 90px;">Số lượng</th>
                                            <th>Đơn giá</th>
                                            <th>Thành tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (OrderDetail item : details) { %>
                                            <tr>
                                                <td class="text-center">
                                                    <img src="<%= item.getImageUrl() %>" alt="Ảnh sản phẩm" width="60" height="60"/>
                                                </td>
                                                <td><%= item.getProductName() %></td>
                                                <td class="text-center"><%= item.getQuantity() %></td>
                                                <td><%= String.format("%,.0f", item.getUnitPrice()) %> ₫</td>
                                                <td class="fw-bold"><%= String.format("%,.0f", item.getUnitPrice() * item.getQuantity()) %> ₫</td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            <% } else { %>
                                <div class="empty-state">
                                    <i class="fas fa-shopping-cart fa-3x mb-3"></i>
                                    <p>Người dùng chưa có lịch sử mua hàng nào.</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="text-center mt-4">
            <a href="manage-user" class="btn btn-secondary back-btn">
                <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách người dùng
            </a>
        </div>
    </div>
</body>
</html>

