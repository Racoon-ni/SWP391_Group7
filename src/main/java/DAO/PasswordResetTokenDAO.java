package DAO;

import config.DBConnect;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import model.PasswordResetToken;

import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.time.LocalDateTime;

public class PasswordResetTokenDAO {

    /**
     * Lưu token mới vào DB
     *
     * @param userId
     * @param token
     * @param expiry
     * @return
     */
    public boolean saveToken(int userId, String token, LocalDateTime expiry) {
        String sql = "INSERT INTO PasswordResetTokens (token, user_id, expiry_date) VALUES (?, ?, ?)";
        try ( Connection con = DBConnect.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, token);
            ps.setInt(2, userId);
            ps.setTimestamp(3, Timestamp.valueOf(expiry));

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy thông tin token từ DB
     *
     * @param token
     * @return
     */
    public PasswordResetToken getToken(String token) {
        String sql = "SELECT * FROM PasswordResetTokens WHERE token = ?";
        try ( Connection con = DBConnect.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                PasswordResetToken prt = new PasswordResetToken();
                prt.setToken(rs.getString("token"));
                prt.setUserId(rs.getInt("user_id"));
                prt.setExpiryDate(rs.getTimestamp("expiry_date").toLocalDateTime());
                return prt;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Xóa token sau khi dùng hoặc hết hạn
     *
     * @param token
     * @return
     */
    public boolean deleteToken(String token) {
        String sql = "DELETE FROM PasswordResetTokens WHERE token = ?";
        try ( Connection con = DBConnect.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, token);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật mật khẩu cho user dựa trên token
     *
     * @param token
     * @param newPassword
     * @return
     */
    public boolean updatePasswordByToken(String token, String newPassword) {
        PasswordResetToken prt = getToken(token);
        if (prt == null || prt.isExpired()) {
            return false; // token không hợp lệ hoặc hết hạn
        }

        String sql = "UPDATE Users SET password_hash = ? WHERE user_id = ?";
        try ( Connection con = DBConnect.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            String hashedPassword = hashMd5(newPassword);
            ps.setString(1, hashedPassword);
            ps.setInt(2, prt.getUserId());

            int updated = ps.executeUpdate();
            if (updated > 0) {
                deleteToken(token); // xoá token sau khi đổi mật khẩu thành công
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Hash password MD5
    private String hashMd5(String raw) {
//       use when need to convert password using sql
//SELECT LOWER(CONVERT(varchar(32), HASHBYTES('MD5', '1'), 2)) AS md5_hash
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
}
