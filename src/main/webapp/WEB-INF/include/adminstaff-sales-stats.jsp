<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thống kê bán hàng</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f2f4f8;
            padding: 40px;
        }

        .container {
            max-width: 1100px;
            margin: auto;
            background-color: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        .summary {
            text-align: center;
            font-size: 20px;
            margin-bottom: 40px;
            font-weight: bold;
            color: #28a745;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 40px;
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

        .section-title {
            font-size: 18px;
            font-weight: bold;
            margin: 30px 0 10px 0;
            color: #555;
        }

        .btn-back {
            display: inline-block;
            background-color: #6c757d;
            color: white;
            padding: 8px 16px;
            border-radius: 5px;
            text-decoration: none;
            transition: background-color 0.3s ease;
            margin-bottom: 20px;
        }

        .btn-back:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>

<div class="container">
    <a href="dash-board.jsp" class="btn-back">← Quay lại Dashboard</a>
    <h2>Thống kê Bán hàng</h2>

    <div class="summary">
        Tổng doanh thu: 
        <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" groupingUsed="true"/>
    </div>

    <div class="section-title">Doanh thu theo ngày</div>
    <table>
        <thead>
            <tr>
                <th>Ngày</th>
                <th>Doanh thu (VNĐ)</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="stat" items="${dailyStats}">
                <tr>
                    <td><fmt:formatDate value="${stat.date}" pattern="dd/MM/yyyy"/></td>
                    <td><fmt:formatNumber value="${stat.revenue}" type="currency" currencySymbol="₫" groupingUsed="true"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="section-title">Doanh thu theo tháng</div>
    <table>
        <thead>
            <tr>
                <th>Tháng/Năm</th>
                <th>Doanh thu (VNĐ)</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="stat" items="${monthlyStats}">
                <tr>
                    <td>${stat.month}/${stat.year}</td>
                    <td><fmt:formatNumber value="${stat.revenue}" type="currency" currencySymbol="₫" groupingUsed="true"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>
