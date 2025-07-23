package DAO;

import model.UserAddress;
import config.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserAddressDAO {

    public List<UserAddress> getAddressesByUserId(int userId) {
        List<UserAddress> list = new ArrayList<>();
        String sql = "SELECT * FROM UserAddresses WHERE user_id = ?";

        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                UserAddress ua = new UserAddress();
                ua.setId(rs.getInt("address_id"));
                ua.setUserId(rs.getInt("user_id"));
                ua.setFullName(rs.getString("receiver_name"));
                ua.setPhone(rs.getString("phone"));
                ua.setSpecificAddress(rs.getString("address"));
                ua.setDefaultAddress(rs.getBoolean("is_default"));
                list.add(ua);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void addAddress(UserAddress addr) {
        String sql = "INSERT INTO UserAddresses (user_id, receiver_name, phone, address, is_default, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, GETDATE())";

        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, addr.getUserId());
            ps.setString(2, addr.getFullName());
            ps.setString(3, addr.getPhone());
            ps.setString(4, addr.getSpecificAddress());
            ps.setBoolean(5, addr.isDefaultAddress());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean hasDefaultAddress(int userId) {
        String sql = "SELECT COUNT(*) FROM UserAddresses WHERE user_id = ? AND is_default = 1";
        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void clearDefaultAddress(int userId) {
        String sql = "UPDATE UserAddresses SET is_default = 0 WHERE user_id = ?";
        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean setOnlyOneDefaultAddress(int userId, int addressId) {
        try (Connection conn = DBConnect.connect()) {
            conn.setAutoCommit(false); // Bắt đầu transaction

            // Kiểm tra nếu address hiện tại đã là mặc định
            String checkCurrent = "SELECT is_default FROM UserAddresses WHERE address_id = ? AND user_id = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkCurrent)) {
                checkStmt.setInt(1, addressId);
                checkStmt.setInt(2, userId);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && rs.getBoolean("is_default")) {
                    return false; // Địa chỉ này đã là mặc định
                }
            }

            // Reset tất cả về false
            String clear = "UPDATE UserAddresses SET is_default = 0 WHERE user_id = ?";
            try (PreparedStatement clearStmt = conn.prepareStatement(clear)) {
                clearStmt.setInt(1, userId);
                clearStmt.executeUpdate();
            }

            // Set địa chỉ mới là mặc định
            String update = "UPDATE UserAddresses SET is_default = 1 WHERE address_id = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(update)) {
                updateStmt.setInt(1, addressId);
                updateStmt.executeUpdate();
            }

            conn.commit(); // Commit transaction
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void deleteAddress(int addressId) {
        String sql = "DELETE FROM UserAddresses WHERE address_id = ?";
        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, addressId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
     // ✅ Hàm mới: Lấy địa chỉ mặc định
    public UserAddress getDefaultAddress(int userId) {
        String sql = "SELECT TOP 1 * FROM UserAddresses WHERE user_id = ? AND is_default = 1";

        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                UserAddress ua = new UserAddress();
                ua.setId(rs.getInt("address_id"));
                ua.setUserId(rs.getInt("user_id"));
                ua.setFullName(rs.getString("receiver_name"));
                ua.setPhone(rs.getString("phone"));
                ua.setSpecificAddress(rs.getString("address"));
                ua.setDefaultAddress(rs.getBoolean("is_default"));
                return ua;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    
}
