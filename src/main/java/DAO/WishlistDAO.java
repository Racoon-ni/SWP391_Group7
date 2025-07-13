/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import model.Wishlist;
import java.sql.*;
import config.DBConnect;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Long
 */
// Lớp thao tác dữ liệu cho bảng Wishlists
public class WishlistDAO {

    // Thêm sản phẩm vào wishlist
    public boolean addToWishlist(Wishlist wishlist) throws SQLException {
        String sql = "INSERT INTO Wishlists (user_id, product_id, added_at) VALUES (?, ?, GETDATE())";
        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, wishlist.getUserId());
            ps.setInt(2, wishlist.getProductId());
            return ps.executeUpdate() > 0;
        }
    }

    // Kiểm tra sản phẩm đã có trong wishlist chưa
    public boolean isInWishlist(int userId, int productId) throws SQLException {
        String sql = "SELECT * FROM Wishlists WHERE user_id = ? AND product_id = ?";
        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    // Lấy danh sách productId trong wishlist của user
    public List<Integer> getWishlistProductIds(int userId) throws SQLException {
        List<Integer> productIdList = new ArrayList<>();
        String sql = "SELECT product_id FROM Wishlists WHERE user_id = ?";
        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                productIdList.add(rs.getInt("product_id"));
            }
        }
        return productIdList;
    }

    // Lấy danh sách sản phẩm trong wishlist của người dùng
    public List<Wishlist> getWishlistByUserId(int userId) throws SQLException {
        List<Wishlist> wishlistProducts = new ArrayList<>();

        // SQL truy vấn kết hợp bảng Wishlists với Products
        String sql = "SELECT p.product_id, p.name, p.price, p.image_url, w.added_at "
                + "FROM Products p "
                + "INNER JOIN Wishlists w ON p.product_id = w.product_id "
                + "WHERE w.user_id = ?";

        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);  // Set userId vào câu truy vấn
            ResultSet rs = ps.executeQuery();

            // Duyệt qua kết quả và tạo danh sách các sản phẩm
            while (rs.next()) {
                Wishlist wishlist = new Wishlist();
                wishlist.setUserId(userId); // Lưu userId từ tham số
                wishlist.setProductId(rs.getInt("product_id"));
                wishlist.setProductName(rs.getString("name"));
                wishlist.setPrice(rs.getDouble("price"));
                wishlist.setImageUrl(rs.getString("image_url"));
                wishlist.setAddedAt(rs.getTimestamp("added_at"));
                wishlistProducts.add(wishlist);
            }
        }
        return wishlistProducts;
    }

    public void removeFromWishlist(int userId, int productId) {
        try ( Connection conn = DBConnect.getConnection()) {
            String sql = "DELETE FROM wishlists WHERE user_id = ? AND product_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
