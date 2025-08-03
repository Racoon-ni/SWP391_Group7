package DAO;

import config.DBConnect;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Category;
import model.PC;

public class pcDAO extends DBConnect {

    // Lấy danh sách tất cả PC, rating trung bình & lượt đánh giá
    public ArrayList<PC> getAllPCs() {
        ArrayList<PC> pcList = new ArrayList<>();
        String sql = "SELECT p.product_id as p_id, p.name as p_name, p.description, p.price, p.stock, "
                + "p.image_url as image, p.status, c.category_id as c_id, c.name as cate_name "
                + "FROM Products p JOIN Categories c on p.category_id = c.category_id "
                + "WHERE p.product_type = 'PC'";

        try ( PreparedStatement ps = DBConnect.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int id = rs.getInt("p_id");
                String name = rs.getString("p_name");
                String description = rs.getString("description");
                double price = rs.getDouble("price");
                int stock = rs.getInt("stock");
                String imageUrl = rs.getString("image");
                System.out.println(imageUrl);
                boolean status = rs.getBoolean("status");
                int categoryId = rs.getInt("c_id");
                String cateName = rs.getString("cate_name");

                Category category = new Category(categoryId, 0, cateName, "");

                PC pc = new PC(id, name, description, price, stock, imageUrl, category, status);

                // Lấy rating trung bình và số lượt đánh giá
                pc.setAvgStars(getAverageStars(id));
                pc.setTotalRatings(getTotalRatings(id));
                pcList.add(pc);
            }
        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return pcList;
    }

    // Lấy chi tiết PC theo id
    public PC getPCById(int id) {
        String sql = "SELECT p.[name], [description], [price], [stock], \n"
                + "[image_url], [status], c.name as cate_name, c.category_id as c_id \n"
                + "FROM [Products] p\n"
                + "JOIN Categories c on c.category_id = p.category_id\n"
                + " WHERE p.product_id = ?";
        try (
                 PreparedStatement ps = DBConnect.prepareStatement(sql);) {
            ps.setInt(1, id);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String name = rs.getString("name");
                    String description = rs.getString("description");
                    double price = rs.getDouble("price");
                    int stock = rs.getInt("stock");
                    String imageUrl = rs.getString("image_url");
                    boolean status = rs.getBoolean("status");
                    int categoryId = rs.getInt("c_id");
                    String cateName = rs.getString("cate_name");

                    Category category = new Category(categoryId, 0, cateName, "");
                    PC pc = new PC(id, name, description, price, stock, imageUrl, category, status);

                    pc.setAvgStars(getAverageStars(id));
                    pc.setTotalRatings(getTotalRatings(id));

                    return pc;
                }
            }
        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // ✅ Thêm PC và trả về product_id vừa được tạo
    public int addPC(PC pc) {
        String sql = "INSERT INTO Products (name, description, price, stock, image_url, product_type, category_id, status) "
                + "VALUES (?, ?, ?, ?, ?, 'PC', ?, 1)"; // mặc định status = 1 (true)

        try ( PreparedStatement ps = DBConnect.connect().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, pc.getName());
            ps.setString(2, pc.getDescription());
            ps.setDouble(3, pc.getPrice());
            ps.setInt(4, pc.getStock());
            ps.setString(5, pc.getImageUrl());
            ps.setInt(6, pc.getCategory().getCategoryId());

            int affectedRows = ps.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Inserting PC failed, no rows affected.");
            }

            try ( ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1); // Return the auto-generated product_id
                } else {
                    throw new SQLException("Inserting PC failed, no ID obtained.");
                }
            }

        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1; // Return -1 to indicate failure
    }

    // Cập nhật PC
    public int updatePC(PC pc) {
        String sql = "UPDATE Products SET name = ?, description = ?, price = ?, "
                + "stock = ?, status = ?, image_url = ? "
                + "WHERE product_id = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setString(1, pc.getName());
            ps.setString(2, pc.getDescription());
            ps.setDouble(3, pc.getPrice());
            ps.setInt(4, pc.getStock());
            ps.setBoolean(5, pc.isStatus());
            ps.setString(6, pc.getImageUrl());
            ps.setInt(7, pc.getId());
            return ps.executeUpdate();

        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    // Lấy số sao trung bình
    public double getAverageStars(int pcId) {
        String sql = "SELECT AVG(stars) FROM Ratings WHERE product_id = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, pcId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy tổng số lượt đánh giá
    public int getTotalRatings(int pcId) {
        String sql = "SELECT COUNT(*) FROM Ratings WHERE product_id = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, pcId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
