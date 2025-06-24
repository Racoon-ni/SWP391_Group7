/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import config.DBConnect;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Category;
import model.PC;

/**
 *
 * @author Huynh Trong Nguyen - CE190356
 */
public class pcDAO extends DBConnect {

    public ArrayList<PC> getAllPCs() {

        ArrayList<PC> pcList = new ArrayList<>();
        String sql = "SELECT p.product_id as p_id, p.name as p_name, p.description, p.price, p.stock, \n"
                + "  p.image_url as image, p.status, c.name as cate_name \n"
                + "  FROM Products p\n"
                + "  JOIN Categories c on p.category_id = c.category_id\n"
                + "  WHERE p.product_type = 'PC'";

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
                Category category = new Category(0, 0, rs.getString("cate_name"), "");

                PC pc = new PC(id, name, description, price, stock, imageUrl, category, status);
                pcList.add(pc);
            }

        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return pcList;
    }

    public PC getPCById(int id) {

        String sql = "SELECT p.product_id as p_id, p.name as p_name, p.description, p.price, p.stock,"
                + "p.image_url as image, p.status, c.category_id as c_id, c.name as cate_name "
                + "FROM Products p "
                + "JOIN Categories c on p.category_id = c.category_id "
                + "WHERE p.product_id = ?";

        try (
                 PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, id);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String name = rs.getString("p_name");
                    String description = rs.getString("description");
                    double price = rs.getDouble("price");
                    int stock = rs.getInt("stock");
                    String imageUrl = rs.getString("image");
                    boolean status = rs.getBoolean("status");
                    Category category = new Category(rs.getInt("c_id"), 0, rs.getString("cate_name"), "");

                    return new PC(id, name, description, price, stock, imageUrl, category, status);
                }
            }

        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;
    }

    public int addPC(PC pc) {

        String sql = "INSERT INTO Products (name, description, price, stock, image_url, product_type, category_id) "
                + "VALUES (?, ?, ?, ?, null, 'PC', ?)";

        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setString(1, pc.getName());
            ps.setString(2, pc.getDescription());
            ps.setDouble(3, pc.getPrice());
            ps.setInt(4, pc.getStock());
            ps.setInt(5, pc.getCategory().getCategoryId());

            return ps.executeUpdate(); // returns 1 if success
        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return 0;

    }

    public int updatePC(PC pc) {

        String sql = "Update Products SET name = ?, description = ?, price = ?,\n"
                    + "stock = ?, category_id = ?, status = ?\n"
                    + "WHERE product_id = ? ";

        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setString(1, pc.getName());
            ps.setString(2, pc.getDescription());
            ps.setDouble(3, pc.getPrice());
            ps.setInt(4, pc.getStock());
            ps.setInt(5, pc.getCategory().getCategoryId());
            ps.setBoolean(6, pc.isStatus());
            ps.setInt(7, pc.getId());

            return ps.executeUpdate(); // returns 1 if success
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

}
