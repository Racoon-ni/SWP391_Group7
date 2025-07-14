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
                    String gender = rs.getString("phone");
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

    public ArrayList<User> getAllUser() {

        ArrayList<User> userList = new ArrayList<>();
        String sql = "  SELECT u.user_id, u.username, u.email,\n"
                + "  u.fullname, u.date_of_birth, u.address,\n"
                + "  u.phone, u.gender, u.role, u.status\n"
                + "  FROM Users u";

        try (
                 PreparedStatement ps = DBConnect.prepareStatement(sql);  ResultSet rs = ps.executeQuery();) {
            while (rs.next()) {
                int id = rs.getInt("user_id");
                String name = rs.getString("username");
                String email = rs.getString("email");
                String fullname = rs.getString("fullname");
                Date dateOfBirth = rs.getDate("date_of_birth");
                String address = rs.getString("address");
                String phone = rs.getString("phone");
                String gender = rs.getString("phone");
                String role = rs.getString("role");
                boolean status = rs.getBoolean("status");

                User user = new User(id, name, "", email, fullname, dateOfBirth, address, phone, gender, role, status);
                userList.add(user);
            }

        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return userList;
    }

    private String hashMd5(String raw) {
//       use when need to convert password using sql
//SELECT LOWER(CONVERT(varchar(32), HASHBYTES('MD5', '123456'), 2)) AS md5_hash
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] mess = md.digest(raw.getBytes());

            StringBuilder sb = new StringBuilder();
            for (byte b : mess) {
                sb.append(String.format("%02x", b));
            }

            return sb.toString();
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
            return "";
        }
    }

    public User getUserByIdForCheckout(int id) {
        String sql = "SELECT user_id, username, email, password_hash, fullname, date_of_birth, "
                + "address, phone, gender, role, status "
                + "FROM Users WHERE user_id = ?";

        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, id);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int userId = rs.getInt("user_id");
                    String username = rs.getString("username");
                    String email = rs.getString("email");
                    String password = rs.getString("password_hash");
                    String fullname = rs.getString("fullname");
                    java.sql.Date dob = rs.getDate("date_of_birth");
                    String address = rs.getString("address");
                    String phone = rs.getString("phone");
                    String gender = rs.getString("gender");
                    String role = rs.getString("role");
                    boolean status = rs.getBoolean("status");
                    

                    // Constructor đầy đủ của User
                    return new User(userId, username, password, email, fullname, dob, address, phone, gender, role, status);
                }
            }
           

        } catch (Exception ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;
    }
}
