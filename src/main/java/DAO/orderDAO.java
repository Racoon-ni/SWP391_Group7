package DAO;

import DAO.NotificationDAO;
import model.Notification;
import config.DBConnect;
import model.OrderDetail;
import model.Order;
import model.ShippingInfo;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Cart;

public class orderDAO {
//orderDAO

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

    // Lấy chi tiết sản phẩm của 1 đơn hàng và kiểm tra đã đánh giá hay chưa cho từng sản phẩm
    public List<OrderDetail> getOrderDetails(int orderId, int userId) {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT oi.order_item_id, oi.order_id, oi.product_id, "
                + "p.name AS product_name, p.image_url, oi.quantity, oi.unit_price "
                + "FROM OrderItems oi "
                + "JOIN Products p ON oi.product_id = p.product_id "
                + "WHERE oi.order_id = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            RatingDAO ratingDAO = new RatingDAO(); // Thêm dòng này vào đầu
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
                // Đúng logic: check theo userId, orderId, productId
                detail.setRated(ratingDAO.hasUserRatedInOrder(userId, orderId, detail.getProductId()));
                details.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details;
    }

    // Lấy chi tiết sản phẩm của 1 đơn hàng (không kiểm tra rated - phục vụ lấy danh sách đánh giá nhiều sản phẩm cùng lúc)
    public List<OrderDetail> getOrderDetailsNoUser(int orderId) {
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

    // Kiểm tra user đã đánh giá sản phẩm này chưa
    private boolean checkUserRatedProduct(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM Ratings WHERE user_id = ? AND product_id = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
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

    public int reorder(int oldOrderId, String phone, String address, String paymentMethod, String[] productIds, String[] quantities, int userId, ShippingInfo oldShippingInfo, String newReceiverName) {
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

            // 3. Ghi thông tin giao hàng cho đơn hàng mới
            String insertShipping = "INSERT INTO OrderShippingPayment (order_id, shipping_address, receiver_name, phone, payment_method, payment_status) "
                    + "VALUES (?, ?, ?, ?, ?, 'Unpaid')";
            psShipping = conn.prepareStatement(insertShipping);
            psShipping.setInt(1, newOrderId);
            psShipping.setString(2, address);
            psShipping.setString(3, newReceiverName != null ? newReceiverName : oldShippingInfo.getReceiverName()); // Cập nhật tên người nhận
            psShipping.setString(4, phone);
            psShipping.setString(5, paymentMethod);
            psShipping.executeUpdate();

            // 4. Ghi các sản phẩm vào đơn hàng mới
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
            try {
                if (psOrder != null) {
                    psOrder.close();
                }
            } catch (Exception e) {
            }
            try {
                if (psShipping != null) {
                    psShipping.close();
                }
            } catch (Exception e) {
            }
            try {
                if (psItemInsert != null) {
                    psItemInsert.close();
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
        return -1;
    }

    private double getProductPrice(int productId) {
        String sql = "SELECT price FROM Products WHERE product_id = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
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

    public boolean updateOrderStatus(int orderId, String newStatus) {
        String getOrderInfoSQL = "SELECT user_id, status, payment_method "
                + "FROM Orders o "
                + "JOIN OrderShippingPayment os ON os.order_id = o.order_id "
                + "WHERE o.order_id = ?";
        String updateStatusSQL = "UPDATE Orders SET status = ? WHERE order_id = ?";
        String getOrderDetailsSQL = "SELECT product_id, quantity FROM [OrderItems] WHERE order_id = ?";
        String reduceStockSQL = "UPDATE Products SET stock = stock - ? WHERE product_id = ?";
        String increaseStockSQL = "UPDATE Products SET stock = stock + ? WHERE product_id = ?";

        try ( Connection conn = DBConnect.connect();  PreparedStatement psGetOrderInfo = conn.prepareStatement(getOrderInfoSQL)) {

            conn.setAutoCommit(false); // bắt đầu transaction

            psGetOrderInfo.setInt(1, orderId);
            try ( ResultSet rs = psGetOrderInfo.executeQuery()) {
                if (!rs.next()) {
                    return false; // Đơn hàng không tồn tại
                }

                int userId = rs.getInt("user_id");
                String currentStatus = rs.getString("status").trim();
                String paymentMethod = rs.getString("payment_method").trim();

                // Kiểm tra luồng trạng thái hợp lệ
                if (!canTransition(currentStatus, newStatus)) {
                    conn.rollback();
                    return false; // Không được phép cập nhật
                }

                // 1. Cập nhật trạng thái đơn
                try ( PreparedStatement psUpdateStatus = conn.prepareStatement(updateStatusSQL)) {
                    psUpdateStatus.setString(1, newStatus);
                    psUpdateStatus.setInt(2, orderId);
                    if (psUpdateStatus.executeUpdate() == 0) {
                        conn.rollback();
                        return false; // Cập nhật thất bại
                    }
                }

                // 2. Xử lý tồn kho khi Hoàn thành hoặc Đã huỷ
                if ("Completed".equalsIgnoreCase(newStatus) || "Cancelled".equalsIgnoreCase(newStatus)) {
                    try ( PreparedStatement psGetDetails = conn.prepareStatement(getOrderDetailsSQL)) {
                        psGetDetails.setInt(1, orderId);
                        try ( ResultSet rsDetails = psGetDetails.executeQuery()) {
                            while (rsDetails.next()) {
                                int productId = rsDetails.getInt("product_id");
                                int quantity = rsDetails.getInt("quantity");

                                String stockSQL = "Completed".equalsIgnoreCase(newStatus) ? reduceStockSQL : increaseStockSQL;
                                try ( PreparedStatement psStockUpdate = conn.prepareStatement(stockSQL)) {
                                    psStockUpdate.setInt(1, quantity);
                                    psStockUpdate.setInt(2, productId);
                                    psStockUpdate.executeUpdate();
                                }
                            }
                        }
                    }
                }

                // 3. Cập nhật trạng thái thanh toán nếu COD
                if (("Shipped".equalsIgnoreCase(newStatus) || "Completed".equalsIgnoreCase(newStatus))
                        && "COD".equalsIgnoreCase(paymentMethod)) {

                    String sqlUpdatePayment = "UPDATE OrderShippingPayment SET payment_status = 'Paid'"
                            + ("Shipped".equalsIgnoreCase(newStatus) ? ", shippedDate = GETDATE()" : "")
                            + " WHERE order_id = ?";

                    try ( PreparedStatement psUpdatePayment = conn.prepareStatement(sqlUpdatePayment)) {
                        psUpdatePayment.setInt(1, orderId);
                        psUpdatePayment.executeUpdate();
                    }
                }

                // 4. Gửi thông báo bằng tiếng Việt
                NotificationDAO dao = new NotificationDAO();
                dao.sendNotification(
                        userId,
                        "Cập nhật đơn hàng",
                        "Đơn hàng #" + orderId + " của bạn đã được cập nhật trạng thái: " + newStatus,
                        "/order-details?order_id=" + orderId
                );

                conn.commit(); // xác nhận transaction
                return true;
            }

        } catch (Exception e) {
            Logger.getLogger(orderDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        }
    }

// Hàm kiểm tra luồng trạng thái hợp lệ
    private boolean canTransition(String currentStatus, String newStatus) {
        currentStatus = currentStatus.trim();
        newStatus = newStatus.trim();

        // Trạng thái cuối không thể đổi
        if ("Completed".equalsIgnoreCase(currentStatus)
                || "Cancelled".equalsIgnoreCase(currentStatus)
                || "Canceled".equalsIgnoreCase(currentStatus)
                || "Đã hủy".equalsIgnoreCase(currentStatus)) {
            return false;
        }

        switch (currentStatus) {
            case "Pending": // Chờ xử lý
                return "Processing".equalsIgnoreCase(newStatus)
                        || "Cancelled".equalsIgnoreCase(newStatus);
            case "Processing": // Đang xử lý
                return "Completed".equalsIgnoreCase(newStatus)
                        || "Cancelled".equalsIgnoreCase(newStatus);
            default:
                return false;
        }
    }

//    public void placeOrder(Order order, List<Cart> cartItems) {
//    String insertOrder = "INSERT INTO Orders (user_id, status, total_price, created_at) VALUES (?, ?, ?, ?)";
//    String insertShipping = "INSERT INTO OrderShippingPayment (order_id, shipping_address, receiver_name, phone, payment_method, payment_status) VALUES (?, ?, ?, ?, ?, ?)";
//    String insertItems = "INSERT INTO OrderItems (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
//
//    try (Connection conn = DBConnect.connect()) {
//        conn.setAutoCommit(false);
//
//        try (PreparedStatement ps = conn.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS)) {
//            ps.setInt(1, order.getUserId());
//            ps.setString(2, order.getStatus());
//            ps.setDouble(3, order.getTotalPrice());
//            ps.setTimestamp(4, new Timestamp(order.getCreatedAt().getTime()));
//            ps.executeUpdate();
//
//            ResultSet rs = ps.getGeneratedKeys();
//            if (rs.next()) {
//                int orderId = rs.getInt(1);
//
//                // Insert shipping info
//                ShippingInfo ship = order.getShippingInfo();
//                try (PreparedStatement ps2 = conn.prepareStatement(insertShipping)) {
//                    ps2.setInt(1, orderId);
//                    ps2.setString(2, ship.getShippingAddress());
//                    ps2.setString(3, ship.getReceiverName());
//                    ps2.setString(4, ship.getPhone());
//                    ps2.setString(5, ship.getPaymentMethod());
//                    ps2.setString(6, ship.getPaymentStatus());
//                    ps2.executeUpdate();
//                }
//
//                // Insert order items
//                try (PreparedStatement ps3 = conn.prepareStatement(insertItems)) {
//                    for (Cart item : cartItems) {
//                        ps3.setInt(1, orderId);
//                        ps3.setInt(2, item.getProductId());
//                        ps3.setInt(3, item.getQuantity());
//                        ps3.setDouble(4, item.getPrice());
//                        ps3.addBatch();
//                    }
//                    ps3.executeBatch();
//                }
//            }
//
//            conn.commit();
//        } catch (Exception e) {
//            conn.rollback();
//            throw e;
//        }
//
//    } catch (Exception e) {
//        e.printStackTrace();
//    }
//}
//     public void placeOrder(Order order, List<Cart> cartItems) {
//        String insertOrderSQL = "INSERT INTO Orders (user_id, status, total_price, created_at) VALUES (?, ?, ?, ?)";
//        String insertShippingSQL = "INSERT INTO OrderShippingPayment (order_id, shipping_address, receiver_name, phone, payment_method, payment_status) VALUES (?, ?, ?, ?, ?, ?)";
//        String insertItemsSQL = "INSERT INTO OrderItems (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
//
//        try (Connection conn = DBConnect.connect()) {
//            conn.setAutoCommit(false); // Bắt đầu transaction
//
//            // Insert vào bảng Orders
//            try (PreparedStatement ps = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS)) {
//                ps.setInt(1, order.getUserId());
//                ps.setString(2, order.getStatus());
//                ps.setDouble(3, order.getTotalPrice());
//                ps.setTimestamp(4, new Timestamp(order.getCreatedAt().getTime()));
//                ps.executeUpdate();
//
//                ResultSet rs = ps.getGeneratedKeys();
//                if (rs.next()) {
//                    int orderId = rs.getInt(1);
//
//                    // Insert thông tin giao hàng
//                    ShippingInfo shipping = order.getShippingInfo();
//                    try (PreparedStatement ps2 = conn.prepareStatement(insertShippingSQL)) {
//                        ps2.setInt(1, orderId);
//                        ps2.setString(2, shipping.getShippingAddress());
//                        ps2.setString(3, shipping.getReceiverName());
//                        ps2.setString(4, shipping.getPhone());
//                        ps2.setString(5, shipping.getPaymentMethod());
//                        ps2.setString(6, shipping.getPaymentStatus());
//                        ps2.executeUpdate();
//                    }
//
//                    // Insert các sản phẩm vào bảng OrderItems
//                    try (PreparedStatement ps3 = conn.prepareStatement(insertItemsSQL)) {
//                        for (Cart item : cartItems) {
//                            ps3.setInt(1, orderId);
//                            ps3.setInt(2, item.getProductId());
//                            ps3.setInt(3, item.getQuantity());
//                            ps3.setDouble(4, item.getPrice());
//                            ps3.addBatch();
//                        }
//                        ps3.executeBatch();
//                    }
//                }
//
//                conn.commit(); // Commit transaction
//            } catch (Exception e) {
//                conn.rollback(); // Rollback nếu có lỗi
//                throw e;
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
    // In orderDAO.java
// Trong orderDAO.java
    public boolean placeOrder(Order order, List<Cart> cartItems) {
        String insertOrderSQL = "INSERT INTO Orders (user_id, status, total_price, created_at) VALUES (?, ?, ?, ?)";
        String insertShippingSQL = "INSERT INTO OrderShippingPayment "
                + "(order_id, shipping_address, receiver_name, phone, payment_method, payment_status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        String insertItemsSQL = "INSERT INTO OrderItems (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";

        try ( Connection conn = DBConnect.connect()) {
            conn.setAutoCommit(false); // Bắt đầu transaction

            int orderId;

            // 1. Insert vào bảng Orders
            try ( PreparedStatement psOrder = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, order.getUserId());
                psOrder.setString(2, order.getStatus());
                psOrder.setDouble(3, order.getTotalPrice());
                psOrder.setTimestamp(4, new Timestamp(order.getCreatedAt().getTime()));
                psOrder.executeUpdate();

                try ( ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                        order.setOrderId(orderId);
                    } else {
                        conn.rollback();
                        return false; // Không lấy được order_id
                    }
                }
            }

            // 2. Insert vào OrderShippingPayment
            ShippingInfo ship = order.getShippingInfo();
            String orderStatus = order.getStatus();
            String paymentStatus;

            // ✅ Java 8-compatible switch
            switch (orderStatus) {
                case "Paid":
                    paymentStatus = "Paid";
                    break;
                case "Canceled":
                case "Failed":
                    paymentStatus = "Failed";
                    break;
                default:
                    paymentStatus = "Unpaid";
                    break;
            }

            try ( PreparedStatement psShipping = conn.prepareStatement(insertShippingSQL)) {
                psShipping.setInt(1, order.getOrderId());
                psShipping.setString(2, ship.getShippingAddress().trim());
                psShipping.setString(3, ship.getReceiverName());
                psShipping.setString(4, ship.getPhone());
                psShipping.setString(5, ship.getPaymentMethod());
                psShipping.setString(6, paymentStatus);
                psShipping.executeUpdate();
            }

            // 3. Insert vào OrderItems
            try ( PreparedStatement psItems = conn.prepareStatement(insertItemsSQL)) {
                for (Cart item : cartItems) {
                    psItems.setInt(1, order.getOrderId());
                    psItems.setInt(2, item.getProductId());
                    psItems.setInt(3, item.getQuantity());
                    psItems.setDouble(4, item.getPrice());
                    psItems.addBatch();
                }
                psItems.executeBatch();
            }

            // 4. Commit tất cả
            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<OrderDetail> getOrderDetailsByUserId(int userId) {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT oi.order_item_id, oi.order_id, oi.product_id,\n"
                + "p.name AS product_name, p.image_url, oi.quantity, oi.unit_price \n"
                + "FROM OrderItems oi \n"
                + "JOIN Products p ON oi.product_id = p.product_id\n"
                + "Join Orders o ON o.order_id = oi.order_id\n"
                + "WHERE o.user_id = ?";

        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, userId);
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
}
