package DAO;

import config.DBConnect;
import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Product;

public class CategoriesDAO {

    public List<Product> getProductsByParentCategoryId(int parentId) throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.image_url, c.category_id, c.parent_id, c.name, c.category_type "
                + "FROM Products p "
                + "INNER JOIN Categories c ON p.category_id = c.category_id "
                + "WHERE c.parent_id = ? AND p.status = 1";

        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();
                p.setImageUrl(rs.getString("image_url"));
                // Lưu thông tin danh mục nếu cần, ví dụ:
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                c.setParentId(rs.getInt("parent_id"));
                c.setName(rs.getString("name"));
                c.setCategoryType(rs.getString("category_type"));
                p.setCategory(c);
                // Gán category vào product nếu Product có thuộc tính Category
                // p.setCategory(c);
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }

        return list;
    }
}
