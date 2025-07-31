/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// THÊM import DAO/model nếu chưa có
import DAO.AdminStaffSalesDAO;
import model.AdminStaffSalesStats;
import java.util.List;

/**
 *
 * @author Huynh Trong Nguyen - CE190356
 */
@WebServlet(name = "DashBoardServlet", urlPatterns = {"/dash-board"})
public class DashBoardServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AdminStaffSalesDAO salesDAO = new AdminStaffSalesDAO();

        // Lấy danh sách doanh thu theo tháng và theo ngày
        List<AdminStaffSalesStats> monthlyStats = salesDAO.getMonthlyRevenue();
        List<AdminStaffSalesStats> dailyStats = salesDAO.getDailyRevenue();

        // ✅ Lấy tổng doanh thu (phần bị thiếu gây lỗi hiển thị)
        double totalRevenue = salesDAO.getTotalRevenue();

        // DEBUG (tùy chọn, bạn có thể xóa)
        System.out.println("Total Revenue: " + totalRevenue);
        System.out.println("Monthly Stats size: " + monthlyStats.size());
        System.out.println("Daily Stats size: " + dailyStats.size());

        // ✅ Set attribute để truyền sang JSP
        request.setAttribute("monthlyStats", monthlyStats);
        request.setAttribute("dailyStats", dailyStats);
        request.setAttribute("totalRevenue", totalRevenue); // ✅ Bổ sung dòng này

        // Chuyển tiếp tới trang dashboard
        request.getRequestDispatcher("/dash-board.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
