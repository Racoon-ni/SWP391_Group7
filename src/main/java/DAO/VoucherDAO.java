package DAO;

import model.Voucher;
import java.sql.*;
import java.util.Date;
import config.DBConnect;
import java.util.Date;
import config.DBConnect;
import java.util.ArrayList;
import java.util.List;
import DAO.NotificationDAO; // ✅ Đảm bảo import NotificationDAO

/**
 *
 * @author Long
 */
// Lớp thao tác dữ liệu cho bảng Vouchers
public class VoucherDAO {

    public List<Voucher> getAllVouchers() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM Vouchers";

        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Voucher v = new Voucher();
                v.setVoucherId(rs.getInt("voucher_id"));
                v.setCode(rs.getString("code"));
                v.setDiscountPercent(rs.getInt("discount_percent"));
                v.setMinOrderValue(rs.getDouble("min_order_value"));
                v.setExpiredAt(rs.getDate("expired_at"));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void addVoucherToUser(int userId, int voucherId) {
        String sql = "INSERT INTO UsedVouchers(user_id, voucher_id) "
                + "SELECT ?, ? WHERE NOT EXISTS ("
                + "SELECT 1 FROM UsedVouchers WHERE user_id = ? AND voucher_id = ?)";
        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, voucherId);
            ps.setInt(3, userId);
            ps.setInt(4, voucherId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Voucher> getVouchersByUser(int userId) {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT v.* FROM Vouchers v "
                + "JOIN UsedVouchers uv ON v.voucher_id = uv.voucher_id "
                + "WHERE uv.user_id = ?";

        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Voucher v = new Voucher();
                v.setVoucherId(rs.getInt("voucher_id"));
                v.setCode(rs.getString("code"));
                v.setDiscountPercent(rs.getInt("discount_percent"));
                v.setMinOrderValue(rs.getDouble("min_order_value"));
                v.setExpiredAt(rs.getDate("expired_at"));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean userHasVoucher(int userId, int voucherId) {
        String sql = "SELECT 1 FROM UsedVouchers WHERE user_id = ? AND voucher_id = ?";
        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, voucherId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Thêm thông báo khi có voucher mới
    public void sendNewVoucherNotification(String voucherCode) {
        String title = "Voucher mới";
        String message = "Voucher mới \"" + voucherCode + "\" đã được cập nhật!";
        String link = "/voucher"; // Hoặc link cụ thể nếu có trang voucher

        NotificationDAO notiDAO = new NotificationDAO();

        String sql = "SELECT user_id FROM Users WHERE role = 'Customer'";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int userId = rs.getInt("user_id");
                notiDAO.sendNotification(userId, title, message, link); // ✅ đúng hàm
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
