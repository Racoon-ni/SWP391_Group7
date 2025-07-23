package controller;

import DAO.CartDAO;
import DAO.UserAddressDAO;
import DAO.orderDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Cart;
import model.Order;
import model.ShippingInfo;
import model.User;
import model.UserAddress;

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

        // ✅ Nhận addressId từ form
        String addressIdStr = request.getParameter("addressId");
        int addressId = 0;
        try {
            addressId = Integer.parseInt(addressIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("checkout.jsp");
            return;
        }

        // ✅ Lấy địa chỉ giao hàng từ DB
        UserAddressDAO addressDAO = new UserAddressDAO();
        List<UserAddress> addresses = addressDAO.getAddressesByUserId(user.getId());
        UserAddress selectedAddress = null;
        for (UserAddress addr : addresses) {
            if (addr.getId() == addressId) {
                selectedAddress = addr;
                break;
            }
        }

        if (selectedAddress == null) {
            response.sendRedirect("checkout.jsp");
            return;
        }

        // ✅ Lấy hình thức thanh toán
        String paymentMethod = request.getParameter("paymentMethod");

        // ✅ Tạo thông tin giao hàng
        ShippingInfo shipping = new ShippingInfo();
        shipping.setReceiverName(selectedAddress.getFullName());
        shipping.setShippingAddress(selectedAddress.getSpecificAddress());
        shipping.setPhone(selectedAddress.getPhone());
        shipping.setPaymentMethod(paymentMethod);
        shipping.setPaymentStatus("Pending");

        // ✅ Lấy giỏ hàng từ session
        @SuppressWarnings("unchecked")
        List<Cart> cartItems = (List<Cart>) session.getAttribute("cartItems");
        if (cartItems == null || cartItems.isEmpty()) {
            CartDAO cartDAO = new CartDAO();
            cartItems = cartDAO.getCartItemsByUserId(user.getId());
        }

        // ✅ Tính tổng tiền
        double total = 0;
        for (Cart item : cartItems) {
            total += item.getPrice() * item.getQuantity();
        }

        // ✅ Tạo đơn hàng
        Order order = new Order(0, user.getId(), "Pending", total, new Date());
        order.setShippingInfo(shipping);

        // ✅ Lưu đơn hàng vào DB
        orderDAO orderDAO = new orderDAO();
        orderDAO.placeOrder(order, cartItems);

        // ✅ Xóa giỏ hàng sau khi đặt (nếu muốn)
        // new CartDAO().clearCartByUserId(user.getId());

        // ✅ Xóa session cart
        session.removeAttribute("cartItems");

        // ✅ Hiển thị thông báo đặt hàng thành công
        request.setAttribute("orderSuccess", true);
        RequestDispatcher dispatcher = request.getRequestDispatcher("checkout.jsp");
        dispatcher.forward(request, response);
    }
}