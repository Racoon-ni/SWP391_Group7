package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import DAO.orderDAO;
import model.Order;
import model.OrderDetail;
import model.ShippingInfo;
import model.User;

@WebServlet("/order-detail-admin")
public class AdminOrderDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession(false);
            int orderId = Integer.parseInt(request.getParameter("id"));
            User user = (User) session.getAttribute("user");

            int userId = user.getId();
            orderDAO dao = new orderDAO();
            Order order = dao.getOrderById(orderId);
            List<OrderDetail> orderDetails = dao.getOrderDetails(orderId, userId);
            ShippingInfo shipping = dao.getShippingInfoByOrderId(orderId);

            if (order != null) {
                request.setAttribute("order", order);
                request.setAttribute("orderDetails", orderDetails);
                request.setAttribute("shipping", shipping);
                request.getRequestDispatcher("/WEB-INF/include/order-detail-admin.jsp").forward(request, response);
            } else {
                response.sendRedirect("manage-orders?error=OrderNotFound");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-orders?error=InvalidOrderId");
        }
    }
}
