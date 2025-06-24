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
            .product-img {
                width: 100px;
                height: 100px;
                object-fit: cover;
                border-radius: 8px;
            }
        </style>
    </head>
    <body>
        <div class="container mt-5 mb-5">
            <h2 class="mb-4"><i class="fas fa-box"></i> Chi tiết đơn hàng #${order.orderId}</h2>

            <div class="mb-4">
                <p><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd" /></p>
                <p><strong>Người nhận:</strong> ${shippingInfo.receiverName}</p>
                <p><strong>Số điện thoại:</strong> ${shippingInfo.phone}</p>
                <p><strong>Địa chỉ giao hàng:</strong> ${shippingInfo.shippingAddress}</p>
                <p><strong>Phương thức thanh toán:</strong> ${shippingInfo.paymentMethod}</p>
                <p><strong>Trạng thái thanh toán:</strong>
                    <c:choose>
                        <c:when test="${shippingInfo.paymentStatus eq 'Paid'}">
                            <span class="badge bg-success">Đã thanh toán</span>
                        </c:when>
                        <c:when test="${shippingInfo.paymentStatus eq 'Unpaid'}">
                            <span class="badge bg-warning text-dark">Chưa thanh toán</span>
                        </c:when>
                        <c:when test="${shippingInfo.paymentStatus eq 'Failed'}">
                            <span class="badge bg-danger">Thanh toán thất bại</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary">${shippingInfo.paymentStatus}</span>
                        </c:otherwise>
                    </c:choose>
                </p>

            </div>

            <table class="table table-bordered text-center align-middle">
                <thead class="table-dark">
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

            <div class="text-end mt-3">
                <h5><strong>Tổng tiền đơn hàng:</strong>
                    <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫"/>
                </h5>
            </div>

            <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-secondary mt-3">
                <i class="fas fa-arrow-left"></i> Quay về danh sách đơn hàng
            </a>
        </div>
    </body>
</html>