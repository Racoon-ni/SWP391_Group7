package DAO;

import config.DBConnect;
import model.Rating;

import java.sql.*;
import java.util.*;

public class RatingDAO {

    // Lấy danh sách ảnh theo rating_id
    private List<String> getImagesByRatingId(int ratingId, Connection con) throws SQLException {
        List<String> images = new ArrayList<>();
        String sql = "SELECT image_url FROM RatingImages WHERE rating_id = ?";
        try ( PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ratingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                images.add(rs.getString("image_url"));
            }
        }
        return images;
    }

    public List<Rating> getRatingsByProductId(int productId) {
        List<Rating> ratings = new ArrayList<>();
        String sql = "SELECT r.*, u.username FROM Ratings r JOIN Users u ON r.user_id = u.user_id WHERE r.product_id = ?";
        try ( Connection con = DBConnect.connect();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Rating rating = new Rating();
                int ratingId = rs.getInt("rating_id");
                rating.setRatingId(ratingId);
                rating.setUserId(rs.getInt("user_id"));
                rating.setProductId(rs.getInt("product_id"));
                rating.setStars(rs.getInt("stars"));
                rating.setComment(rs.getString("comment"));
                rating.setUserName(rs.getString("username"));
                rating.setCreatedAt(rs.getTimestamp("created_at"));
                // Lấy ảnh cho rating
                rating.setImageUrls(getImagesByRatingId(ratingId, con));
                ratings.add(rating);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ratings;
    }

    // Thêm 1 rating, và trả về rating_id mới được tạo (để thêm ảnh)
    public int addRatingAndReturnId(Rating rating, Connection con) throws SQLException {
        String sql = "INSERT INTO Ratings (user_id, order_id, product_id, stars, comment) VALUES (?, ?, ?, ?, ?)";
        try ( PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, rating.getUserId());
            ps.setInt(2, rating.getOrderId());
            ps.setInt(3, rating.getProductId());
            ps.setInt(4, rating.getStars());
            ps.setString(5, rating.getComment());
            ps.executeUpdate();

            try ( ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1); // rating_id vừa tạo
                }
            }
        }
        return -1;
    }

    // Thêm rating (và ảnh nếu có)
    public boolean addRating(Rating rating) {
        Connection con = null;
        try {
            con = DBConnect.connect();
            con.setAutoCommit(false); // Transaction

            int ratingId = addRatingAndReturnId(rating, con);

            if (ratingId > 0 && rating.getImageUrls() != null) {
                for (String imgUrl : rating.getImageUrls()) {
                    addImageForRating(ratingId, imgUrl, con);
                }
            }
            con.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                }
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    // Thêm ảnh cho 1 rating
    public void addImageForRating(int ratingId, String imageUrl, Connection con) throws SQLException {
        String sql = "INSERT INTO RatingImages (rating_id, image_url) VALUES (?, ?)";
        try ( PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ratingId);
            ps.setString(2, imageUrl);
            ps.executeUpdate();
        }
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

    // Lấy trung bình số sao
    public Map<Integer, Double> getAverageStars() {
        Map<Integer, Double> avgStarsMap = new HashMap<>();
        String sql = "SELECT product_id, AVG(CAST(stars AS FLOAT)) AS avg_star FROM Ratings GROUP BY product_id";
        try ( Connection con = DBConnect.connect();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                avgStarsMap.put(rs.getInt("product_id"), rs.getDouble("avg_star"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return avgStarsMap;
    }

    public Map<Integer, Integer> getRatingCounts() {
        Map<Integer, Integer> countMap = new HashMap<>();
        String sql = "SELECT product_id, COUNT(*) as total FROM Ratings GROUP BY product_id";
        try ( Connection con = DBConnect.connect();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                countMap.put(rs.getInt("product_id"), rs.getInt("total"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return countMap;
    }

    // Thêm: Sửa đánh giá (update stars/comment và thêm ảnh nếu có)
    public boolean updateRating(Rating rating) {
        Connection con = null;
        try {
            con = DBConnect.connect();
            con.setAutoCommit(false);

            String sql = "UPDATE Ratings SET stars=?, comment=? WHERE rating_id=?";
            try ( PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, rating.getStars());
                ps.setString(2, rating.getComment());
                ps.setInt(3, rating.getRatingId());
                ps.executeUpdate();
            }

            // Nếu muốn thay ảnh cũ bằng ảnh mới, xóa ảnh cũ trước:
            if (rating.getImageUrls() != null) {
                String delSql = "DELETE FROM RatingImages WHERE rating_id=?";
                try ( PreparedStatement ps = con.prepareStatement(delSql)) {
                    ps.setInt(1, rating.getRatingId());
                    ps.executeUpdate();
                }
                // Sau đó thêm lại ảnh mới
                for (String imgUrl : rating.getImageUrls()) {
                    addImageForRating(rating.getRatingId(), imgUrl, con);
                }
            }
            con.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                }
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    // Lấy 1 rating theo id (kèm ảnh)
    public Rating getRatingById(int ratingId) {
        String sql = "SELECT r.*, u.username FROM Ratings r JOIN Users u ON r.user_id = u.user_id WHERE r.rating_id = ?";
        try ( Connection con = DBConnect.connect();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ratingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Rating rating = new Rating();
                rating.setRatingId(ratingId);
                rating.setUserId(rs.getInt("user_id"));
                rating.setProductId(rs.getInt("product_id"));
                rating.setStars(rs.getInt("stars"));
                rating.setComment(rs.getString("comment"));
                rating.setUserName(rs.getString("username"));
                rating.setCreatedAt(rs.getTimestamp("created_at"));
                rating.setImageUrls(getImagesByRatingId(ratingId, con));
                return rating;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
