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
                String statusName = status ? "Còn hàng" : "Hết hàng";
                String categoryName = rs.getString("cate_name");

                PC pc = new PC(id, name, description, price, stock, imageUrl, categoryName, statusName);
                pcList.add(pc);
            }

        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return pcList;
    }

    public PC getPCById(int id) {

        String sql = "SELECT p.product_id as p_id, p.name as p_name, p.description, p.price, p.stock,"
                + "p.image_url as image, p.status, c.name as cate_name "
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
                    String statusName = status ? "Còn bán" : "Hết hàng";
                    String categoryName = rs.getString("cate_name");

                    return new PC(id, name, description, price, stock, imageUrl, categoryName, statusName);
                }
            }

        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;
    }

}
