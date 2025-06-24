package controller;

import DAO.orderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="CancelOrderSevlet", urlPatterns={"/CancelOrderSevlet"})
public class CancelOrderSevlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        // Lấy session hiện tại, không tạo mới nếu chưa có
        HttpSession session = request.getSession(false);

        // Kiểm tra người dùng đã đăng nhập hay chưa
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?msg=not_login");
            return;
        }

        // Lấy userId từ session (đã đăng nhập)
        int userId = (int) session.getAttribute("userId");

        // Lấy orderId từ request
        String orderIdRaw = request.getParameter("orderId");
        if (orderIdRaw == null) {
            response.sendRedirect("my-orders?msg=cancel_fail");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdRaw);

            // Gọi DAO để xử lý hủy đơn
            orderDAO dao = new orderDAO();
            boolean success = dao.cancelPendingOrder(orderId, userId);

            if (success) {
                response.sendRedirect("my-orders?msg=cancel_success");
            } else {
                response.sendRedirect("my-orders?msg=cancel_fail");
            }
        } catch (NumberFormatException e) {
            // Trường hợp orderId không hợp lệ
            response.sendRedirect("my-orders?msg=invalid_order");
        }
    }
}
