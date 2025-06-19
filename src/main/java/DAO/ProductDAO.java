/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;


import config.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Product;

public class ProductDAO {

    // Lấy tất cả sản phẩm và số lượng tồn kho
    public ArrayList<Product> getAllProducts() {
        ArrayList<Product> products = new ArrayList<>();
        String query = "SELECT product_id, name, stock FROM Products";

        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(query);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product product = new Product(
                        rs.getInt("product_id"),
                        rs.getString("name"),
                        rs.getInt("stock")
                );
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return products;
    }

    public List<Product> getProductsByCategoryName(String categoryName) {
    List<Product> list = new ArrayList<>();
    String sql = "SELECT p.* FROM Products p "
               + "JOIN Categories c ON p.category_id = c.category_id "
               + "WHERE c.name LIKE ? AND p.status = 1";
    try (Connection conn = DBConnect.connect();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, "%" + categoryName + "%"); // Tìm mọi category chứa "RAM"
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(new Product(
                rs.getInt("product_id"),
                rs.getString("name"),
                rs.getString("description"),
                rs.getDouble("price"),
                rs.getInt("stock"),
                rs.getString("image_url")
            ));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

}
