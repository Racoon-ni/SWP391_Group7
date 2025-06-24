package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Order;
import model.OrderDetail;
import model.ShippingInfo;
import DAO.orderDAO;

import java.io.IOException;
import java.util.*;

@WebServlet(name = "MyOrderServlet", urlPatterns = {"/my-orders"})
public class MyOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Không tạo mới nếu chưa có
    if (session == null || session.getAttribute("userId") == null) {
        // Nếu chưa đăng nhập, chuyển hướng về trang login
        response.sendRedirect("login.jsp?msg=not_login");
        return;
    }

    // Nếu đã đăng nhập
    int userId = (int) session.getAttribute("userId");

    orderDAO dao = new orderDAO();
    List<Order> orders = dao.getOrdersByUserId(userId);
//        int userId = 1;
//
//        orderDAO dao = new orderDAO();
//        List<Order> orders = dao.getOrdersByUserId(userId);

        // --- Load ShippingInfo cho từng Order ---
        for (Order order : orders) {
            ShippingInfo info = dao.getShippingInfoByOrderId(order.getOrderId());
            order.setShippingInfo(info);
        }

        // --- Lấy chi tiết từng đơn hàng (OrderDetails) ---
        Map<Integer, List<OrderDetail>> orderDetailsMap = new HashMap<>();
        for (Order order : orders) {
            List<OrderDetail> details = dao.getOrderDetails(order.getOrderId());
            orderDetailsMap.put(order.getOrderId(), details);
        }

        request.setAttribute("orders", orders);
        request.setAttribute("orderDetailsMap", orderDetailsMap); // truyền sang JSP

        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/include/myOrders.jsp");
        rd.forward(request, response);
    }
}
