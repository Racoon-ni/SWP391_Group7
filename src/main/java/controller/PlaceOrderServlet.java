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

        String fullname = request.getParameter("fullname");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String paymentMethod = request.getParameter("paymentMethod");

        // Tạo thông tin giao hàng
        ShippingInfo shipping = new ShippingInfo();
        shipping.setReceiverName(fullname);
        shipping.setShippingAddress(address);
        shipping.setPhone(phone);
        shipping.setPaymentMethod(paymentMethod);
        shipping.setPaymentStatus("Pending");

        // ✅ Lấy cart đã chọn từ session (đã được set ở CheckoutServlet)
        @SuppressWarnings("unchecked")
        List<Cart> cartItems = (List<Cart>) session.getAttribute("cartItems");

        if (cartItems == null || cartItems.isEmpty()) {
            // fallback: lấy toàn bộ cart (nếu không chọn gì ở bước trước)
            CartDAO cartDAO = new CartDAO();
            cartItems = cartDAO.getCartItemsByUserId(user.getId());
        }

        double total = 0;
        for (Cart item : cartItems) {
            total += item.getPrice() * item.getQuantity();
        }

        Order order = new Order(0, user.getId(), "Pending", total, new Date());
        order.setShippingInfo(shipping);

        orderDAO orderDAO = new orderDAO();
        orderDAO.placeOrder(order, cartItems); // Gửi vào cả giỏ hàng đã chọn

        // ❗ Option: xóa cart
        // new CartDAO().clearCartByUserId(user.getId());

        // ✅ Xóa cartItems khỏi session sau khi đặt hàng
        session.removeAttribute("cartItems");

        // Sau khi orderDAO.placeOrder(...)
request.setAttribute("orderSuccess", true); // Gửi cờ báo thành công
RequestDispatcher dispatcher = request.getRequestDispatcher("checkout.jsp");
dispatcher.forward(request, response);

    }
}

