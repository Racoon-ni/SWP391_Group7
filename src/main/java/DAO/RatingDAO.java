package DAO;

import config.DBConnect;
import model.Rating;
import java.sql.*;
import java.util.*;

public class RatingDAO {

    public List<Rating> getRatingsByProductId(int productId) {
        List<Rating> ratings = new ArrayList<>();
        String sql = "SELECT r.*, u.username FROM Ratings r JOIN Users u ON r.user_id = u.user_id WHERE r.product_id = ?";
        try ( Connection con = DBConnect.connect();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Rating rating = new Rating();
                rating.setRatingId(rs.getInt("rating_id"));
                rating.setUserId(rs.getInt("user_id"));
                rating.setProductId(rs.getInt("product_id"));
                rating.setStars(rs.getInt("stars"));
                rating.setComment(rs.getString("comment"));
                rating.setUserName(rs.getString("username"));
                rating.setCreatedAt(rs.getTimestamp("created_at"));
                ratings.add(rating);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ratings;
    }

    // === HÀM BẠN CẦN THÊM VÀO ĐÂY ===
    public boolean addRating(Rating rating) {
        String sql = "INSERT INTO Ratings (user_id, order_id, product_id, stars, comment) VALUES (?, ?, ?, ?, ?)";
        try ( Connection con = DBConnect.connect();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, rating.getUserId());
            ps.setInt(2, rating.getOrderId());
            ps.setInt(3, rating.getProductId());
            ps.setInt(4, rating.getStars());
            ps.setString(5, rating.getComment());
            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean hasUserRated(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM Ratings WHERE user_id=? AND product_id=?";
        try ( Connection con = DBConnect.connect();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasUserRatedInOrder(int userId, int orderId, int productId) {
        String sql = "SELECT COUNT(*) FROM Ratings WHERE user_id = ? AND order_id = ? AND product_id = ?";
        try ( Connection con = DBConnect.connect();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, orderId);
            ps.setInt(3, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
