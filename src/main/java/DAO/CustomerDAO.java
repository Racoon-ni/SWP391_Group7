package DAO;

import config.DBConnect;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import model.Customer;

import java.sql.*;

public class CustomerDAO {

    public Customer getCustomerById(int userId) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Customer(
                        rs.getInt("user_id"),
                        rs.getString("fullname"),
                        rs.getString("email"),
                        rs.getString("gender"),
                        rs.getString("address"),
                        rs.getString("phone"),
                        rs.getString("date_of_birth"),
                        rs.getString("password_hash")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateCustomerInfo(Customer c) {
        String sql = "UPDATE Users SET fullname=?, gender=?, date_of_birth=?,\n"
                + "address=?, phone=?, email=? WHERE user_id=?";
        try ( Connection con = DBConnect.connect();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, c.getFullName());
            ps.setString(2, c.getGender());
            ps.setDate(3, java.sql.Date.valueOf(c.getDateOfBirth()));
            ps.setString(4, c.getAddress());
            ps.setString(5, c.getPhone());
            ps.setString(6, c.getEmail());
            ps.setInt(7, c.getUserId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean checkOldPassword(int userId, String inputPassword) {
        String sql = "SELECT password_hash FROM Users WHERE user_id = ?";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String hashed = rs.getString("password_hash");
                return hashed.equals(hash(inputPassword));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE Users SET password_hash = ? WHERE user_id = ?";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hash(newPassword));
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private static String hash(String password) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("MD5");
        byte[] hashBytes = md.digest(password.getBytes());
        StringBuilder sb = new StringBuilder();
        for (byte b : hashBytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
