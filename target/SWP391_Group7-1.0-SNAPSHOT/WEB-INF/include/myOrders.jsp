<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đơn hàng của tôi</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="mb-4"><i class="fas fa-receipt"></i> Đơn hàng của tôi</h2>

        <table class="table table-bordered text-center align-middle">
            <thead class="table-dark">
                <tr>
                    <th>Mã đơn</th>
                    <th>Ngày đặt</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th>Chi tiết</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty orders}">
                    <tr>
                        <td colspan="5">Không có đơn hàng nào!</td>
                    </tr>
                </c:if>
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <td>#${order.orderId}</td>
                        <td>
                            <fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd"/>
                        </td>
                        <td>
                            <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫"/>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${order.status eq 'Completed'}">
                                    <span class="badge bg-success">Hoàn tất</span>
                                </c:when>
                                <c:when test="${order.status eq 'Shipped'}">
                                    <span class="badge bg-warning text-dark">Đang giao</span>
                                </c:when>
                                <c:when test="${order.status eq 'Canceled'}">
                                    <span class="badge bg-danger">Đã hủy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">${order.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/order-details?order_id=${order.orderId}" class="btn btn-sm btn-outline-primary">Xem</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <a href="home.jsp" class="btn btn-secondary mt-3"><i class="fas fa-arrow-left"></i> Quay về Trang chủ</a>
    </div>
</body>
</html>
