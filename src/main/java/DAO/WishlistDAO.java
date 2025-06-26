package DAO;

import config.DBConnect;
import model.Wishlist;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAO {

    // Lấy danh sách sản phẩm yêu thích theo userId
    public List<Wishlist> getWishlistByUserId(int userId) {
        List<Wishlist> list = new ArrayList<>();
        String sql = "SELECT w.id, p.product_id, p.name, p.image_url, p.price, w.added_at "
                + "FROM Wishlists w JOIN Products p ON w.product_id = p.product_id "
                + "WHERE w.user_id = ?";

        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);  // Set giá trị userId vào PreparedStatement
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                // Chuyển đổi Timestamp sang Date nếu cần thiết
                Timestamp timestamp = rs.getTimestamp("added_at");
                Date addedAt = new Date(timestamp.getTime());

                // Tạo đối tượng Wishlist và thêm vào list
                Wishlist item = new Wishlist(
                        userId, // userId của người dùng
                        rs.getInt("product_id"),
                        rs.getString("name"),
                        rs.getString("image_url"),
                        rs.getDouble("price"),
                        addedAt
                );
                list.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
