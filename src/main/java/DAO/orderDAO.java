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
                        rs.getDouble("discount_amount"),
                        rs.getDouble("final_price"),
                        rs.getInt("voucher_id"),
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
                        rs.getDouble("discount_amount"),
                        rs.getDouble("final_price"),
                        rs.getInt("voucher_id"),
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
        String sqlCheck = "SELECT status FROM Orders WHERE order_id = ? AND user_id = ?";
        String sqlCancelOrder = "UPDATE Orders SET status = 'Canceled' WHERE order_id = ?";
        String sqlCancelPayment = "UPDATE OrderShippingPayment SET payment_status = 'Failed' WHERE order_id = ?";
        String sqlUpdateStock = "UPDATE Products SET stock = stock + ? WHERE product_id = ?";

        try ( Connection conn = DBConnect.connect()) {
            conn.setAutoCommit(false); // Transaction

            // 1. Kiểm tra đơn
            String status;
            try ( PreparedStatement psCheck = conn.prepareStatement(sqlCheck)) {
                psCheck.setInt(1, orderId);
                psCheck.setInt(2, userId);
                try ( ResultSet rs = psCheck.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false; // Không tồn tại đơn
                    }
                    status = rs.getString("status");
                }
            }

            if (!"Pending".equalsIgnoreCase(status)) {
                conn.rollback();
                return false; // Chỉ hủy Pending
            }

            // 2. Lấy chi tiết đơn
            List<OrderDetail> details = getOrderDetailsNoUser(orderId); // lấy quantity
            try ( PreparedStatement psStock = conn.prepareStatement(sqlUpdateStock)) {
                for (OrderDetail d : details) {
                    psStock.setInt(1, d.getQuantity());
                    psStock.setInt(2, d.getProductId());
                    psStock.addBatch();
                }
                psStock.executeBatch(); // Cộng lại tồn kho
            }

            // 3. Hủy đơn
            try ( PreparedStatement psOrder = conn.prepareStatement(sqlCancelOrder);  PreparedStatement psPayment = conn.prepareStatement(sqlCancelPayment)) {
                psOrder.setInt(1, orderId);
                psOrder.executeUpdate();

                psPayment.setInt(1, orderId);
                psPayment.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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
    // Lấy danh sách sản phẩm từ 1 đơn hàng cũ nhưng cập nhật giá mới nhất từ bảng Products

    public List<OrderDetail> getOrderDetailsWithUpdatedPrice(int orderId) {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT oi.order_item_id, oi.order_id, oi.product_id, "
                + "p.name AS product_name, p.image_url, oi.quantity, p.price AS unit_price "
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
                        rs.getDouble("unit_price") // lấy giá mới từ Products
                );
                details.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details;
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

// Trong orderDAO.java
    public boolean placeOrder(Order order, List<Cart> cartItems) {
        String insertOrderSQL = "INSERT INTO Orders (user_id, status, total_price, discount_amount, final_price, voucher_id, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String insertShippingSQL
                = "INSERT INTO OrderShippingPayment (order_id, shipping_address, receiver_name, phone, payment_method, payment_status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        String insertItemsSQL = "INSERT INTO OrderItems (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
        String decStockSQL = "UPDATE Products SET stock = stock - ? WHERE product_id = ? AND stock >= ?";

        try ( Connection conn = DBConnect.connect()) {
            conn.setAutoCommit(false);
            int orderId;

            // 1) Orders
            try ( PreparedStatement psOrder = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, order.getUserId());
                psOrder.setString(2, order.getStatus());
                psOrder.setDouble(3, order.getTotalPrice());
                psOrder.setDouble(4, order.getDiscountAmount());
                psOrder.setDouble(5, order.getFinalPrice());
                if (order.getVoucherId() != null) {
                    psOrder.setInt(6, order.getVoucherId());
                } else {
                    psOrder.setNull(6, java.sql.Types.INTEGER);
                }
                psOrder.setTimestamp(7, new Timestamp(order.getCreatedAt().getTime()));
                psOrder.executeUpdate();

                try ( ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                        order.setOrderId(orderId);
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            }

            // 2) Shipping
            ShippingInfo ship = order.getShippingInfo();
            String paymentStatus;
            switch (order.getStatus()) {
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

            // 3) Trừ stock + ghi items
            try ( PreparedStatement psDecStock = conn.prepareStatement(decStockSQL);  PreparedStatement psItems = conn.prepareStatement(insertItemsSQL)) {

                for (Cart item : cartItems) {
                    int productId = item.getProductId();
                    int qty = item.getQuantity();

                    psDecStock.setInt(1, qty);
                    psDecStock.setInt(2, productId);
                    psDecStock.setInt(3, qty);
                    int affected = psDecStock.executeUpdate();
                    if (affected == 0) {
                        conn.rollback();
                        return false;
                    }

                    psItems.setInt(1, order.getOrderId());
                    psItems.setInt(2, productId);
                    psItems.setInt(3, qty);
                    psItems.setDouble(4, item.getPrice());
                    psItems.addBatch();
                }
                psItems.executeBatch();
            }

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
