package DAO;

import config.DBConnect;
import model.Feedback;
import java.sql.*;
import java.util.*;

public class FeedbackDAO {

    public int addFeedback(Feedback fb) {
        String sql = "INSERT INTO Feedbacks (user_id, title, message, status, created_at) VALUES (?, ?, ?, ?, ?)";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, fb.getUserId());
            ps.setString(2, fb.getTitle());
            ps.setString(3, fb.getMessage());
            ps.setString(4, fb.getStatus());
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Optional: Lấy feedback của user hiện tại
    public List<Feedback> getFeedbacksByUser(int userId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM Feedbacks WHERE user_id = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Feedback fb = new Feedback();
                fb.setFeedbackId(rs.getInt("feedback_id"));
                fb.setUserId(rs.getInt("user_id"));
                fb.setTitle(rs.getString("title"));
                fb.setMessage(rs.getString("message"));
                fb.setStatus(rs.getString("status"));
                fb.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(fb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Feedback> getAllFeedback() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, u.username FROM Feedbacks f LEFT JOIN Users u ON f.user_id = u.user_id ORDER BY f.created_at DESC";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Feedback fb = new Feedback();
                fb.setFeedbackId(rs.getInt("feedback_id"));
                fb.setUserId(rs.getInt("user_id"));
                fb.setUserName(rs.getString("username"));
                fb.setTitle(rs.getString("title"));
                fb.setMessage(rs.getString("message"));
                fb.setStatus(rs.getString("status"));
                fb.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(fb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insertFeedback(Feedback fb) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
