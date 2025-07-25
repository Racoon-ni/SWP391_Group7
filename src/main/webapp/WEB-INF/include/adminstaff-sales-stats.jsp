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
            .btn-export {
                float: right;
                background-color: #28a745;
                color: white;
                padding: 8px 16px;
                border-radius: 5px;
                border: none;
                font-weight: bold;
                margin-bottom: 16px;
                cursor: pointer;
            }
            .btn-export:hover {
                background-color: #218838;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <a href="dash-board.jsp" class="btn-back">← Quay lại Dashboard</a>

            <!-- Nút xuất báo cáo Excel -->
            <button class="btn-export" onclick="exportAllTablesToExcel()">Xuất báo cáo</button>
            <div style="clear:both;"></div>

            <h2>Thống kê Bán hàng</h2>

            <!-- Sửa chỗ này: Nếu totalRevenue null thì hiển thị thông báo -->
            <div class="summary">
                Tổng doanh thu:
                <c:choose>
                    <c:when test="${not empty totalRevenue}">
                        <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                    </c:when>
                    <c:otherwise>
                        <span style="color:red;">(Không có dữ liệu)</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="section-title">Doanh thu theo ngày</div>
            <table id="reportTable">
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
            <table id="monthlyTable">
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

        <!-- Thư viện SheetJS và hàm xuất Excel -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
        <script>
                function autoFitColumns(worksheet, data) {
                    const colWidths = [];
                    const maxCols = data.reduce((max, row) => Math.max(max, row.length), 0);

                    for (let i = 0; i < maxCols; i++) {
                        let maxLength = 10;
                        data.forEach(row => {
                            if (row[i]) {
                                const cellValue = row[i].toString();
                                if (cellValue.length > maxLength)
                                    maxLength = cellValue.length;
                            }
                        });
                        colWidths.push({wch: maxLength + 2});
                    }

                    worksheet['!cols'] = colWidths;
                }

                function parseCurrency(text) {
                    if (!text)
                        return 0;
                    return Number(text.replace(/[₫,]/g, "").trim());
                }

                function exportAllTablesToExcel() {
                    const wb = XLSX.utils.book_new();

                    // === DOANH THU THEO NGÀY ===
                    const dailyTable = document.getElementById('reportTable');
                    const dailyRows = dailyTable.querySelectorAll("tbody tr");
                    const dailyData = [["Ngày", "Doanh thu (VNĐ)"]];
                    let dailyTotal = 0;

                    dailyRows.forEach(row => {
                        const date = row.cells[0].innerText.trim();
                        const rawRevenue = row.cells[1].innerText.trim();
                        const value = parseCurrency(rawRevenue);
                        dailyData.push([date, rawRevenue]);
                        dailyTotal += value;
                    });

                    // Thêm dòng tổng
                    dailyData.push(["Tổng doanh thu", "₫" + dailyTotal.toLocaleString("vi-VN")]);
                    const dailySheet = XLSX.utils.aoa_to_sheet(dailyData);
                    autoFitColumns(dailySheet, dailyData);
                    XLSX.utils.book_append_sheet(wb, dailySheet, "Revenue by Day");

                    // === DOANH THU THEO THÁNG ===
                    const monthlyTable = document.getElementById('monthlyTable');
                    const monthlyRows = monthlyTable.querySelectorAll("tbody tr");
                    const monthlyData = [["Tháng/Năm", "Doanh thu (VNĐ)"]];
                    let monthlyTotal = 0;

                    monthlyRows.forEach(row => {
                        const month = row.cells[0].innerText.trim();
                        const rawRevenue = row.cells[1].innerText.trim();
                        const value = parseCurrency(rawRevenue);
                        monthlyData.push([month, rawRevenue]);
                        monthlyTotal += value;
                    });

                    // Thêm dòng tổng
                    monthlyData.push(["Tổng doanh thu", "₫" + monthlyTotal.toLocaleString("vi-VN")]);
                    const monthlySheet = XLSX.utils.aoa_to_sheet(monthlyData);
                    autoFitColumns(monthlySheet, monthlyData);
                    XLSX.utils.book_append_sheet(wb, monthlySheet, "Revenue by Month");

                    // Ghi file
                    XLSX.writeFile(wb, "Revenue_Report.xlsx");
                }
        </script>

    </body>
</html>
