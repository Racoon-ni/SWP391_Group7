package DAO;

import model.AdminStaffVoucher;
import config.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminStaffVoucherDAO {

    // Lấy tất cả các voucher với phân trang
    public ArrayList<AdminStaffVoucher> getAllVouchers(int page, int limit) {
        ArrayList<AdminStaffVoucher> vouchers = new ArrayList<>();
        String sql = "SELECT v.voucher_id, v.code, v.discount_percent, v.min_order_value, v.expired_at \n"
                + "FROM Vouchers v\n"
                + "ORDER BY v.voucher_id\n"
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try ( Connection con = DBConnect.connect();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * limit);  // OFFSET (bắt đầu từ đâu)
            ps.setInt(2, limit);  // Số lượng voucher trên mỗi trang

            ResultSet rs = ps.executeQuery();

            // Lấy dữ liệu từ ResultSet và tạo danh sách voucher
            while (rs.next()) {
                AdminStaffVoucher voucher = new AdminStaffVoucher(
                        rs.getInt("voucher_id"),
                        rs.getString("code"),
                        rs.getInt("discount_percent"),
                        rs.getDouble("min_order_value"),
                        rs.getString("expired_at")
                );
                vouchers.add(voucher);  // Thêm voucher vào danh sách
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return vouchers;  // Trả về danh sách voucher
    }

    // Thêm voucher mới
    public boolean addVoucher(AdminStaffVoucher voucher) {
        String sql = "INSERT INTO Vouchers (code, discount_percent, min_order_value, expired_at) VALUES (?, ?, ?, ?)";
        try ( Connection con = DBConnect.connect();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, voucher.getCode());
            ps.setInt(2, voucher.getDiscountPercent());
            ps.setDouble(3, voucher.getMinOrderValue());
            ps.setString(4, voucher.getExpiredAt());
//            ps.setInt(5, voucher.getCreatedBy());  // Người tạo voucher
            return ps.executeUpdate() > 0;  // Kiểm tra xem có thành công không
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật voucher
    public boolean updateVoucher(AdminStaffVoucher voucher) {
        String sql = "UPDATE Vouchers SET code = ?, discount_percent = ?, min_order_value = ?, expired_at = ? WHERE voucher_id = ?";
        try ( Connection con = DBConnect.connect();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, voucher.getCode());
            ps.setInt(2, voucher.getDiscountPercent());
            ps.setDouble(3, voucher.getMinOrderValue());
            ps.setString(4, voucher.getExpiredAt());
//            ps.setInt(5, voucher.getCreatedBy());  // Người tạo voucher
            ps.setInt(5, voucher.getVoucherId());
            return ps.executeUpdate() > 0;  // Kiểm tra xem có thành công không
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa voucher
    public boolean deleteVoucher(int voucherId) {
        String sql = "DELETE FROM Vouchers WHERE voucher_id = ?";
        try ( Connection con = DBConnect.connect();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            return ps.executeUpdate() > 0;  // Kiểm tra xem có thành công không
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy thông tin voucher theo ID
    public AdminStaffVoucher getVoucherById(int voucherId) {
        String sql = "SELECT voucher_id, code, discount_percent, min_order_value, expired_at FROM Vouchers WHERE voucher_id = ?";
        try ( Connection con = DBConnect.connect();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new AdminStaffVoucher(
                        rs.getInt("voucher_id"),
                        rs.getString("code"),
                        rs.getInt("discount_percent"),
                        rs.getDouble("min_order_value"),
                        rs.getString("expired_at")
                );
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

}
