<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết đơn hàng</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .product-img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
        }
        .order-header {
            background-color: #0d6efd;
            color: #fff;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
        }
        .order-header i {
            margin-right: 10px;
        }
        .badge-status {
            font-size: 0.9rem;
            padding: 0.4em 0.6em;
        }
        .card-header {
            background-color: #0d6efd;
            color: #fff;
            font-weight: 600;
        }
        .btn-back {
            border-radius: 18px;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="container py-5">
        <div class="order-header">
            <i class="fas fa-box fa-lg"></i>
            <h3 class="mb-0">Chi tiết đơn hàng #${order.orderId}</h3>
        </div>

        <div class="card mb-4 shadow-sm">
            <div class="card-body">
                <p class="mb-2"><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd" /></p>
                <p class="mb-2"><strong>Người nhận:</strong> ${shippingInfo.receiverName}</p>
                <p class="mb-2"><strong>Số điện thoại:</strong> ${shippingInfo.phone}</p>
                <p class="mb-2"><strong>Địa chỉ giao hàng:</strong> ${shippingInfo.shippingAddress}</p>
                <p class="mb-2"><strong>Phương thức thanh toán:</strong> ${shippingInfo.paymentMethod}</p>
                <p class="mb-0"><strong>Trạng thái thanh toán:</strong>
                    <c:choose>
                        <c:when test="${shippingInfo.paymentStatus eq 'Paid'}">
                            <span class="badge bg-success badge-status">Đã thanh toán</span>
                        </c:when>
                        <c:when test="${shippingInfo.paymentStatus eq 'Unpaid'}">
                            <span class="badge bg-warning text-dark badge-status">Chưa thanh toán</span>
                        </c:when>
                        <c:when test="${shippingInfo.paymentStatus eq 'Failed'}">
                            <span class="badge bg-danger badge-status">Thanh toán thất bại</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary badge-status">${shippingInfo.paymentStatus}</span>
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>

        <div class="card mb-4 shadow-sm">
            <div class="card-header">
                <i class="fas fa-shopping-cart me-2"></i> Sản phẩm trong đơn
            </div>
            <div class="card-body p-0">
                <table class="table table-bordered mb-0 text-center align-middle">
                    <thead class="table-primary">
                        <tr>
                            <th>Ảnh</th>
                            <th>Sản phẩm</th>
                            <th>Số lượng</th>
                            <th>Đơn giá</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${orderDetails}">
                            <tr>
                                <td>
                                    <img class="product-img" src="${item.imageUrl}" alt="${item.productName}" />
                                </td>
                                <td>${item.productName}</td>
                                <td>${item.quantity}</td>
                                <td>
                                    <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫"/>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${item.unitPrice * item.quantity}" type="currency" currencySymbol="₫"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h5 class="mb-0">
                <strong>Tổng tiền đơn hàng:</strong>
                <span class="text-primary">
                    <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫"/>
                </span>
            </h5>
        </div>

        <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-outline-primary btn-back">
            <i class="fas fa-arrow-left"></i> Quay về danh sách đơn hàng
        </a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>