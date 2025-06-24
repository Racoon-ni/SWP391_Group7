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

/**
 *
 * @author Huynh Trong Nguyen - CE190356
 */
public class CategoryDAO extends DBConnect {

    public ArrayList<Category> getAllCategories() {

        ArrayList<Category> cateList = new ArrayList<>();
        String sql = "SELECT c.category_id as cate_id, c.parent_id, \n"
                + "c.name as cate_name, c.category_type as cate_type\n"
                + "FROM Categories c ";

        try (
                 PreparedStatement ps = DBConnect.prepareStatement(sql);  ResultSet rs = ps.executeQuery();) {
            while (rs.next()) {
                int id = rs.getInt("cate_id");
                int parentId = rs.getInt("parent_id");
                String name = rs.getString("cate_name");
                String type = rs.getString("cate_type");

                Category category = new Category(id, parentId, name, type);
                cateList.add(category);
            }

        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return cateList;
    }

    public Category getCategoryById(int id) {

        String sql = "SELECT c.category_id, c.parent_id, c.name, c.category_type\n"
                + "From Categories c \n"
                + "WHERE c.category_id = ?";

        try (
                 PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, id);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int cateId = rs.getInt("category_id");
                    int pId = rs.getInt("parent_id");
                    String name = rs.getString("name");
                    String cType = rs.getString("category_type");
                    return new Category(cateId, pId, name, cType);
                }
            }

        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;
    }
}
