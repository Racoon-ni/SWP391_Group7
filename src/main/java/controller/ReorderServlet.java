package controller;

import DAO.orderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import model.Order;
import model.OrderDetail;
import model.ShippingInfo;
import model.User;

@WebServlet("/reorder")
public class ReorderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login?msg=not_login");
            return;
        }

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));

            orderDAO dao = new orderDAO();
            Order order = dao.getOrderById(orderId);
            ShippingInfo shippingInfo = dao.getShippingInfoByOrderId(orderId);
            List<OrderDetail> orderDetails = dao.getOrderDetails(orderId);

            request.setAttribute("order", order);
            request.setAttribute("shippingInfo", shippingInfo);
            request.setAttribute("orderDetails", orderDetails);

            request.getRequestDispatcher("/WEB-INF/include/reorder.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("my-orders?msg=reorder_fail");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login?msg=not_login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));

            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String paymentMethod = request.getParameter("paymentMethod");

            String[] productIds = request.getParameterValues("productIds");
            String[] quantities = request.getParameterValues("quantities");

            if (productIds == null || quantities == null || productIds.length != quantities.length) {
                response.sendRedirect("my-orders?msg=reorder_fail");
                return;
            }

            orderDAO dao = new orderDAO();
            int newOrderId = dao.reorder(orderId, phone, address, paymentMethod, productIds, quantities, userId);

            if (newOrderId > 0) {
                response.sendRedirect("my-orders?msg=reorder_success");
            } else {
                response.sendRedirect("my-orders?msg=reorder_fail");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("my-orders?msg=error");
        }
    }
}
