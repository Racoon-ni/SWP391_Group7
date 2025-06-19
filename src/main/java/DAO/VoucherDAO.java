package dao;

import config.DBConnect;
import model.Voucher;
import java.sql.*;
import java.util.ArrayList;

public class VoucherDAO {
    public ArrayList<Voucher> getAllVouchers() {
        ArrayList<Voucher> list = new ArrayList<>();
        String sql = "SELECT code, description, expiry_date, discount_percent FROM Voucher WHERE expiry_date >= GETDATE()";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Voucher(
                    rs.getString("code"),
                    rs.getString("description"),
                    rs.getString("expiry_date"),
                    rs.getDouble("discount_percent")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
