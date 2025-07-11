/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.AdminStaffOrder;

import DAO.AdminStaffOrderDAO;
import DAO.orderDAO;

import java.io.IOException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author ADMIN
 */
@WebServlet("/manage-orders")
public class AdminStaffOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lấy các giá trị lọc từ request
        String status = req.getParameter("status");
        String date = req.getParameter("date");
        String month = req.getParameter("month");
        String fromDate = req.getParameter("fromDate");
        String toDate = req.getParameter("toDate");

        AdminStaffOrderDAO repo = new AdminStaffOrderDAO();
        ArrayList<AdminStaffOrder> orders = repo.filterOrders(status, date, month, fromDate, toDate);

        // Truyền lại giá trị đã chọn để giữ input
        req.setAttribute("orders", orders);
        req.setAttribute("selectedStatus", status);
        req.setAttribute("selectedDate", date);
        req.setAttribute("selectedMonth", month);
        req.setAttribute("selectedFrom", fromDate);
        req.setAttribute("selectedTo", toDate);

        req.getRequestDispatcher("/WEB-INF/include/manage-orders.jsp").forward(req, resp);
    }


        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String newStatus = request.getParameter("status");

                orderDAO dao = new orderDAO();
                boolean updated = dao.updateOrderStatus(orderId, newStatus);

                HttpSession session = request.getSession();
                if (updated) {
                    session.setAttribute("flashMessage", "✅ Cập nhật trạng thái thành công!");
                } else {
                    session.setAttribute("flashMessage", "❌ Không thể cập nhật trạng thái đơn hàng.");
                }

                response.sendRedirect("order-detail-admin?id=" + orderId);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("manage-orders?error=UpdateFailed");
            }
        }
    }
