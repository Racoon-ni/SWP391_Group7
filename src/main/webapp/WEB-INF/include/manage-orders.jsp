<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý đơn hàng</title>
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: #f8f9fa;
                padding: 40px;
            }

            .container {
                max-width: 1000px;
                margin: auto;
                background-color: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 3px 8px rgba(0,0,0,0.1);
            }

            h2 {
                text-align: center;
                margin-bottom: 30px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                font-size: 16px;
            }

            th, td {
                padding: 12px;
                text-align: center;
                border-bottom: 1px solid #ddd;
            }

            th {
                background-color: #007bff;
                color: white;
            }

            tr:hover {
                background-color: #f1f1f1;
            }

            .btn {
                padding: 6px 12px;
                border: none;
                border-radius: 4px;
                color: white;
                cursor: pointer;
                text-decoration: none;
            }

            .btn-detail {
                background-color: #17a2b8;
            }

            .btn-edit {
                background-color: #ffc107;
                color: black;
            }

            .pagination {
                margin-top: 30px;
                text-align: center;
            }

            .pagination a {
                display: inline-block;
                margin: 0 5px;
                padding: 8px 14px;
                border: 1px solid #007bff;
                border-radius: 4px;
                text-decoration: none;
                color: #007bff;
            }

            .pagination a.active {
                background-color: #007bff;
                color: white;
            }

            .empty {
                text-align: center;
                font-style: italic;
                padding: 20px;
                color: gray;

            }
            .btn-back {
                display: inline-block;
                background-color: #6c757d; /* Xám nhạt */
                color: white;
                padding: 8px 16px;
                border-radius: 5px;
                text-decoration: none;
                font-weight: bold;
                transition: background-color 0.3s ease;
                margin-bottom: 20px;
            }

            .btn-back:hover {
                background-color: #5a6268; /* Màu hover tối hơn */
                text-decoration: none;
            }

        </style>
    </head>
    <body>

        <div class="container">
            <a href="dash-board.jsp" class="btn-back">← Quay lại Dashboard</a>
            <h2>Quản lý Đơn hàng</h2>

            <c:choose>
                <c:when test="${not empty orders}">
                    <table>
                        <thead>
                            <tr>
                                <th>Mã đơn hàng</th>
                                <th>Mã khách hàng</th>
                                <th>Ngày đặt</th>
                                <th>Tổng giá trị (VNĐ)</th>
                                <th>Trạng thái</th>
                                <th>Xem chi tiết</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td>${order.orderId}</td>
                                    <td>${order.customerId}</td>
                                    <td>${order.orderDate}</td>
                                    <td><fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="" /></td>
                                    <td>${order.status}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/order-detail-admin?id=${order.orderId}" class="btn btn-detail">Chi tiết</a>
                                    </td>
                                    
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div class="pagination">
                        <a href="#" class="active">1</a>
                        <a href="#">2</a>
                        <a href="#">3</a>
                        <a href="#">...</a>
                        <a href="#">Trang kế ›</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty">Không có đơn hàng nào để hiển thị.</div>
                </c:otherwise>
            </c:choose>
        </div>

    </body>
</html>
