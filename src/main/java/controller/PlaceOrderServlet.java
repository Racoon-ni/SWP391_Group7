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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.OrderDetail;

@WebServlet("/place-order")
public class PlaceOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("PlaceOrderServlet is called!");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // === Lấy addressId từ form ===
        String addressIdStr = request.getParameter("addressId");
        int addressId = 0;
        try {
            addressId = Integer.parseInt(addressIdStr);
            System.out.println(">>> addressId (POST): " + addressId);
        } catch (NumberFormatException e) {
            System.out.println(">>> addressId không hợp lệ: " + addressIdStr);
            response.sendRedirect("checkout.jsp?error=invalid_address");
            return;
        }

        // === Lấy danh sách địa chỉ từ DB ===
        UserAddressDAO addressDAO = new UserAddressDAO();
        List<UserAddress> addresses = addressDAO.getAddressesByUserId(user.getId());

        System.out.println(">>> Danh sách địa chỉ của userId = " + user.getId());
        for (UserAddress addr : addresses) {
            System.out.println(" - ID: " + addr.getId()
                    + ", Họ tên: " + addr.getFullName()
                    + ", SĐT: " + addr.getPhone()
                    + ", Địa chỉ: " + addr.getSpecificAddress());
        }

        // === Tìm địa chỉ được chọn ===
        UserAddress selectedAddress = null;
        for (UserAddress addr : addresses) {
            if (addr.getId() == addressId) {
                selectedAddress = addr;
                break;
            }
        }

        if (selectedAddress == null) {
            System.out.println(">>> Không tìm thấy địa chỉ có ID: " + addressId);
            response.sendRedirect("checkout.jsp?error=address_not_found");
            return;
        } else {
            System.out.println(">>> Địa chỉ được chọn:");
            System.out.println(" - Họ tên: " + selectedAddress.getFullName());
            System.out.println(" - SĐT: " + selectedAddress.getPhone());
            System.out.println(" - Địa chỉ: " + selectedAddress.getSpecificAddress());
        }

        // === Lấy phương thức thanh toán ===
        String paymentMethod = request.getParameter("paymentMethod");
        System.out.println(">>> Phương thức thanh toán: " + paymentMethod);

        if (paymentMethod == null || paymentMethod.isEmpty()) {
            response.sendRedirect("checkout.jsp?error=payment_method_missing");
            return;
        }

        // === Tạo ShippingInfo ===
        ShippingInfo shipping = new ShippingInfo();
        shipping.setReceiverName(selectedAddress.getFullName());
        shipping.setShippingAddress(selectedAddress.getSpecificAddress());
        shipping.setPhone(selectedAddress.getPhone());
        shipping.setPaymentMethod(paymentMethod);
        shipping.setPaymentStatus("Pending");

        // === Lấy giỏ hàng từ session hoặc DB ===
        @SuppressWarnings("unchecked")
        List<Cart> cartItems = (List<Cart>) session.getAttribute("cartItems");
        if (cartItems == null || cartItems.isEmpty()) {
            CartDAO cartDAO = new CartDAO();
            cartItems = cartDAO.getCartItemsByUserId(user.getId());
        }

        if (cartItems == null || cartItems.isEmpty()) {
            System.out.println(">>> Giỏ hàng rỗng!");
            response.sendRedirect("checkout.jsp?error=empty_cart");
            return;
        }

        String disAmount = request.getParameter("discountAmount");
        double total = 0;
        if (disAmount != null && !disAmount.isEmpty()) {
            total = Double.parseDouble(disAmount);
        } else {
            for (Cart item : cartItems) {
                total += item.getPrice() * item.getQuantity();
            }

        }
        // === Tính tổng tiền ===

        System.out.println(">>> Tổng tiền đơn hàng: " + total);

        // === Tạo đơn hàng ===
        Order order = new Order(0, user.getId(), "Pending", total, new Date());
        order.setShippingInfo(shipping);

        // === Gọi DAO để lưu đơn hàng ===
        orderDAO orderDAO = new orderDAO();
        boolean isOrderPlaced = orderDAO.placeOrder(order, cartItems);

        if (!isOrderPlaced) {
            System.out.println(">>> Đặt hàng thất bại!");
            response.sendRedirect("checkout.jsp?error=order_failed");
            return;
        }

        // === Xóa session cart ===
        session.removeAttribute("cartItems");

        // === Lấy danh sách đơn hàng và chi tiết đơn hàng ===
        List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
        Map<Integer, List<OrderDetail>> orderDetailsMap = new HashMap<>();
        for (Order ord : orders) {
            List<OrderDetail> details = orderDAO.getOrderDetails(ord.getOrderId(), user.getId());
            orderDetailsMap.put(ord.getOrderId(), details);
        }

        // === Gửi sang JSP ===
        request.setAttribute("orders", orders);
        request.setAttribute("orderDetailsMap", orderDetailsMap);
        request.setAttribute("orderSuccess", true);

        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/include/myOrders.jsp");
        rd.forward(request, response);
    }
}
