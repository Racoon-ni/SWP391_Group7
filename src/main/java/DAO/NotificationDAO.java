package DAO;

import config.DBConnect;
import model.Notification;

import java.sql.*;
import java.util.*;

public class NotificationDAO {

    // Gửi thông báo cơ bản (không có link)
    public void sendNotification(int userId, String title, String message) {
        sendNotification(userId, title, message, null);
    }

    // Gửi thông báo đầy đủ (có link)
    public void sendNotification(int userId, String title, String message, String link) {
        String sql = "INSERT INTO Notifications (user_id, title, message, link, is_read, created_at) "
                + "VALUES (?, ?, ?, ?, 0, GETDATE())";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, title);
            ps.setString(3, message);
            ps.setString(4, link);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

   // Gửi thông báo cập nhật đơn hàng
public void sendOrderUpdateNotification(int userId, int orderId, String newStatus) {
    String title = "Cập nhật đơn hàng";
    String message = "Đơn hàng #" + orderId + " của bạn đã được cập nhật trạng thái: " + newStatus;
    String link = "/order-details?order_id=" + orderId;

    sendNotification(userId, title, message, link);
}

    // Gửi thông báo sản phẩm mới đến tất cả khách hàng
    public void sendProductUpdateToAllUsers(String productName, String productType, int productId) {
        String sqlGetUsers = "SELECT user_id FROM Users WHERE role = 'Customer'";
        String title = "Sản phẩm mới";
        String message = "Sản phẩm mới '" + productName + "' đã được cập nhật!";
        String link;

        switch (productType.toLowerCase()) {
            case "pc":
                link = "/pcDetail?pcId=" + productId;
                break;
            case "laptop":
                link = "/ViewLaptopDetail?laptopId=" + productId;
                break;
            case "component":
                link = "/ViewComponentDetail?productId=" + productId;
                break;
            default:
                link = "/listPC";
                break;
        }

        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sqlGetUsers);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int userId = rs.getInt("user_id");
                sendNotification(userId, title, message, link);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Gửi thông báo voucher mới đến tất cả khách hàng
    public void sendVoucherUpdateToAllUsers(String voucherCode) {
        String sqlGetUsers = "SELECT user_id FROM Users WHERE role = 'Customer'";
        String title = "Khuyến mãi hot";
        String message = "Voucher mới '" + voucherCode + "' đã được cập nhật!";
        String link = "/voucher";

        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sqlGetUsers);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int userId = rs.getInt("user_id");
                sendNotification(userId, title, message, link);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy danh sách thông báo theo người dùng
    public List<Notification> getByUser(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE user_id = ? ORDER BY created_at DESC";

        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Notification n = new Notification();
                n.setNotificationId(rs.getInt("notification_id"));
                n.setUserId(userId);
                n.setTitle(rs.getString("title"));
                n.setMessage(rs.getString("message"));
                n.setLink(rs.getString("link"));
                n.setRead(rs.getBoolean("is_read"));
                n.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(n);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Đánh dấu một thông báo là đã đọc
    public void markRead(int id) {
        String sql = "UPDATE Notifications SET is_read = 1 WHERE notification_id = ?";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Đánh dấu toàn bộ thông báo của user là đã đọc
    public void markAllRead(int userId) {
        String sql = "UPDATE Notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Đếm số lượng thông báo chưa đọc của user
    public int countUnreadByUser(int userId) {
        String sql = "SELECT COUNT(*) FROM Notifications WHERE user_id = ? AND is_read = 0";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Gửi thủ công một đối tượng Notification
    public void createNotification(Notification noti) {
        String sql = "INSERT INTO Notifications (user_id, title, message, link, is_read, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, noti.getUserId());
            ps.setString(2, noti.getTitle());
            ps.setString(3, noti.getMessage());
            ps.setString(4, noti.getLink());
            ps.setBoolean(5, noti.isRead());
            ps.setTimestamp(6, noti.getCreatedAt());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy một thông báo theo ID
    public Notification getById(int id) {
        String sql = "SELECT * FROM Notifications WHERE notification_id = ?";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Notification n = new Notification();
                n.setNotificationId(rs.getInt("notification_id"));
                n.setUserId(rs.getInt("user_id"));
                n.setTitle(rs.getString("title"));
                n.setMessage(rs.getString("message"));
                n.setLink(rs.getString("link"));
                n.setRead(rs.getBoolean("is_read"));
                n.setCreatedAt(rs.getTimestamp("created_at"));
                return n;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
