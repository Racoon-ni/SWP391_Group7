package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import DAO.orderDAO;
import java.io.IOException;

@WebServlet("/edit-order-status")
public class AdminUpdateOrderStatusServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");

            orderDAO dao = new orderDAO();
            dao.updateOrderStatus(orderId, status);

            // ✅ Đặt thông báo vào session (sẽ dùng 1 lần)
            HttpSession session = request.getSession();
            session.setAttribute("flashMessage", "Cập nhật trạng thái thành công!");

            response.sendRedirect("detail?id=" + orderId);
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("flashMessage", "❌ Lỗi cập nhật trạng thái!");
            response.sendRedirect("manage-orders");
        }
    }
}

