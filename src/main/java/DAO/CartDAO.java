package DAO;

import Model.Cart;
import config.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public List<Cart> getCartByUserId(int userId) throws SQLException, ClassNotFoundException {
        List<Cart> cartItems = new ArrayList<>();

        String sql = "SELECT ci.cart_item_id, p.product_id, p.name, p.image_url, p.price, ci.quantity, p.stock\n" +
"            FROM CartItems ci\n" +
"            JOIN Products p ON ci.product_id = p.product_id\n" +
"            WHERE ci.user_id = ?"
            
        ;

        try (Connection conn = DBConnect.connect()) {
            if (conn == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
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
}
