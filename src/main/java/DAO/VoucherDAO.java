package DAO;

import model.Voucher;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import config.DBConnect;
import DAO.NotificationDAO;

/**
 *
 * @author Long
 */
// Lớp thao tác dữ liệu cho bảng Vouchers
public class VoucherDAO {

    // ✅ Lấy tất cả voucher còn hạn và còn số lượng
    public List<Voucher> getAllVouchers() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM Vouchers WHERE expired_at > GETDATE() AND quantity > 0";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Voucher v = new Voucher();
                v.setVoucherId(rs.getInt("voucher_id"));
                v.setCode(rs.getString("code"));
                v.setDiscountPercent(rs.getInt("discount_percent"));
                v.setMinOrderValue(rs.getDouble("min_order_value"));
                v.setExpiredAt(rs.getDate("expired_at"));
                v.setQuantity(rs.getInt("quantity"));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Thêm voucher cho user nếu chưa có
    public void addVoucherToUser(int userId, int voucherId) {
        String sql = "INSERT INTO UsedVouchers(user_id, voucher_id) "
                   + "SELECT ?, ? WHERE NOT EXISTS ("
                   + "SELECT 1 FROM UsedVouchers WHERE user_id = ? AND voucher_id = ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, voucherId);
            ps.setInt(3, userId);
            ps.setInt(4, voucherId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ Lấy voucher theo user
    public List<Voucher> getVouchersByUser(int userId) {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT v.* FROM Vouchers v "
                   + "JOIN UsedVouchers uv ON v.voucher_id = uv.voucher_id "
                   + "WHERE uv.user_id = ? AND v.expired_at > GETDATE() AND v.quantity > 0";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Voucher v = new Voucher();
                v.setVoucherId(rs.getInt("voucher_id"));
                v.setCode(rs.getString("code"));
                v.setDiscountPercent(rs.getInt("discount_percent"));
                v.setMinOrderValue(rs.getDouble("min_order_value"));
                v.setExpiredAt(rs.getDate("expired_at"));
                v.setQuantity(rs.getInt("quantity"));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Kiểm tra user đã có voucher chưa
    public boolean userHasVoucher(int userId, int voucherId) {
        String sql = "SELECT 1 FROM UsedVouchers WHERE user_id = ? AND voucher_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, voucherId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Gửi thông báo khi có voucher mới
    public void sendNewVoucherNotification(String voucherCode) {
        String title = "Voucher mới";
        String message = "Voucher mới \"" + voucherCode + "\" đã được cập nhật!";
        String link = "/voucher"; // Link đến trang voucher

        NotificationDAO notiDAO = new NotificationDAO();

        String sql = "SELECT user_id FROM Users WHERE role = 'Customer'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int userId = rs.getInt("user_id");
                notiDAO.sendNotification(userId, title, message, link);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ Lấy voucher theo code
    public Voucher getVoucherByCode(String code) {
        String sql = "SELECT * FROM Vouchers WHERE code = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Voucher v = new Voucher();
                    v.setVoucherId(rs.getInt("voucher_id"));
                    v.setCode(rs.getString("code"));
                    v.setDiscountPercent(rs.getInt("discount_percent"));
                    v.setMinOrderValue(rs.getDouble("min_order_value"));
                    v.setExpiredAt(rs.getDate("expired_at"));
                    v.setQuantity(rs.getInt("quantity"));
                    return v;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("DEBUG getVoucherByCode – không tìm thấy");
        return null;
    }

    // ✅ Giảm số lượng voucher
    public void decreaseVoucherQuantity(int voucherId) {
        String sql = "UPDATE Vouchers SET quantity = quantity - 1 WHERE voucher_id = ? AND quantity > 0";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ Lấy voucher theo ID
    public Voucher getVoucherById(int voucherId) {
        String sql = "SELECT * FROM Vouchers WHERE voucher_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Voucher v = new Voucher();
                    v.setVoucherId(rs.getInt("voucher_id"));
                    v.setCode(rs.getString("code"));
                    v.setDiscountPercent(rs.getInt("discount_percent"));
                    v.setMinOrderValue(rs.getDouble("min_order_value"));
                    v.setExpiredAt(rs.getDate("expired_at"));
                    v.setQuantity(rs.getInt("quantity"));
                    return v;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
