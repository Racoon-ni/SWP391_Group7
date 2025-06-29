package DAO;

import config.DBConnect;
import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Product;

public class CategoriesDAO {

    public List<Product> getProductsByParentCategoryId(int parentId) throws SQLException, ClassNotFoundException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.product_id, p.name, p.description, p.price, p.stock, p.image_url, p.product_type, p.status, "
                + "c.category_id, c.parent_id, c.name AS category_name, c.category_type "
                + "FROM Products p "
                + "INNER JOIN Categories c ON p.category_id = c.category_id "
                + "WHERE c.parent_id = ? AND p.status = 1";

        try ( Connection conn = DBConnect.connect()) {
            if (conn == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }
            try ( PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, parentId);
                ResultSet rs = ps.executeQuery();
                ProductDAO productDAO = new ProductDAO();
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setName(rs.getString("name") != null ? rs.getString("name") : "");
                    p.setDescription(rs.getString("description") != null ? rs.getString("description") : "");
                    p.setPrice(rs.getDouble("price"));
                    p.setStock(rs.getInt("stock"));
                    p.setImageUrl(rs.getString("image_url") != null ? rs.getString("image_url") : "");
                    p.setProductType(rs.getString("product_type") != null ? rs.getString("product_type") : "");
                    p.setStatus(rs.getBoolean("status"));

                    Category c = new Category();
                    c.setCategoryId(rs.getInt("category_id"));
                    c.setParentId(rs.getInt("parent_id"));
                    c.setName(rs.getString("category_name") != null ? rs.getString("category_name") : "");
                    c.setCategoryType(rs.getString("category_type") != null ? rs.getString("category_type") : "");
                    p.setCategory(c);

                    // LẤY RATING VÀ GÁN
                    p.setAvgStars(productDAO.getAverageStars(p.getProductId()));
                    p.setTotalRatings(productDAO.getTotalRatings(p.getProductId()));
                    
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return list;
    }

}
