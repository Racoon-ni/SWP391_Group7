package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.OrderDetail;
import model.Order;
import model.ShippingInfo;
import repository.orderDAO;
import java.io.IOException;
import java.util.List;

@WebServlet(name="OrderDetailsServlet", urlPatterns={"/order-details"})
public class OrderDetailsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String orderIdStr = request.getParameter("order_id");
        if (orderIdStr == null) {
            response.sendRedirect("my-orders"); // sửa lại đường dẫn
            return;
        }
        int orderId = Integer.parseInt(orderIdStr);

        orderDAO dao = new orderDAO();

        // Lấy từng thông tin cần thiết
        List<OrderDetail> details = dao.getOrderDetails(orderId);
        Order order = dao.getOrderById(orderId);
        ShippingInfo shippingInfo = dao.getShippingInfoByOrderId(orderId);

        // Đưa lên request cho JSP
        request.setAttribute("orderDetails", details);
        request.setAttribute("order", order);
        request.setAttribute("shippingInfo", shippingInfo);

        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/include/orderDetails.jsp");
        rd.forward(request, response);
    }
}
