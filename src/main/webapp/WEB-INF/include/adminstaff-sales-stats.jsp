<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thống kê Bán hàng</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f2f4f8;
            padding: 40px;
        }

        .container {
            max-width: 1200px;
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

        .summary-cards {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
        }

        .card {
            flex: 1;
            background-color: #f8f9fa;
            border-left: 6px solid;
            padding: 20px;
            margin: 0 10px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .card.green { border-color: #28a745; }
        .card.blue { border-color: #007bff; }
        .card.orange { border-color: #fd7e14; }

        .card h3 {
            font-size: 16px;
            color: #555;
            margin-bottom: 10px;
        }

        .card .value {
            font-size: 24px;
            font-weight: bold;
            color: #000;
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

        .export-form {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 30px;
            gap: 10px;
        }

        select, button {
            padding: 6px 12px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        button {
            background-color: #28a745;
            color: white;
            border: none;
            cursor: pointer;
        }

        button:hover {
            background-color: #218838;
        }

        .section-title {
            font-size: 18px;
            font-weight: bold;
            color: #555;
            margin: 20px 0 10px 0;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Thống kê Bán hàng</h2>

    <div class="summary-cards">
        <div class="card green">
            <h3>Tổng doanh thu</h3>
            <div class="value"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" groupingUsed="true"/></div>
        </div>
        <div class="card blue">
            <h3>Hôm nay</h3>
            <div class="value"><fmt:formatNumber value="${todayRevenue}" type="currency" currencySymbol="₫" groupingUsed="true"/></div>
        </div>
        <div class="card orange">
            <h3>Tháng này</h3>
            <div class="value"><fmt:formatNumber value="${thisMonthRevenue}" type="currency" currencySymbol="₫" groupingUsed="true"/></div>
        </div>
    </div>

    <div class="export-form">
        <form action="sales-export" method="get">
            <label for="exportType">📤 Xuất Excel:</label>
            <select name="type" id="exportType" required>
                <option value="day">7 ngày gần nhất</option>
                <option value="month">6 tháng gần nhất</option>
            </select>
            <button type="submit">Export</button>
        </form>
    </div>

    <div class="section-title">Chi tiết doanh thu theo ngày</div>
    <table>
        <thead>
            <tr><th>Ngày</th><th>Doanh thu (VNĐ)</th></tr>
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

    <div class="section-title">Chi tiết doanh thu theo tháng</div>
    <table>
        <thead>
            <tr><th>Tháng/Năm</th><th>Doanh thu (VNĐ)</th></tr>
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
