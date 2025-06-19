package dao;

import config.DBConnect;
import model.WishlistItem;

import java.sql.*;
import java.util.ArrayList;

public class WishlistDAO {
    // Lấy danh sách sản phẩm yêu thích theo userId

    public ArrayList<WishlistItem> getWishlistByUserId(int userId) {
        ArrayList<WishlistItem> list = new ArrayList<>();
        String sql = "SELECT w.id, p.product_id, p.name, p.image_url, p.price "
                + "FROM Wishlist w JOIN Products p ON w.product_id = p.product_id "
                + "WHERE w.user_id = ?";

        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                WishlistItem item = new WishlistItem(
                        rs.getInt("id"),
                        rs.getInt("product_id"),
                        rs.getString("name"),
                        rs.getString("image_url"),
                        rs.getDouble("price")
                );
                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}
