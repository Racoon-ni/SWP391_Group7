<%@ include file="/WEB-INF/include/admin-side-bar.jsp" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý đơn hàng</title>
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #f0f4f8, #e6ebf1);
            padding: 40px;
        }

        .container {
            max-width: 1200px;
            margin: auto;
            background: #fff;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            animation: fadeIn 0.6s ease;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            font-weight: bold;
            font-size: 28px;
            color: #2c3e50;
        }

        h2 i {
            color: #007bff;
            margin-right: 8px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 15px;
            border-radius: 12px;
            overflow: hidden;
            margin-top: 20px;
        }

        th, td {
            padding: 14px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }

        th {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: #fff;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        tr {
            transition: all 0.2s ease;
        }

        tr:hover {
            background-color: #f9fbfd;
            transform: scale(1.01);
        }

        .btn {
            padding: 8px 14px;
            border: none;
            border-radius: 8px;
            color: white;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-detail {
            background: linear-gradient(135deg, #17a2b8, #138496);
        }
        .btn-detail:hover {
            background: linear-gradient(135deg, #138496, #0d6efd);
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }

        /* Trạng thái */
        .status {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .status-pending { background: #fff3cd; color: #856404; }
        .status-processing { background: #cce5ff; color: #004085; }
        .status-completed { background: #d4edda; color: #155724; }
        .status-cancelled { background: #f8d7da; color: #721c24; }

        .pagination {
            margin-top: 30px;
            text-align: center;
        }

        .pagination a {
            display: inline-block;
            margin: 0 5px;
            padding: 10px 16px;
            border-radius: 8px;
            text-decoration: none;
            color: #007bff;
            font-weight: 500;
            border: 1px solid #007bff;
            transition: all 0.3s;
        }

        .pagination a.active,
        .pagination a:hover {
            background: #007bff;
            color: #fff;
            transform: scale(1.05);
        }

        .empty {
            text-align: center;
            font-style: italic;
            padding: 25px;
            color: gray;
            font-size: 16px;
        }

        .empty i {
            font-size: 28px;
            color: #adb5bd;
            margin-bottom: 8px;
            display: block;
        }

        /* Bộ lọc */
        .filter-form {
            background: #f9fafc;
            padding: 20px;
            border-radius: 12px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 18px;
            align-items: end;
            margin-bottom: 30px;
            border: 1px solid #eaeaea;
        }

        .filter-form label {
            font-weight: 600;
            margin-bottom: 6px;
            color: #34495e;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .filter-form input,
        .filter-form select {
            width: 100%;
            padding: 9px 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .filter-form input:focus,
        .filter-form select:focus {
            border-color: #007bff;
            outline: none;
        }

        .actions {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 12px;
            grid-column: 1 / -1;
        }

        .actions button[type="submit"] {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            font-weight: bold;
            border: none;
            padding: 9px 20px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .actions button[type="submit"]:hover {
            background: linear-gradient(135deg, #0056b3, #004085);
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0,0,0,0.15);
        }

        .actions .btn-reset {
            color: #dc3545;
            font-weight: bold;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 4px;
            text-decoration: none;
        }

        .actions .btn-reset:hover {
            color: #a71d2a;
        }

        /* Animations */
        @keyframes fadeIn {
            from {opacity: 0; transform: translateY(20px);}
            to {opacity: 1; transform: translateY(0);}
        }
    </style>
</head>
<body>
    <div class="container">
        <h2><i class="bi bi-bag-check-fill"></i> Quản lý Đơn hàng</h2>

        <!-- Bộ lọc -->
        <form method="get" action="manage-orders" class="filter-form"> 
            <div>
                <label><i class="bi bi-funnel-fill"></i> Trạng thái:</label>
                <select name="status">
                    <option value="">-- Tất cả --</option>
                    <option value="Pending" ${selectedStatus == 'Pending' ? 'selected' : ''}>Chờ xử lý</option>
                    <option value="Processing" ${selectedStatus == 'Processing' ? 'selected' : ''}>Đang xử lý</option>
                    <option value="Completed" ${selectedStatus == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                    <option value="Cancelled" ${selectedStatus == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                </select>
            </div>

            <div>
                <label><i class="bi bi-calendar-date"></i> Ngày:</label>
                <input type="date" name="date" value="${selectedDate}" />
            </div>

            <div>
                <label><i class="bi bi-calendar3"></i> Tháng:</label>
                <input type="month" name="month" value="${selectedMonth}" />
            </div>

            <div>
                <label><i class="bi bi-calendar-range"></i> Từ ngày:</label>
                <input type="date" name="fromDate" value="${selectedFrom}" />
            </div>

            <div>
                <label><i class="bi bi-calendar-range-fill"></i> Đến ngày:</label>
                <input type="date" name="toDate" value="${selectedTo}" />
            </div>

            <div class="actions">
                <button type="submit"><i class="bi bi-search"></i> Lọc</button>
                <a href="manage-orders" class="btn-reset"><i class="bi bi-x-circle"></i> Xoá lọc</a>
            </div>
        </form>

        <!-- Danh sách đơn -->
        <c:choose>
            <c:when test="${not empty orders}">
                <table>
                    <thead>
                        <tr>
                            <th><i class="bi bi-hash"></i> Mã đơn hàng</th>
                            <th><i class="bi bi-person-fill"></i> Mã khách hàng</th>
                            <th><i class="bi bi-calendar-event"></i> Ngày đặt</th>
                            <th><i class="bi bi-cash-coin"></i> Tổng giá trị (VNĐ)</th>
                            <th><i class="bi bi-clipboard-check"></i> Trạng thái</th>
                            <th><i class="bi bi-eye-fill"></i> Xem chi tiết</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td>${order.orderId}</td>
                                <td>${order.customerId}</td>
                                <td>${order.orderDate}</td>
                                <td><fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.status == 'Pending'}">
                                            <span class="status status-pending"><i class="bi bi-hourglass-split"></i> Chờ xử lý</span>
                                        </c:when>
                                        <c:when test="${order.status == 'Processing'}">
                                            <span class="status status-processing"><i class="bi bi-arrow-repeat"></i> Đang xử lý</span>
                                        </c:when>
                                        <c:when test="${order.status == 'Completed'}">
                                            <span class="status status-completed"><i class="bi bi-check-circle-fill"></i> Hoàn thành</span>
                                        </c:when>
                                        <c:when test="${order.status == 'Cancelled'}">
                                            <span class="status status-cancelled"><i class="bi bi-x-octagon-fill"></i> Đã hủy</span>
                                        </c:when>
                                        <c:otherwise>
                                            ${order.status}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/order-detail-admin?id=${order.orderId}" class="btn btn-detail">
                                        <i class="bi bi-eye"></i> Chi tiết
                                    </a>
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
                <div class="empty">
                    <i class="bi bi-inbox"></i>
                    Không có đơn hàng nào để hiển thị.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
