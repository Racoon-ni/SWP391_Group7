package DAO;

import config.DBConnect;
import model.OrderDetail;
import model.Order;
import model.ShippingInfo;
import java.sql.*;
import java.util.*;

public class orderDAO {

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE user_id = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = new Order(
                        rs.getInt("order_id"),
                        rs.getInt("user_id"),
                        rs.getString("status"),
                        rs.getDouble("total_price"),
                        rs.getTimestamp("created_at")
                );
                // Gán shippingInfo cho order
                ShippingInfo shippingInfo = getShippingInfoByOrderId(order.getOrderId());
                order.setShippingInfo(shippingInfo);
                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT oi.order_item_id, oi.order_id, oi.product_id, "
                + "p.name AS product_name, p.image_url, oi.quantity, oi.unit_price "
                + "FROM OrderItems oi "
                + "JOIN Products p ON oi.product_id = p.product_id "
                + "WHERE oi.order_id = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderDetail detail = new OrderDetail(
                        rs.getInt("order_item_id"),
                        rs.getInt("order_id"),
                        rs.getInt("product_id"),
                        rs.getString("product_name"),
                        rs.getString("image_url"),
                        rs.getInt("quantity"),
                        rs.getDouble("unit_price")
                );
                details.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details;
    }

    public Order getOrderById(int orderId) {
        Order order = null;
        String sql = "SELECT * FROM Orders WHERE order_id = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                order = new Order(
                        rs.getInt("order_id"),
                        rs.getInt("user_id"),
                        rs.getString("status"),
                        rs.getDouble("total_price"),
                        rs.getTimestamp("created_at")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return order;
    }

    public ShippingInfo getShippingInfoByOrderId(int orderId) {
        ShippingInfo info = null;
        String sql = "SELECT * FROM OrderShippingPayment WHERE order_id = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                info = new ShippingInfo(
                        rs.getString("receiver_name"),
                        rs.getString("phone"),
                        rs.getString("shipping_address"),
                        rs.getString("payment_method"),
                        rs.getString("payment_status")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return info;
    }

    public boolean cancelPendingOrder(int orderId, int userId) {
        String sql1 = "UPDATE Orders SET status = 'Canceled' WHERE order_id = ? AND user_id = ? AND status = 'Pending'";
        String sql2 = "UPDATE OrderShippingPayment SET payment_status = 'Failed' WHERE order_id = ?";
        Connection conn = null;
        PreparedStatement ps1 = null, ps2 = null;
        try {
            conn = DBConnect.connect();
            ps1 = conn.prepareStatement(sql1);
            ps1.setInt(1, orderId);
            ps1.setInt(2, userId);
            int updated1 = ps1.executeUpdate();

            ps2 = conn.prepareStatement(sql2);
            ps2.setInt(1, orderId);
            ps2.executeUpdate();

            return updated1 > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps1 != null) {
                    ps1.close();
                }
            } catch (Exception e) {
            }
            try {
                if (ps2 != null) {
                    ps2.close();
                }
            } catch (Exception e) {
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
            }
        }
        return false;
    }

    public int reorder(int oldOrderId, String phone, String address, String paymentMethod, String[] productIds, String[] quantities, int userId) {
    Connection conn = null;
    PreparedStatement psOrder = null, psShipping = null, psItemInsert = null;
    ResultSet rs = null;
    int newOrderId = -1;
    double totalPrice = 0;

    try {
        conn = DBConnect.connect();

        // 1. Tính tổng giá trị đơn hàng
        for (int i = 0; i < productIds.length; i++) {
            int productId = Integer.parseInt(productIds[i]);
            int quantity = Integer.parseInt(quantities[i]);
            double unitPrice = getProductPrice(productId);
            totalPrice += unitPrice * quantity;
        }

        // 2. Tạo đơn hàng mới
        String createOrder = "INSERT INTO Orders (user_id, status, total_price) VALUES (?, 'Pending', ?)";
        psOrder = conn.prepareStatement(createOrder, Statement.RETURN_GENERATED_KEYS);
        psOrder.setInt(1, userId);
        psOrder.setDouble(2, totalPrice);
        psOrder.executeUpdate();

        rs = psOrder.getGeneratedKeys();
        if (rs.next()) {
            newOrderId = rs.getInt(1);
        } else {
            return -1; // Không tạo được đơn hàng
        }

        // 3. Ghi thông tin giao hàng
        String insertShipping = "INSERT INTO OrderShippingPayment (order_id, shipping_address, receiver_name, phone, payment_method, payment_status) "
                + "VALUES (?, ?, ?, ?, ?, 'Unpaid')";
        psShipping = conn.prepareStatement(insertShipping);
        psShipping.setInt(1, newOrderId);
        psShipping.setString(2, address);
        psShipping.setString(3, "Receiver"); // Tùy chỉnh tên người nhận nếu cần
        psShipping.setString(4, phone);
        psShipping.setString(5, paymentMethod);
        psShipping.executeUpdate();

        // 4. Ghi các sản phẩm
        String insertItems = "INSERT INTO OrderItems (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
        psItemInsert = conn.prepareStatement(insertItems);
        for (int i = 0; i < productIds.length; i++) {
            int productId = Integer.parseInt(productIds[i]);
            int quantity = Integer.parseInt(quantities[i]);
            double unitPrice = getProductPrice(productId);

            psItemInsert.setInt(1, newOrderId);
            psItemInsert.setInt(2, productId);
            psItemInsert.setInt(3, quantity);
            psItemInsert.setDouble(4, unitPrice);
            psItemInsert.executeUpdate();
        }

        return newOrderId;
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (psOrder != null) psOrder.close(); } catch (Exception e) {}
        try { if (psShipping != null) psShipping.close(); } catch (Exception e) {}
        try { if (psItemInsert != null) psItemInsert.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
    return -1;
}


    private double getProductPrice(int productId) {
    String sql = "SELECT price FROM Products WHERE product_id = ?";
    try (PreparedStatement ps = DBConnect.prepareStatement(sql)) {
        ps.setInt(1, productId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getDouble("price");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0.0; // fallback
}


}
