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
import jakarta.servlet.http.HttpSession;
import model.User;

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
     * /**
     * Handles the HTTP <code>GET</code> method.
     *
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session != null) {
            User user = (User) session.getAttribute("user");
            Boolean isLogged = (Boolean) session.getAttribute("logged");

            if (Boolean.TRUE.equals(isLogged)) {
                if (user != null && (user.getRole().equalsIgnoreCase("Admin") || user.getRole().equalsIgnoreCase("Staff"))) {

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

                    request.getRequestDispatcher("/dash-board.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/home");

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

        HttpSession session = request.getSession(false);

        User user = (User) session.getAttribute("user");
        boolean isLogged = (boolean) session.getAttribute("logged");

        if (isLogged && (user.getRole().equalsIgnoreCase("Admin")
                || user.getRole().equalsIgnoreCase("Staff"))) {

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

            request.getRequestDispatcher("/dash-board.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
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
