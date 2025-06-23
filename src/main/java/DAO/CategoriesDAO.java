package DAO;

import config.DBConnect;
import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Product;

public class CategoriesDAO {

    public List<Category> getChildCategories(int parentId)  {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM Categories WHERE parent_id = ?";
        try (
                 Connection conn = DBConnect.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, parentId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Category c = new Category(
                        rs.getInt("category_id"),
                        rs.getInt("parent_id"),
                        rs.getString("name"),
                        rs.getString("category_type")
                );
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

   

}
