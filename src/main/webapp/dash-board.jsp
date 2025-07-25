<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Trang Quản Trị - Doanh Thu</title>
        <style>
            .chart-container {
                max-width: 700px;
                margin: 40px auto 24px auto;
                background: #fff;
                border-radius: 14px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.07);
                padding: 32px 18px 18px 18px;
            }
            .chart-header {
                font-size: 22px;
                font-weight: bold;
                margin-bottom: 10px;
                color: #333;
            }
            .chart-sub {
                font-size: 14px;
                color: #888;
                margin-bottom: 18px;
            }
            @media (max-width: 900px) {
                .chart-container {
                    max-width: 99vw;
                    padding: 10px;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="WEB-INF/include/admin-side-bar.jsp" %>
        <div class="main-content">
            <c:if test="${empty monthlyStats}">
                <div style="color:red; margin-bottom:10px;">Không có dữ liệu doanh thu!</div>
            </c:if>
            <div class="container mt-4">
                <h2>Chào mừng, Quản trị viên</h2>
                <p>Chào mừng bạn đến với trang quản trị. Đây là nơi quản lý tất cả nội dung của hệ thống.</p>
            </div>
            <div class="chart-container">
                <div class="chart-header">Thống kê doanh thu</div>
                <div class="chart-sub">Doanh thu theo tháng</div>
                <div style="display: flex; gap: 38px; flex-wrap: wrap;">
                    <div>
                        <div style="font-size:13px; color:#888; margin-bottom:4px;">Doanh thu tháng mới nhất</div>
                        <div style="font-size:26px; font-weight:bold;">
                            <fmt:formatNumber value="${not empty monthlyStats ? monthlyStats[0].revenue : 0}" type="number" groupingUsed="true" maxFractionDigits="0"/> ₫
                        </div>
                        <div style="font-size:13px; color:#888; margin:10px 0 4px 0;">Chỉ tiêu doanh thu</div>
                        <div style="font-size:20px;">50.000.000 ₫</div>
                        <div style="font-size:13px; color:#888; margin:10px 0 4px 0;">Đạt được</div>
                        <div style="font-size:20px; color:#5e2df7; font-weight:bold;">
                            <%
                                double target = 50000000;
                                double actual = 0;
                                if (request.getAttribute("monthlyStats") != null) {
                                    java.util.List stats = (java.util.List) request.getAttribute("monthlyStats");
                                    if (!stats.isEmpty()) {
                                        actual = ((model.AdminStaffSalesStats) stats.get(0)).getRevenue();
                                    }
                                }
                                int percent = (target > 0) ? (int) (actual / target * 100) : 0;
                                out.print(percent + "%");
                            %>
                        </div>
                        <div style="font-size:13px; color:#888; margin:10px 0 4px 0;">Tổng doanh thu</div>
                        <div style="font-size:20px; color:#5e2df7; font-weight:bold;">
                            <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true" maxFractionDigits="0"/> ₫
                        </div>
                    </div>
                    <div style="flex:1; min-width:260px;">
                        <canvas id="revenueChart" height="180"></canvas>
                    </div>
                </div>
                <div style="text-align:right; margin-top:8px;">
                    <a href="adminstaff-" style="color:#5e2df7;font-weight:bold;text-decoration:none;">XEM BÁO CÁO →</a>
                </div>
            </div>
        </div>
        <!-- Chart.js CDN -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            var monthLabels = [
            <c:forEach var="stat" items="${monthlyStats}" varStatus="loop">
        '${stat.month}/${stat.year}'<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
                ];
                var monthRevenue = [
            <c:forEach var="stat" items="${monthlyStats}" varStatus="loop">
                ${stat.revenue}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
                ];
                const ctx = document.getElementById('revenueChart').getContext('2d');
                const revenueChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: monthLabels,
                        datasets: [
                            {
                                label: 'Doanh thu thực tế',
                                data: monthRevenue,
                                backgroundColor: 'rgba(94,45,247, 0.75)'
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {position: 'bottom'}
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                // max: 60000000,
                                ticks: {stepSize: 10000000}
                            }
                        }
                    }
                });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
