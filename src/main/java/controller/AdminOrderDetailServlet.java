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

/**
 * Servlet AdminOrderDetailServlet
 *
 * <p>Chức năng:
 * - Hiển thị chi tiết đơn hàng cho Admin/Staff.
 * - Lấy dữ liệu từ DAO (Order, OrderDetail, ShippingInfo).
 * - Forward dữ liệu sang JSP hiển thị (order-detail-admin.jsp).
 * - Xử lý thông báo lỗi/thành công qua request parameter.
 *
 * <p>URL mapping: /order-detail-admin
 *
 * @author [Tên bạn]
 * @version 1.0
 */
@WebServlet("/order-detail-admin")
public class AdminOrderDetailServlet extends HttpServlet {

    /**
     * Xử lý HTTP GET request để hiển thị chi tiết đơn hàng.
     *
     * @param request  đối tượng HttpServletRequest chứa parameter "id" (orderId).
     * @param response đối tượng HttpServletResponse để phản hồi.
     * @throws ServletException nếu có lỗi Servlet.
     * @throws IOException      nếu có lỗi IO.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. Đọc orderId từ request parameter
            int orderId = Integer.parseInt(request.getParameter("id"));

            // 2. Gọi DAO để lấy dữ liệu liên quan đến đơn hàng
            orderDAO dao = new orderDAO();
            Order order = dao.getOrderById(orderId);
            List<OrderDetail> orderDetails = dao.getOrderDetailsNoUser(orderId);
            ShippingInfo shipping = dao.getShippingInfoByOrderId(orderId);

            // 3. Nếu dữ liệu tồn tại đầy đủ -> forward sang JSP
            if (order != null && orderDetails != null && shipping != null) {
                request.setAttribute("order", order);
                request.setAttribute("orderDetails", orderDetails);
                request.setAttribute("shipping", shipping);

                // 3.1 Đọc thông báo thành công/lỗi (nếu có)
                String message = request.getParameter("message");
                String error = request.getParameter("error");

                if (message != null && !message.trim().isEmpty()) {
                    request.setAttribute("message", message);
                }
                if (error != null && !error.trim().isEmpty()) {
                    request.setAttribute("error", error);
                }

                // 3.2 Forward dữ liệu đến JSP view
                request.getRequestDispatcher("/WEB-INF/include/order-detail-admin.jsp").forward(request, response);

            } else {
                // 4. Nếu thiếu dữ liệu -> redirect về trang manage-orders kèm error
                response.sendRedirect("manage-orders?error=MissingData");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có exception -> redirect với error
            response.sendRedirect("manage-orders?error=InvalidOrderId");
        }
    }

    /**
     * Xử lý HTTP POST request (tương tự GET).
     * 
     * <p>Chức năng: Lấy orderId, gọi DAO để lấy Order, OrderDetail, ShippingInfo,
     * gán vào request và forward sang JSP để hiển thị.
     *
     * @param request  đối tượng HttpServletRequest chứa parameter "id" (orderId).
     * @param response đối tượng HttpServletResponse để phản hồi.
     * @throws ServletException nếu có lỗi Servlet.
     * @throws IOException      nếu có lỗi IO.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int orderId = Integer.parseInt(request.getParameter("id"));

            orderDAO dao = new orderDAO();
            Order order = dao.getOrderById(orderId);
            List<OrderDetail> orderDetails = dao.getOrderDetailsNoUser(orderId);
            ShippingInfo shipping = dao.getShippingInfoByOrderId(orderId);

            if (order != null && orderDetails != null && shipping != null) {
                request.setAttribute("order", order);
                request.setAttribute("orderDetails", orderDetails);
                request.setAttribute("shipping", shipping);

                String message = request.getParameter("message");
                String error = request.getParameter("error");

                if (message != null && !message.trim().isEmpty()) {
                    request.setAttribute("message", message);
                }
                if (error != null && !error.trim().isEmpty()) {
                    request.setAttribute("error", error);
                }

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
