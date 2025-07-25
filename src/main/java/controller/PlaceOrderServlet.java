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
        
        // Kiểm tra xem người dùng đã đăng nhập chưa
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Nhận addressId từ form
        String addressIdStr = request.getParameter("addressId");
        int addressId = 0;
        try {
            addressId = Integer.parseInt(addressIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("checkout.jsp?error=invalid_address");
            return;
        }

        // Lấy địa chỉ giao hàng từ DB
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
            response.sendRedirect("checkout.jsp?error=address_not_found");
            return;
        }

        // Lấy hình thức thanh toán
        String paymentMethod = request.getParameter("paymentMethod");
        if (paymentMethod == null || paymentMethod.isEmpty()) {
            response.sendRedirect("checkout.jsp?error=payment_method_missing");
            return;
        }

        // Tạo thông tin giao hàng
        ShippingInfo shipping = new ShippingInfo();
        shipping.setReceiverName(selectedAddress.getFullName());
        shipping.setShippingAddress(selectedAddress.getSpecificAddress());
        shipping.setPhone(selectedAddress.getPhone());
        shipping.setPaymentMethod(paymentMethod);
        shipping.setPaymentStatus("Pending"); // Mặc định trạng thái thanh toán là "Pending"

        // Lấy giỏ hàng từ session
        @SuppressWarnings("unchecked")
        List<Cart> cartItems = (List<Cart>) session.getAttribute("cartItems");
        if (cartItems == null || cartItems.isEmpty()) {
            CartDAO cartDAO = new CartDAO();
            cartItems = cartDAO.getCartItemsByUserId(user.getId());
        }

        // Kiểm tra nếu giỏ hàng rỗng
        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect("checkout.jsp?error=empty_cart");
            return;
        }

        // Tính tổng tiền
        double total = 0;
        for (Cart item : cartItems) {
            total += item.getPrice() * item.getQuantity();
        }

        // Tạo đơn hàng
        Order order = new Order(0, user.getId(), "Pending", total, new Date());
        order.setShippingInfo(shipping);

        // Lưu đơn hàng vào DB
        orderDAO orderDAO = new orderDAO();
        boolean isOrderPlaced = orderDAO.placeOrder(order, cartItems);

        if (!isOrderPlaced) {
            response.sendRedirect("checkout.jsp?error=order_failed");
            return;
        }

        // Xóa giỏ hàng sau khi đặt (nếu muốn)
        // new CartDAO().clearCartByUserId(user.getId());

        // Xóa session cart
        session.removeAttribute("cartItems");

        // Sau khi đơn hàng đã được đặt, lấy danh sách đơn hàng và gửi sang frontend (myOrders.jsp)
        orderDAO dao = new orderDAO();
        List<Order> orders = dao.getOrdersByUserId(user.getId());

        // --- Lấy chi tiết đơn hàng (OrderDetails) ---
        Map<Integer, List<OrderDetail>> orderDetailsMap = new HashMap<>();
        for (Order ord : orders) {
            List<OrderDetail> details = dao.getOrderDetails(ord.getOrderId(), user.getId());
            orderDetailsMap.put(ord.getOrderId(), details);
        }

        // Gửi thông tin đơn hàng và chi tiết đơn hàng đến trang frontend (myOrders.jsp)
        request.setAttribute("orders", orders);
        request.setAttribute("orderDetailsMap", orderDetailsMap);

        // Chuyển hướng đến trang hiển thị đơn hàng
        request.setAttribute("orderSuccess", true);
        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/include/myOrders.jsp");
        rd.forward(request, response);
    }
}
