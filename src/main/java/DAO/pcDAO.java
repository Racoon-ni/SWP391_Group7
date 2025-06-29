package DAO;

import config.DBConnect;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

        try (
                 PreparedStatement ps = DBConnect.prepareStatement(sql);  ResultSet rs = ps.executeQuery();) {
            while (rs.next()) {
                int id = rs.getInt("p_id");
                String name = rs.getString("p_name");
                String description = rs.getString("description");
                double price = rs.getDouble("price");
                int stock = rs.getInt("stock");
                String imageUrl = rs.getString("image");
                boolean status = rs.getBoolean("status");
                int categoryId = rs.getInt("c_id");
                String cateName = rs.getString("cate_name");

                Category category = new Category(categoryId, 0, cateName, "");
                PC pc = new PC(id, name, description, price, stock, imageUrl, category, status);

                // LẤY RATING TRUNG BÌNH VÀ SỐ LƯỢT ĐÁNH GIÁ
                pc.setAvgStars(getAverageStars(id));
                pc.setTotalRatings(getTotalRatings(id));

                pcList.add(pc);
            }
        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return pcList;
    }

    // Lấy chi tiết PC có rating trung bình & lượt đánh giá
    public PC getPCById(int id) {
        String sql = "SELECT p.product_id as p_id, p.name as p_name, p.description, p.price, p.stock, "
                + "p.image_url as image, p.status, c.category_id as c_id, c.name as cate_name "
                + "FROM Products p "
                + "JOIN Categories c on p.category_id = c.category_id "
                + "WHERE p.product_id = ?";
        try (
                 PreparedStatement ps = DBConnect.prepareStatement(sql);) {
            ps.setInt(1, id);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String name = rs.getString("p_name");
                    String description = rs.getString("description");
                    double price = rs.getDouble("price");
                    int stock = rs.getInt("stock");
                    String imageUrl = rs.getString("image");
                    boolean status = rs.getBoolean("status");
                    int categoryId = rs.getInt("c_id");
                    String cateName = rs.getString("cate_name");
                    Category category = new Category(categoryId, 0, cateName, "");

                    PC pc = new PC(id, name, description, price, stock, imageUrl, category, status);
                    // LẤY RATING TRUNG BÌNH VÀ SỐ LƯỢT ĐÁNH GIÁ
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

    public int addPC(PC pc) {
        String sql = "INSERT INTO Products (name, description, price, stock, image_url, product_type, category_id) "
                + "VALUES (?, ?, ?, ?, ?, 'PC', ?)";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setString(1, pc.getName());
            ps.setString(2, pc.getDescription());
            ps.setDouble(3, pc.getPrice());
            ps.setInt(4, pc.getStock());
            ps.setString(5, pc.getImageUrl());
            ps.setInt(6, pc.getCategory().getCategoryId());
            return ps.executeUpdate(); // returns 1 if success
        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public int updatePC(PC pc) {
        String sql = "UPDATE Products SET name = ?, description = ?, price = ?, "
                + "stock = ?, category_id = ?, status = ?, image_url = ? "
                + "WHERE product_id = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setString(1, pc.getName());
            ps.setString(2, pc.getDescription());
            ps.setDouble(3, pc.getPrice());
            ps.setInt(4, pc.getStock());
            ps.setInt(5, pc.getCategory().getCategoryId());
            ps.setBoolean(6, pc.isStatus());
            ps.setString(7, pc.getImageUrl());
            ps.setInt(8, pc.getId());
            return ps.executeUpdate();
        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public int delete(int id) {
        String query = "DELETE FROM Products WHERE product_id = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(query)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
            return 0;
        }
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

    // Lấy số lượt đánh giá
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
