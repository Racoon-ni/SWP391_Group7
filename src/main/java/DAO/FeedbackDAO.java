package DAO;

import config.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class FeedbackDAO {

    /**
     * Save feedback to database
     * @param userId the ID of the user sending the feedback
     * @param title title of the feedback
     * @param message content/message of the feedback
     * @return true if insert successful, false otherwise
     */
    public boolean saveFeedback(int userId, String title, String message) {
        String sql = "INSERT INTO Feedbacks (user_id, title, message) VALUES (?, ?, ?)";

        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, title);
            ps.setString(3, message);

            int result = ps.executeUpdate();
            return result > 0;

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
