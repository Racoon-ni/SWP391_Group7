package controller;

import DAO.CartDAO;
import DAO.orderDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Cart;
import model.Order;
import model.ShippingInfo;
import model.User;

import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/place-order")
public class PlaceOrderServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String fullname = request.getParameter("fullName");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String paymentMethod = request.getParameter("paymentMethod");

        // Tạo đối tượng ShippingInfo
        ShippingInfo shipping = new ShippingInfo();
        shipping.setReceiverName(fullname);
        shipping.setShippingAddress(address);
        shipping.setPhone(phone);
        shipping.setPaymentMethod(paymentMethod);
        shipping.setPaymentStatus("Pending");

        // Lấy giỏ hàng và tính tổng tiền
        CartDAO cartDAO = new CartDAO();
        List<Cart> cartItems = cartDAO.getCartItemsByUserId(user.getId());
        double total = cartDAO.calculateTotal(cartItems);

        // Tạo Order
        Order order = new Order(0, user.getId(), "Pending", total, new Date());
        order.setShippingInfo(shipping);

        // Lưu đơn hàng
        orderDAO orderDAO = new orderDAO();
        orderDAO.placeOrder(order);

        // (Tùy chọn) Xóa giỏ hàng sau khi đặt
        // cartDAO.clearCartByUserId(user.getId());

        response.sendRedirect("home.jsp");
    }
}