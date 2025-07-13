/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import config.DBConnect;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;

/**
 *
 * @author Huynh Trong Nguyen - CE190356
 */
public class UserDAO extends DBConnect {

    public boolean login(User user) {
        String query = "select count(user_id) from users "
                + "where username = ? "
                + "and password_hash = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(query)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) == 1;
        } catch (SQLException | ClassNotFoundException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public User getUser(String username, String password) {

        String sql = "SELECT u.user_id, u.email,\n"
                + "  u.fullname, u.date_of_birth, u.address,\n"
                + "  u.phone, u.gender, u.role, u.status\n"
                + "  FROM Users u "
                + "  WHERE u.username = ? AND u.password_hash = ?";

        try (
                 PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, hashMd5(password));

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("user_id");
                    String email = rs.getString("email");
                    String fullname = rs.getString("fullname");
                    Date dateOfBirth = rs.getDate("date_of_birth");
                    String address = rs.getString("address");
                    String phone = rs.getString("phone");
                    String gender = rs.getString("gender");
                    String role = rs.getString("role");
                    boolean status = rs.getBoolean("status");

                    return new User(id, username, hashMd5(password), email, fullname, dateOfBirth, address, phone, gender, role, status);
                }
            }

        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;
    }

    public User getUserById(int id) {

        String sql = "SELECT u.username, u.email,\n"
                + "  u.fullname, u.date_of_birth, u.address,\n"
                + "  u.phone, u.gender, u.role, u.status\n"
                + "  FROM Users u"
                + "  WHERE u.user_id = ?";

        try (
                 PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, id);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String username = rs.getString("username");
                    String email = rs.getString("email");
                    String fullname = rs.getString("fullname");
                    Date dateOfBirth = rs.getDate("date_of_birth");
                    String address = rs.getString("address");
                    String phone = rs.getString("phone");
                    String gender = rs.getString("gender");
                    String role = rs.getString("role");
                    boolean status = rs.getBoolean("status");

                    return new User(id, username, "", email, fullname, dateOfBirth, address, phone, gender, role, status);
                }
            }

        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;
    }

    public int updateUser(User user) {

        String sql = " Update Users SET role = ?, status = ? \n"
                + "WHERE user_id = ?";

        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setString(1, user.getRole());
            ps.setBoolean(2, user.isStatus());
            ps.setInt(3, user.getId());

            return ps.executeUpdate(); // returns 1 if success
        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return 0;

    }

    public int register(User user) {

        String sql = "INSERT INTO Users (username, email, password_hash, role) \n"
                + "VALUES (?, ?, ?, ?)";

        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, hashMd5(user.getPassword()));
            ps.setString(4, user.getRole());

            return ps.executeUpdate(); // returns 1 if success
        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    // Lấy toàn bộ user (bao gồm ngày sinh)
    public ArrayList<User> getAllUser() {
        ArrayList<User> userList = new ArrayList<>();
        String sql = "SELECT u.user_id, u.username, u.email, u.fullname, u.date_of_birth, u.address, u.phone, u.gender, u.role, u.status FROM Users u";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User user = new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        "", // không lấy password
                        rs.getString("email"),
                        rs.getString("fullname"),
                        rs.getDate("date_of_birth"),
                        rs.getString("address"),
                        rs.getString("phone"),
                        rs.getString("gender"),
                        rs.getString("role"),
                        rs.getBoolean("status")
                );
                userList.add(user);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return userList;
    }

    // Hash password MD5
    private String hashMd5(String raw) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] mess = md.digest(raw.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : mess) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException ex) {
            ex.printStackTrace();
            return "";
        }
    }

    // Kiểm tra username tồn tại
    public boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM Users WHERE username = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Users WHERE email = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

   public int updateStaff(User user) {
    String sql = "UPDATE Users SET fullname = ?, email = ?, phone = ?, gender = ?, address = ?, date_of_birth = ?, role = ?, status = ? WHERE user_id = ?";
    try (PreparedStatement ps = DBConnect.prepareStatement(sql)) {
        ps.setString(1, user.getFullname());
        ps.setString(2, user.getEmail());
        ps.setString(3, user.getPhone());
        ps.setString(4, user.getGender());
        ps.setString(5, user.getAddress());
        ps.setDate(6, (java.sql.Date) user.getDateOfBirth()); // CẬP NHẬT NGÀY SINH!
        ps.setString(7, user.getRole());
        ps.setBoolean(8, user.isStatus());
        ps.setInt(9, user.getId());
        return ps.executeUpdate();
    } catch (Exception ex) {
        ex.printStackTrace();
    }
    return 0;
}
// Thêm nhân viên mới (CÓ NGÀY SINH)

    public int addStaff(User user) {
        String sql = "INSERT INTO Users (username, email, password_hash, fullname, date_of_birth, phone, gender, address, role, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, hashMd5(user.getPassword()));
            ps.setString(4, user.getFullname());
            ps.setDate(5, (java.sql.Date) user.getDateOfBirth());
            ps.setString(6, user.getPhone());
            ps.setString(7, user.getGender());
            ps.setString(8, user.getAddress());
            ps.setString(9, user.getRole());
            ps.setBoolean(10, user.isStatus());
            return ps.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    public int deleteUser(int userId) {
        String sql = "DELETE FROM Users WHERE user_id = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return 0;
    }

}
