package controller;

import DAO.CartDAO;
import DAO.UserAddressDAO;
import DAO.orderDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Cart;
import model.Order;
import model.OrderDetail;
import model.ShippingInfo;
import model.User;
import model.UserAddress;

import java.io.IOException;
import java.util.*;

@WebServlet("/place-order")
public class PlaceOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("PlaceOrderServlet is called!");

        HttpSession session = request.getSession(false);
        String ctx = request.getContextPath();

        // 1) Kiểm tra đăng nhập
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(ctx + "/login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");

        // 2) Lấy & kiểm tra addressId
        String addressIdStr = request.getParameter("addressId");
        if (addressIdStr == null || addressIdStr.trim().isEmpty()) {
            response.sendRedirect(ctx + "/ViewAddress?message=Vui%20l%C3%B2ng%20th%C3%AAm%20%C4%91%E1%BB%8Ba%20ch%E1%BB%89%20tr%C6%B0%E1%BB%9Bc%20khi%20%C4%91%E1%BA%B7t%20h%C3%A0ng");
            return;
        }

        int addressId;
        try {
            addressId = Integer.parseInt(addressIdStr);
            System.out.println(">>> addressId (POST): " + addressId);
        } catch (NumberFormatException e) {
            response.sendRedirect(ctx + "/ViewAddress?message=%C4%90%E1%BB%8Ba%20ch%E1%BB%89%20kh%C3%B4ng%20h%E1%BB%A3p%20l%E1%BB%87");
            return;
        }

        // 3) Lấy danh sách địa chỉ của user
        UserAddressDAO addressDAO = new UserAddressDAO();
        List<UserAddress> addresses = addressDAO.getAddressesByUserId(user.getId());
        if (addresses == null || addresses.isEmpty()) {
            response.sendRedirect(ctx + "/ViewAddress?message=Kh%C3%B4ng%20c%C3%B3%20%C4%91%E1%BB%8Ba%20ch%E1%BB%89.%20Vui%20l%C3%B2ng%20th%C3%AAm%20%C4%91%E1%BB%8Ba%20ch%E1%BB%89%20tr%C6%B0%E1%BB%9Bc%20khi%20%C4%91%E1%BA%B7t%20h%C3%A0ng");
            return;
        }

        // 4) Tìm địa chỉ được chọn
        UserAddress selectedAddress = null;
        for (UserAddress addr : addresses) {
            if (addr.getId() == addressId) {
                selectedAddress = addr;
                break;
            }
        }
        if (selectedAddress == null) {
            response.sendRedirect(ctx + "/ViewAddress?message=Kh%C3%B4ng%20t%C3%ACm%20th%E1%BA%A5y%20%C4%91%E1%BB%8Ba%20ch%E1%BB%89%20%C4%91%C3%A3%20ch%E1%BB%8Dn");
            return;
        }

        // 5) Kiểm tra phương thức thanh toán
        String paymentMethod = request.getParameter("paymentMethod");
        if (paymentMethod == null || paymentMethod.isEmpty()) {
            response.sendRedirect(ctx + "/checkout.jsp?error=payment_method_missing");
            return;
        }
        if (!"COD".equalsIgnoreCase(paymentMethod) && !"CARD".equalsIgnoreCase(paymentMethod)) {
            response.sendRedirect(ctx + "/checkout.jsp?error=payment_method_invalid");
            return;
        }

        // 6) Tạo ShippingInfo
        ShippingInfo shipping = new ShippingInfo();
        shipping.setReceiverName(selectedAddress.getFullName());
        shipping.setShippingAddress(selectedAddress.getSpecificAddress());
        shipping.setPhone(selectedAddress.getPhone());
        shipping.setPaymentMethod(paymentMethod.toUpperCase());
        shipping.setPaymentStatus("Pending");

        // 7) Lấy giỏ hàng
        @SuppressWarnings("unchecked")
        List<Cart> cartItems = (List<Cart>) session.getAttribute("cartItems");
        if (cartItems == null || cartItems.isEmpty()) {
            CartDAO cartDAO = new CartDAO();
            cartItems = cartDAO.getCartItemsByUserId(user.getId());
        }
        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect(ctx + "/checkout.jsp?error=empty_cart");
            return;
        }

        // 8) Tính tổng tiền
        double total = 0.0;
        String finalAmountStr = request.getParameter("finalAmount");
        String discountAmountStr = request.getParameter("discountAmount");

        if (finalAmountStr != null && !finalAmountStr.trim().isEmpty()) {
            try { total = Double.parseDouble(finalAmountStr.trim()); } catch (NumberFormatException ignore) {}
        }
        if (total <= 0 && discountAmountStr != null && !discountAmountStr.trim().isEmpty()) {
            try { total = Double.parseDouble(discountAmountStr.trim()); } catch (NumberFormatException ignore) {}
        }
        if (total <= 0) {
            for (Cart item : cartItems) total += item.getPrice() * item.getQuantity();
        }
        if (Double.isNaN(total) || total < 0) {
            response.sendRedirect(ctx + "/checkout.jsp?error=total_invalid");
            return;
        }

        // 9) Tạo đơn hàng & lưu DB (đồng thời trừ tồn kho trong DAO)
        Order order = new Order(0, user.getId(), "Pending", total, new Date());
        order.setShippingInfo(shipping);

        orderDAO orderDAO = new orderDAO();
        boolean isOrderPlaced = orderDAO.placeOrder(order, cartItems);
        if (!isOrderPlaced) {
            // có thể do out_of_stock
            response.sendRedirect(ctx + "/checkout.jsp?error=out_of_stock");
            return;
        }

        // 10) XÓA các mục đã mua khỏi giỏ hàng (DB) + dọn session
        try {
            CartDAO cartDAO = new CartDAO();
            cartDAO.removePurchasedItems(user.getId(), cartItems);
        } catch (Exception e) {
            e.printStackTrace();
        }
        session.removeAttribute("cartItems");

        // 11) Lấy danh sách đơn hàng & chi tiết
        List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
        Map<Integer, List<OrderDetail>> orderDetailsMap = new HashMap<>();
        if (orders != null) {
            for (Order ord : orders) {
                List<OrderDetail> details = orderDAO.getOrderDetails(ord.getOrderId(), user.getId());
                orderDetailsMap.put(ord.getOrderId(), details);
            }
        }

        // 12) Forward sang trang "Đơn hàng của tôi"
        request.setAttribute("orders", orders);
        request.setAttribute("orderDetailsMap", orderDetailsMap);
        request.setAttribute("orderSuccess", true);

        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/include/myOrders.jsp");
        rd.forward(request, response);
    }
}
