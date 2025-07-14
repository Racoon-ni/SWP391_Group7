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

            /* Phần khối lọc */
            /* Vùng chứa form */
            .filter-form {
                background-color: #f9f9f9;
                padding: 20px;
                border-radius: 8px;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 16px;
                align-items: end;
                margin-bottom: 30px;
            }

            /* Label cho mỗi input/select */
            .filter-form label {
                font-weight: bold;
                display: block;
                margin-bottom: 6px;
            }

            /* Các ô input và dropdown */
            .filter-form input,
            .filter-form select {
                width: 100%;
                padding: 8px 10px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
            }

            /* Vùng chứa 2 nút Lọc & Xoá */
            .actions {
                display: flex;
                justify-content: flex-end;
                align-items: center;
                gap: 12px;
                grid-column: 1 / -1; /* để hàng cuối kéo dài toàn bộ form */
            }

            /* Nút Lọc */
            .actions button[type="submit"] {
                background-color: #007bff;
                color: white;
                font-weight: bold;
                border: none;
                padding: 8px 18px;
                border-radius: 6px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            .actions button[type="submit"]:hover {
                background-color: #0056b3;
            }

            /* Nút Xoá lọc */
            .actions .btn-reset {
                color: #dc3545;
                font-weight: bold;
                text-decoration: underline;
                cursor: pointer;
            }

            .actions .btn-reset:hover {
                color: #a71d2a;
            }

        </style>
    </head>
    <body>

        <div class="container">
            <a href="dash-board.jsp" class="btn-back">← Quay lại </a>
            <h2>Quản lý Đơn hàng</h2>
            <form method="get" action="manage-orders"  class="filter-form"> 
                <!-- Lọc theo trạng thái -->
                <div>
                    <label>Trạng thái:</label>
                    <select name="status">
                        <option value="">-- Tất cả --</option>
                        <option value="Pending" ${selectedStatus == 'Pending' ? 'selected' : ''}>Chờ xử lý</option>
                        <option value="Processing" ${selectedStatus == 'Processing' ? 'selected' : ''}>Đang xử lý</option>
                        <option value="Completed" ${selectedStatus == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                        <option value="Cancelled" ${selectedStatus == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                    </select>
                </div>

                <div>
                    <label>Ngày:</label>
                    <input type="date" name="date" value="${selectedDate}" />
                </div>

                <div>
                    <label>Tháng:</label>
                    <input type="month" name="month" value="${selectedMonth}" />
                </div>

                <div>
                    <label>Từ ngày:</label>
                    <input type="date" name="fromDate" value="${selectedFrom}" />
                </div>

                <div>
                    <label>Đến ngày:</label>
                    <input type="date" name="toDate" value="${selectedTo}" />
                </div>

                <div class="actions">
                    <button type="submit">Lọc</button>
                    <a href="manage-orders" class="btn-reset">Xoá lọc</a>
                </div>
            </form>

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
