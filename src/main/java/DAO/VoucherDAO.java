/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import model.Voucher;
import java.sql.*;
import java.util.Date;
import config.DBConnect;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */
public class VoucherDAO {
    // Lấy danh sách voucher còn hạn

    public List<Voucher> getAvailableVouchers() throws SQLException {
        List<Voucher> voucherList = new ArrayList<>();
        String sql = "SELECT * FROM Vouchers WHERE expired_at >= GETDATE()";
        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Voucher voucher = new Voucher();
                voucher.setVoucherId(rs.getInt("voucher_id"));
                voucher.setCode(rs.getString("code"));
                voucher.setDiscountPercent(rs.getInt("discount_percent"));
                voucher.setMinOrderValue(rs.getDouble("min_order_value"));
                voucher.setExpiredAt(rs.getDate("expired_at"));
                voucher.setCreatedBy(rs.getInt("created_by"));
                voucherList.add(voucher);
            }
        }
        return voucherList;
    }
    // Kiểm tra voucher có hợp lệ không

    public Voucher getValidVoucher(String code, double orderTotal) throws SQLException {
        String sql = "SELECT * FROM Vouchers WHERE code = ? AND expired_at >= GETDATE() AND min_order_value <= ?";
        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.setDouble(2, orderTotal);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Voucher voucher = new Voucher();
                voucher.setVoucherId(rs.getInt("voucher_id"));
                voucher.setCode(rs.getString("code"));
                voucher.setDiscountPercent(rs.getInt("discount_percent"));
                voucher.setMinOrderValue(rs.getDouble("min_order_value"));
                voucher.setExpiredAt(rs.getDate("expired_at"));
                voucher.setCreatedBy(rs.getInt("created_by"));
                return voucher;
            }
        }
        return null;
    }
}
