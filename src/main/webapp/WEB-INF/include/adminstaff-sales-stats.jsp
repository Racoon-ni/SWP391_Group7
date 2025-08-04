 
<%@ page pageEncoding="UTF-8" %>
<%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
        <%@include file="admin-side-bar.jsp" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Thống kê Bán hàng</title>
    <style>
      body {
        font-family: "Segoe UI", sans-serif;
        background: #f2f4f8;
        padding: 40px;
      }
      .container {
        max-width: 1200px;
        margin: auto;
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
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
        flex-wrap: wrap;
        gap: 16px;
      }
      .card {
        flex: 1;
        min-width: 220px;
        background: #f8f9fa;
        border-left: 6px solid;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
      }
      .card.green {
        border-color: #28a745;
      }
      .card.blue {
        border-color: #007bff;
      }
      .card.orange {
        border-color: #fd7e14;
      }
      .card h3 {
        font-size: 16px;
        color: #555;
        margin-bottom: 8px;
      }
      .card .value {
        font-size: 24px;
        font-weight: bold;
        color: #000;
      }
      .export-form {
        display: flex;
        justify-content: flex-end;
        margin-bottom: 16px;
        gap: 12px;
        align-items: center;
        flex-wrap: wrap;
      }
      .export-form select {
        font-size: 1rem;
        padding: 6px 10px;
        border-radius: 6px;
        border: 1px solid #ccc;
      }
      .export-form button {
        background: #28a745;
        color: white;
        border: none;
        padding: 8px 16px;
        border-radius: 6px;
        font-weight: 600;
        cursor: pointer;
      }
      .export-form button:hover {
        background: #218838;
      }
      table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 40px;
      }
      th,
      td {
        padding: 12px;
        text-align: center;
        border-bottom: 1px solid #ddd;
      }
      th {
        background: #007bff;
        color: white;
      }
      tr:hover {
        background: #f1f1f1;
      }
      .section-title {
        font-size: 18px;
        font-weight: bold;
        color: #555;
        margin: 20px 0 10px 0;
      }
      .flex-between {
        display: flex;
        justify-content: space-between;
        flex-wrap: wrap;
        gap: 8px;
      }
    </style>
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css"
    />
  </head>
  <body>
    <div class="container">
      <div class="flex-between">
        <h2>Thống kê Bán hàng</h2>
      </div>
      <div class="export-form">
        <label>
          <select id="reportType" style="min-width: 120px">
            <option value="all">Tất cả</option>
            <option value="day">Theo ngày</option>
            <option value="month">Theo tháng</option>
          </select>
        </label>
        <button type="button" onclick="exportExcel()">
          📤 Xuất báo cáo Excel
        </button>
      </div>

      <div class="summary-cards">
        <div class="card green">
          <h3>Tổng doanh thu</h3>
          <div class="value" id="totalRevenueCard">
            <c:choose>
              <c:when test="${not empty totalRevenue}">
                <fmt:formatNumber value="${totalRevenue}" pattern="#,##0" /> VND
              </c:when>
              <c:otherwise> ₫0.00 </c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="card blue">
          <h3>Hôm nay</h3>
          <div class="value" id="todayRevenueCard">
            <c:choose>
              <c:when test="${not empty todayRevenue}">
                <fmt:formatNumber value="${todayRevenue}" pattern="#,##0" /> VND
              </c:when>
              <c:otherwise> VND </c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="card orange">
          <h3>Tháng này</h3>
          <div class="value" id="thisMonthRevenueCard">
            <c:choose>
              <c:when test="${not empty thisMonthRevenue}">
                <fmt:formatNumber
                  value="${thisMonthRevenue}"
                  pattern="#,##0"
                /> VND
              </c:when>
              <c:otherwise> VND0.00 </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <div class="section">
        <div class="section-title">Chi tiết doanh thu theo ngày</div>
        <table id="dailyTable">
          <thead>
            <tr>
              <th>Ngày</th>
              <th>Doanh thu (VND)</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="stat" items="${dailyStats}">
              <tr>
                <td>
                  <fmt:formatDate value="${stat.date}" pattern="dd/MM/yyyy" />
                </td>
                <td>
                  <fmt:formatNumber
                    value="${stat.revenue}"
                    pattern="#,##0"
                  /> VND
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty dailyStats}">
              <tr>
                <td colspan="2" style="color: #777">
                  Không có dữ liệu theo ngày
                </td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>

      <div class="section">
        <div class="section-title">Chi tiết doanh thu theo tháng</div>
        <table id="monthlyTable">
          <thead>
            <tr>
              <th>Tháng/Năm</th>
              <th>Doanh thu (VND)</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="stat" items="${monthlyStats}">
              <tr>
                <td>${stat.month}/${stat.year}</td>
                <td>
                  <fmt:formatNumber
                    value="${stat.revenue}"
                    pattern="#,##0"
                  /> VND
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty monthlyStats}">
              <tr>
                <td colspan="2" style="color: #777">
                  Không có dữ liệu theo tháng
                </td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <script>
      function parseCurrency(str) {
        if (!str) return 0;
        str = str.replace(/₫|\s|,/g, "");
        str = str.replace(/\.00$/, "");
        return Number(str) || 0;
      }

      // Chỉ xuất toàn bộ dữ liệu (không lọc) khi chọn "Theo ngày"
      function buildSheetFromTable(tableId) {
        const table = document.getElementById(tableId);
        if (!table) return null;
        const headers = Array.from(table.querySelectorAll("thead th")).map(
          (th) => th.innerText.trim()
        );
        // Lấy tất cả dòng hợp lệ (bỏ dòng tổng, không có dữ liệu)
        let rows = Array.from(table.querySelectorAll("tbody tr")).filter(
          (tr) => {
            const cells = tr.querySelectorAll("td");
            if (cells.length < 2) return false;
            const txt = cells[0].innerText.trim().toLowerCase();
            return txt !== "tổng" && !/không có/i.test(cells[1].innerText);
          }
        );
        if (!rows.length) return null;

        const aoa = [headers];
        let total = 0;
        rows.forEach((tr) => {
          const cells = tr.querySelectorAll("td");
          const label = cells[0].innerText.trim();
          const raw = cells[1].innerText.trim();
          aoa.push([label, raw]);
          if (label && raw && !/không có/i.test(raw)) {
            total += parseCurrency(raw);
          }
        });
        
        const ws = XLSX.utils.aoa_to_sheet(aoa);
        const colWidths = headers.map((h, i) => {
          let max = h.length;
          aoa.slice(1).forEach((row) => {
            if (row[i]) max = Math.max(max, row[i].toString().length);
          });
          return { wch: max + 2 };
        });
        ws["!cols"] = colWidths;
        return ws;
      }

      function exportExcel() {
        const type = document.getElementById("reportType").value;
        const wb = XLSX.utils.book_new();
        // Sheet tổng quan
        const summaryData = [
          ["BÁO CÁO DOANH THU"],
          [
            "Tổng doanh thu",
            document.getElementById("totalRevenueCard")?.innerText || "",
          ],
          [
            "Hôm nay",
            document.getElementById("todayRevenueCard")?.innerText || "",
          ],
          [
            "Tháng này",
            document.getElementById("thisMonthRevenueCard")?.innerText || "",
          ],
        ];
        const summarySheet = XLSX.utils.aoa_to_sheet(summaryData);
        summarySheet["!merges"] = [{ s: { r: 0, c: 0 }, e: { r: 0, c: 1 } }];
        summarySheet["!cols"] = [{ wch: 25 }, { wch: 20 }];
        XLSX.utils.book_append_sheet(wb, summarySheet, "Tổng quan");
        let ws = null;
        if (type === "all" || type === "day") {
          ws = buildSheetFromTable("dailyTable");
          if (ws) XLSX.utils.book_append_sheet(wb, ws, "Theo ngày");
          if (type === "all") {
            const ws2 = buildSheetFromTable("monthlyTable");
            if (ws2) XLSX.utils.book_append_sheet(wb, ws2, "Theo tháng");
          }
        } else if (type === "month") {
          ws = buildSheetFromTable("monthlyTable");
          if (ws) XLSX.utils.book_append_sheet(wb, ws, "Theo tháng");
        }
        if (!ws) {
          alert("Không có dữ liệu để xuất báo cáo!");
          return;
        }
        const now = new Date();
        const stamp = now.toISOString().slice(0, 19).replace(/[:T]/g, "-");
        XLSX.writeFile(wb, `Sales_Report_${stamp}.xlsx`);
      }
    </script>
  </body>
</html>
