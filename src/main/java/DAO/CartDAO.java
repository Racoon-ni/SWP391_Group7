package DAO;

import config.DBConnect;
import model.Cart;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public void clearCartByUserId(int userId) throws Exception {
        String sql = "DELETE FROM CartItems WHERE user_id = ?";
        try (Connection conn = DBConnect.connect(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

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
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw e;
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

    public List<Cart> getCartItemsByUserId(int userId) {
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
}
