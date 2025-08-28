package DAO;

import config.DBConnect;
import model.Cart;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    //    public void clearCartByUserId(int userId) throws Exception {
    //        String sql = "DELETE FROM CartItems WHERE user_id = ?";
    //        try (Connection conn = DBConnect.connect(); PreparedStatement ps = conn.prepareStatement(sql)) {
    //            ps.setInt(1, userId);
    //            ps.executeUpdate();
    //        }
    //    }

    public List<Cart> getCartByUserId(int userId) throws SQLException, ClassNotFoundException {
        List<Cart> cartItems = new ArrayList<>();

        String sql = "SELECT ci.cart_item_id, p.product_id, p.name, p.image_url, p.price, ci.quantity, p.stock " +
                "FROM CartItems ci " +
                "JOIN Products p ON ci.product_id = p.product_id " +
                "WHERE ci.user_id = ?";

        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int quantity = rs.getInt("quantity");
                int stock = rs.getInt("stock");
                if (quantity <= 0) quantity = 1;
                if (stock <= 0) stock = 1;

                Cart item = new Cart(
                        rs.getInt("cart_item_id"),
                        rs.getInt("product_id"),
                        rs.getString("name"),
                        rs.getString("image_url"),
                        quantity,
                        stock,
                        rs.getDouble("price")
                );
                cartItems.add(item);
            }
        }

        return cartItems;
    }

    public double getTotalAmount(List<Cart> items) {
        double total = 0;
        for (Cart item : items) {
            total += item.getPrice() * item.getQuantity();
        }
        return total;
    }

    public void addToCart(int userId, int productId) throws Exception {
        String checkSql = "SELECT quantity FROM CartItems WHERE user_id = ? AND product_id = ?";
        String insertSql = "INSERT INTO CartItems (user_id, product_id, quantity) VALUES (?, ?, ?)";
        String updateSql = "UPDATE CartItems SET quantity = quantity + 1 WHERE user_id = ? AND product_id = ?";

        try (Connection conn = DBConnect.connect()) {
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, userId);
            checkStmt.setInt(2, productId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setInt(1, userId);
                updateStmt.setInt(2, productId);
                updateStmt.executeUpdate();
            } else {
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setInt(1, userId);
                insertStmt.setInt(2, productId);
                insertStmt.setInt(3, 1);
                insertStmt.executeUpdate();
            }
        }
    }

    public void deleteCartItem(int cartItemId) throws Exception {
        String sql = "DELETE FROM CartItems WHERE cart_item_id = ?";
        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartItemId);
            ps.executeUpdate();
        }
    }

    public void updateCartItemQuantity(int cartItemId, int quantity) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE CartItems SET quantity = ? WHERE cart_item_id = ?";
        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, cartItemId);
            ps.executeUpdate();
        }
    }

    // Lấy tất cả sản phẩm trong giỏ hàng của người dùng
    public List<Cart> getCartItemsByUserId(int userId) {
        List<Cart> cartItems = new ArrayList<>();
        String sql = "SELECT c.cart_item_id, c.product_id, p.name, p.image_url, c.quantity, p.price " +
                "FROM CartItems c JOIN Products p ON c.product_id = p.product_id WHERE c.user_id = ?";

        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Cart item = new Cart(
                        rs.getInt("cart_item_id"),
                        rs.getInt("product_id"),
                        rs.getString("name"),
                        rs.getString("image_url"),
                        rs.getInt("quantity"),
                        rs.getDouble("price")
                );
                cartItems.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return cartItems;
    }

    public List<Cart> getCartItemsByUserId2(int userId) {
        List<Cart> cartItems = new ArrayList<>();
        String sql = "SELECT c.cart_item_id, c.product_id, p.name, p.image_url, p.stock, c.quantity, p.price " +
                "FROM CartItems c JOIN Products p ON c.product_id = p.product_id WHERE c.user_id = ?";
        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Cart item = new Cart(
                        rs.getInt("cart_item_id"),
                        rs.getInt("product_id"),
                        rs.getString("name"),
                        rs.getString("image_url"),
                        rs.getInt("quantity"),
                        rs.getInt("stock"),
                        rs.getDouble("price")
                );
                cartItems.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cartItems;
    }

    public double calculateTotal(List<Cart> cartItems) {
        double total = 0;
        for (Cart item : cartItems) {
            total += item.getPrice() * item.getQuantity();
        }
        return total;
    }

    // ✅ Hỗ trợ "Mua ngay" 1 sản phẩm (không dùng CartItems table)
    public Cart getCartItemForBuyNow(int productId) {
        String sql = "SELECT product_id, name, image_url, price, stock FROM Products WHERE product_id = ?";
        try (Connection con = DBConnect.connect();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Cart(
                        0, // cartItemId giả định (không nằm trong CartItems)
                        rs.getInt("product_id"),
                        rs.getString("name"),
                        rs.getString("image_url"),
                        1,
                        rs.getInt("stock"),
                        rs.getDouble("price")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Phương thức xóa tất cả sản phẩm trong giỏ hàng của người dùng
    public void clearCartByUserId(int userId) {
        String sql = "DELETE FROM CartItems WHERE user_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                System.out.println("All items in cart cleared successfully for user: " + userId);
            } else {
                System.out.println("No items found in the cart for user: " + userId);
            }
        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

      // Lấy số lượng hiện có của sản phẩm trong giỏ
    public int getCartQuantity(int userId, int productId) throws Exception {
        String sql = "SELECT quantity FROM CartItems WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    // Lấy tồn kho sản phẩm
    public int getProductStock(int productId) throws Exception {
        String sql = "SELECT stock FROM Products WHERE product_id = ?";
        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Thêm vào giỏ nhưng tôn trọng tồn kho:
     * - Chưa có -> insert 1 (nếu stock >= 1)
     * - Đã có -> tăng 1 khi quantity < stock
     * @return 1 = ADDED, 0 = MAXED, -1 = ERROR
     */
    public int addToCartRespectingStock(int userId, int productId) throws Exception {
        int currentQty = getCartQuantity(userId, productId);
        int stock = getProductStock(productId);
        if (stock <= 0) return 0; // hết hàng

        try (Connection conn = DBConnect.connect()) {
            if (currentQty <= 0) {
                String insertSql = "INSERT INTO CartItems (user_id, product_id, quantity, added_at) VALUES (?, ?, 1, GETDATE())";
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, productId);
                    ps.executeUpdate();
                }
                return 1; // ADDED
            } else {
                if (currentQty >= stock) return 0; // MAXED
                String updateSql = "UPDATE CartItems SET quantity = quantity + 1 WHERE user_id = ? AND product_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, productId);
                    ps.executeUpdate();
                }
                return 1; // ADDED
            }
        } catch (Exception e) {
            e.printStackTrace();
            return -1; // ERROR
        }
    }
    

    // ✅ XÓA ĐÚNG NHỮNG MỤC ĐÃ MUA KHỎI GIỎ HÀNG (theo cart_item_id)
    public void removePurchasedItems(int userId, List<Cart> purchasedItems) {
        if (purchasedItems == null || purchasedItems.isEmpty()) return;

        // gom các cart_item_id > 0 (chỉ những thứ đang có trong CartItems)
        List<Integer> ids = new ArrayList<>();
        for (Cart c : purchasedItems) {
            if (c.getCartItemId() > 0) {
                ids.add(c.getCartItemId());
            }
        }
        if (ids.isEmpty()) return; // "Mua ngay" không có cart_item_id, sẽ không cần xóa

        StringBuilder sb = new StringBuilder(
                "DELETE FROM CartItems WHERE user_id = ? AND cart_item_id IN ("
        );
        for (int i = 0; i < ids.size(); i++) {
            sb.append("?");
            if (i < ids.size() - 1) sb.append(",");
        }
        sb.append(")");

        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {

            ps.setInt(1, userId);
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 2, ids.get(i));
            }
            int deleted = ps.executeUpdate();
            System.out.println("Deleted " + deleted + " purchased cart item(s) for user " + userId);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
