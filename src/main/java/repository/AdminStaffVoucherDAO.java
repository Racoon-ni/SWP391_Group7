//package repository;
//
//import model.AdminStaffVoucher;
//import config.DBConnect;
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class AdminStaffVoucherDAO {
//
//    // Lấy tất cả các voucher (với phân trang)
//    public List<AdminStaffVoucher> getAllVouchers(int page, int limit) {
//        List<AdminStaffVoucher> vouchers = new ArrayList<>();
//        String sql = "SELECT * FROM Vouchers ORDER BY voucher_id LIMIT ? OFFSET ?";
//
//        try (Connection con = DBConnect.connect(); PreparedStatement ps = con.prepareStatement(sql)) {
//            ps.setInt(1, limit);  // Giới hạn số lượng voucher mỗi lần truy vấn
//            ps.setInt(2, (page - 1) * limit);  // Offset để phân trang
//            ResultSet rs = ps.executeQuery();
//
//            while (rs.next()) {
//                AdminStaffVoucher voucher = new AdminStaffVoucher(
//                        rs.getInt("voucher_id"),
//                        rs.getString("code"),
//                        rs.getInt("discount_percent"),
//                        rs.getDouble("min_order_value"),
//                        rs.getString("expired_at"),
//                        rs.getInt("created_by")
//                );
//                vouchers.add(voucher);  // Thêm voucher vào danh sách
//            }
//        } catch (SQLException | ClassNotFoundException e) {
//            e.printStackTrace();
//        }
//
//        return vouchers;  // Trả về danh sách voucher
//    }
//
//    // Thêm voucher mới
//    public boolean addVoucher(AdminStaffVoucher voucher) {
//        String sql = "INSERT INTO Vouchers (code, discount_percent, min_order_value, expired_at, created_by) VALUES (?, ?, ?, ?, ?)";
//        try (Connection con = DBConnect.connect(); PreparedStatement ps = con.prepareStatement(sql)) {
//            ps.setString(1, voucher.getCode());
//            ps.setInt(2, voucher.getDiscountPercent());
//            ps.setDouble(3, voucher.getMinOrderValue());
//            ps.setString(4, voucher.getExpiredAt());
//            ps.setInt(5, voucher.getCreatedBy());  // Người tạo voucher
//            return ps.executeUpdate() > 0;  // Kiểm tra xem có thành công không
//        } catch (SQLException | ClassNotFoundException e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//
//    // Cập nhật voucher
//    public boolean updateVoucher(AdminStaffVoucher voucher) {
//        String sql = "UPDATE Vouchers SET code = ?, discount_percent = ?, min_order_value = ?, expired_at = ?, created_by = ? WHERE voucher_id = ?";
//        try (Connection con = DBConnect.connect(); PreparedStatement ps = con.prepareStatement(sql)) {
//            ps.setString(1, voucher.getCode());
//            ps.setInt(2, voucher.getDiscountPercent());
//            ps.setDouble(3, voucher.getMinOrderValue());
//            ps.setString(4, voucher.getExpiredAt());
//            ps.setInt(5, voucher.getCreatedBy());  // Người tạo voucher
//            ps.setInt(6, voucher.getVoucherId());
//            return ps.executeUpdate() > 0;  // Kiểm tra xem có thành công không
//        } catch (SQLException | ClassNotFoundException e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//
//    // Xóa voucher
//    public boolean deleteVoucher(int voucherId) {
//        String sql = "DELETE FROM Vouchers WHERE voucher_id = ?";
//        try (Connection con = DBConnect.connect(); PreparedStatement ps = con.prepareStatement(sql)) {
//            ps.setInt(1, voucherId);
//            return ps.executeUpdate() > 0;  // Kiểm tra xem có thành công không
//        } catch (SQLException | ClassNotFoundException e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//}
