package controller;

import DAO.AdminStaffSalesDAO;
import model.AdminStaffSalesStats;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/adminstaff-")
public class AdminStaffSalesStatsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AdminStaffSalesDAO dao = new AdminStaffSalesDAO();

         // Tổng doanh thu
        double totalRevenue = dao.getTotalRevenue();

        // Doanh thu hôm nay
        double todayRevenue = dao.getTodayRevenue();

        // Doanh thu tháng này
        double thisMonthRevenue = dao.getThisMonthRevenue();

        // Toàn bộ theo ngày & tháng (cho bảng chi tiết)
        List<AdminStaffSalesStats> dailyStats = dao.getDailyRevenue();
        List<AdminStaffSalesStats> monthlyStats = dao.getMonthlyRevenue();

        // Dữ liệu 7 ngày gần nhất (biểu đồ + export)
        List<AdminStaffSalesStats> last7DaysStats = dao.getLast7DaysRevenue();

        // Dữ liệu 6 tháng gần nhất (biểu đồ + export)
        List<AdminStaffSalesStats> last6MonthsStats = dao.getLast6MonthsRevenue();

        // Gửi dữ liệu sang JSP
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("todayRevenue", todayRevenue);
        request.setAttribute("thisMonthRevenue", thisMonthRevenue);

        request.setAttribute("dailyStats", dailyStats);
        request.setAttribute("monthlyStats", monthlyStats);

        request.setAttribute("last7DaysStats", last7DaysStats);
        request.setAttribute("last6MonthsStats", last6MonthsStats);
        request.getRequestDispatcher("/WEB-INF/include/adminstaff-sales-stats.jsp").forward(request, response);
    }
}
