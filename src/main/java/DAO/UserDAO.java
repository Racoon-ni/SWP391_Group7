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

        String sql = "  SELECT u.user_id, u.username, u.email, u.password_hash, u.role, u.status\n"
                + "  FROM Users u\n"
                + "  WHERE u.username = ? AND u.password_hash = ?";

        try (
                 PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, hashMd5(password));

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("user_id");
                    String email = rs.getString("email");
                    String role = rs.getString("role");
                    boolean status = rs.getBoolean("status");

                    return new User(id, username, email, hashMd5(password), role, status);
                }
            }

        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;
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

}
