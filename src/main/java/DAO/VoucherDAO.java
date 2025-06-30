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
 * @author Long
 */
// Lớp thao tác dữ liệu cho bảng Vouchers
public class VoucherDAO {
    public List<Voucher> getAllVouchers() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM Vouchers";

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
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void addVoucherToUser(int userId, int voucherId) {
        String sql = "INSERT INTO UsedVouchers(user_id, voucher_id) SELECT ?, ? WHERE NOT EXISTS (SELECT 1 FROM UsedVouchers WHERE user_id = ? AND voucher_id = ?)";
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

    public List<Voucher> getVouchersByUser(int userId) {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT v.* FROM Vouchers v JOIN UsedVouchers uv ON v.voucher_id = uv.voucher_id WHERE uv.user_id = ?";

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
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

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
}