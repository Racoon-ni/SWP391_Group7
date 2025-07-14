package DAO;

import config.DBConnect;
import model.Feedback;
import DAO.NotificationDAO;
import java.sql.*;
import java.util.*;

public class FeedbackDAO {

    // ✅ Thêm phản hồi mới từ khách hàng
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

    // ✅ Lấy danh sách phản hồi theo người dùng
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
                fb.setReplyMessage(rs.getString("reply_message"));
                fb.setReplyBy(rs.getInt("reply_by"));
                fb.setReplyAt(rs.getTimestamp("reply_at"));
                list.add(fb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Lấy toàn bộ phản hồi (cho admin)
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
                fb.setReplyMessage(rs.getString("reply_message"));
                fb.setReplyBy(rs.getInt("reply_by"));
                fb.setReplyAt(rs.getTimestamp("reply_at"));
                list.add(fb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Lấy phản hồi theo ID (admin xem chi tiết để trả lời)
    public Feedback getFeedbackById(int id) {
        String sql = "SELECT f.*, u.username FROM Feedbacks f LEFT JOIN Users u ON f.user_id = u.user_id WHERE f.feedback_id = ?";
        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Feedback fb = new Feedback();
                fb.setFeedbackId(rs.getInt("feedback_id"));
                fb.setUserId(rs.getInt("user_id"));
                fb.setUserName(rs.getString("username"));
                fb.setTitle(rs.getString("title"));
                fb.setMessage(rs.getString("message"));
                fb.setStatus(rs.getString("status"));
                fb.setCreatedAt(rs.getTimestamp("created_at"));
                fb.setReplyMessage(rs.getString("reply_message"));
                fb.setReplyBy(rs.getInt("reply_by"));
                fb.setReplyAt(rs.getTimestamp("reply_at"));
                return fb;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ Admin trả lời phản hồi và gửi thông báo cho khách
    // ✅ Trả lời phản hồi và trả về user_id để gửi thông báo
    public int replyToFeedback(int feedbackId, int adminId, String replyMessage) {
        String sql = "UPDATE Feedbacks SET reply_message = ?, reply_by = ?, reply_at = GETDATE(), status = N'Resolved' WHERE feedback_id = ?";
        String getUserSql = "SELECT user_id FROM Feedbacks WHERE feedback_id = ?";
        Connection conn = null;
        PreparedStatement psUpdate = null;
        PreparedStatement psGetUser = null;
        ResultSet rs = null;

        try {
            conn = DBConnect.getConnection();

            // ✅ Trước tiên, lấy user_id để trả về sau
            psGetUser = conn.prepareStatement(getUserSql);
            psGetUser.setInt(1, feedbackId);
            rs = psGetUser.executeQuery();

            int userId = -1;
            if (rs.next()) {
                userId = rs.getInt("user_id");
            } else {
                return -1; // Không tìm thấy feedback
            }

            // ✅ Cập nhật phản hồi
            psUpdate = conn.prepareStatement(sql);
            psUpdate.setString(1, replyMessage);
            psUpdate.setInt(2, adminId);
            psUpdate.setInt(3, feedbackId);
            int updated = psUpdate.executeUpdate();

            return updated > 0 ? userId : -1;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
            }
            try {
                if (psUpdate != null) {
                    psUpdate.close();
                }
            } catch (Exception e) {
            }
            try {
                if (psGetUser != null) {
                    psGetUser.close();
                }
            } catch (Exception e) {
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
            }
        }

        return -1;
    }

    // ❌ Không dùng
    public void insertFeedback(Feedback fb) {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}
