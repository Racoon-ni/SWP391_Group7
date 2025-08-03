package DAO;

import config.DBConnect;
import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Product;

public class CategoriesDAO {

    public List<Product> getProductsByCategoryId(int categoryId) throws SQLException, ClassNotFoundException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.product_id, p.name, p.description, p.price, p.stock, p.image_url, p.product_type, p.status, "
                + "c.category_id, c.name AS category_name, c.category_type, c.parent_id "
                + "FROM Products p "
                + "INNER JOIN Categories c ON p.category_id = c.category_id "
                + "WHERE p.category_id = ? AND p.status = 1";

        try ( Connection conn = DBConnect.connect()) {
            if (conn == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }
            try ( PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, categoryId);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setName(rs.getString("name"));
                    p.setDescription(rs.getString("description"));
                    p.setPrice(rs.getDouble("price"));
                    p.setStock(rs.getInt("stock"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setProductType(rs.getString("product_type"));
                    p.setStatus(rs.getInt("status"));

                    Category c = new Category();
                    c.setCategoryId(rs.getInt("category_id"));
                    c.setName(rs.getString("category_name"));
                    c.setCategoryType(rs.getString("category_type"));
                    c.setParentId(rs.getInt("parent_id"));
                    p.setCategory(c);

                    list.add(p);
                }
            }
        }
        return list;
    }

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.category_id, c.name, c.category_type, c.parent_id, p.name AS parent_name\n"
                + "FROM Categories c\n"
                + "LEFT JOIN Categories p ON c.parent_id = p.category_id ";
        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                Object parentObj = rs.getObject("parent_id");
                c.setParentId(parentObj != null ? rs.getInt("parent_id") : null);
                c.setName(rs.getString("name"));
                c.setCategoryType(rs.getString("category_type"));
                c.setParentName(rs.getString("parent_name"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insertCategory(Category c) {
        String sql = "INSERT INTO Categories (parent_id, name, category_type) VALUES (?, ?, ?)";
        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            if (c.getParentId() == null) {
                ps.setNull(1, java.sql.Types.INTEGER);
            } else {
                ps.setInt(1, c.getParentId());
            }
            ps.setString(2, c.getName());
            ps.setString(3, c.getCategoryType());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateCategory(Category c) {
        String sql = "UPDATE Categories SET parent_id=?, name=?, category_type=? WHERE category_id=?";
        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            if (c.getParentId() == null) {
                ps.setNull(1, java.sql.Types.INTEGER);
            } else {
                ps.setInt(1, c.getParentId());
            }
            ps.setString(2, c.getName());
            ps.setString(3, c.getCategoryType());
            ps.setInt(4, c.getCategoryId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteCategory(int categoryId) {
        String sql = "DELETE FROM Categories WHERE category_id=?";
        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Category getCategoryById(int id) {
        String sql = "SELECT * FROM Categories WHERE category_id=?";
        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                Object parentObj = rs.getObject("parent_id");
                c.setParentId(parentObj != null ? rs.getInt("parent_id") : null);
                c.setName(rs.getString("name"));
                c.setCategoryType(rs.getString("category_type"));
                return c;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
