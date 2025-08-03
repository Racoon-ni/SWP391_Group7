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

@WebServlet("/order-detail-admin")
public class AdminOrderDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int orderId = Integer.parseInt(request.getParameter("id"));

            orderDAO dao = new orderDAO();
            Order order = dao.getOrderById(orderId);
            List<OrderDetail> orderDetails = dao.getOrderDetailsNoUser(orderId);
            ShippingInfo shipping = dao.getShippingInfoByOrderId(orderId);

            System.out.println("Order: " + order);
            System.out.println("OrderDetails: " + orderDetails);
            System.out.println("Shipping: " + shipping);

            if (order != null && orderDetails != null && shipping != null) {
                request.setAttribute("order", order);
                request.setAttribute("orderDetails", orderDetails);
                request.setAttribute("shipping", shipping);
                request.getRequestDispatcher("/WEB-INF/include/order-detail-admin.jsp").forward(request, response);
            } else {
                response.sendRedirect("manage-orders?error=MissingData");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-orders?error=InvalidOrderId");
        }
    }
}
