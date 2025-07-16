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

        double totalRevenue = dao.getTotalRevenue();
        ArrayList<AdminStaffSalesStats> dailyStats = dao.getDailyRevenue();
        List<AdminStaffSalesStats> monthlyStats = dao.getMonthlyRevenue();

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("dailyStats", dailyStats);
        request.setAttribute("monthlyStats", monthlyStats);

        request.getRequestDispatcher("/WEB-INF/include/adminstaff-sales-stats.jsp").forward(request, response);
    }
}
