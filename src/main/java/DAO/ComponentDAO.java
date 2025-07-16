/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import config.DBConnect;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Category;
import model.Component;

/**
 *
 * @author Huynh Trong Nguyen - CE190356
 */
public class ComponentDAO {

    public ArrayList<Component> getAllComponents(String cateIdsParam) {
        ArrayList<Component> componentList = new ArrayList<>();
        ArrayList<Integer> cateIdList = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT p.product_id as p_id, p.name as p_name, p.description, p.price, p.stock, "
                + "p.image_url as image, p.status, c.name as cate_name "
                + "FROM Products p "
                + "JOIN Categories c on p.category_id = c.category_id "
                + "WHERE p.product_type = 'Component'");

        boolean hasCategory = cateIdsParam != null && !cateIdsParam.isEmpty();
        if (hasCategory) {
            String[] cateIdArray = cateIdsParam.split(",");
            for (String id : cateIdArray) {
                cateIdList.add(Integer.parseInt(id.trim()));
            }

            // Add placeholders like ?,?,?
            String placeholders = String.join(",", Collections.nCopies(cateIdList.size(), "?"));
            sql.append(" AND p.category_id IN (").append(placeholders).append(")");
        }

        try ( PreparedStatement ps = DBConnect.prepareStatement(sql.toString())) {
            if (hasCategory) {
                for (int i = 0; i < cateIdList.size(); i++) {
                    ps.setInt(i + 1, cateIdList.get(i)); // Bind each category ID
                }
            }

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("p_id");
                    String name = rs.getString("p_name");
                    String description = rs.getString("description");
                    double price = rs.getDouble("price");
                    int stock = rs.getInt("stock");
                    String imageUrl = rs.getString("image");
                    boolean status = rs.getBoolean("status");
                    Category category = new Category(0, 0, rs.getString("cate_name"), "");

                    Component component = new Component(id, name, description, price, stock, imageUrl, category, status);
                    componentList.add(component);
                }
            }

        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return componentList;
    }

    public Component getComponentById(int id) {

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

                    return new Component(id, name, description, price, stock, imageUrl, category, status);
                }
            }

        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;
    }

    public int addComponent(Component component) {

        String sql = "INSERT INTO Products (name, description, price, stock, image_url, product_type, category_id) "
                + "VALUES (?, ?, ?, ?, null, 'Component', ?)";

        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setString(1, component.getName());
            ps.setString(2, component.getDescription());
            ps.setDouble(3, component.getPrice());
            ps.setInt(4, component.getStock());
            ps.setInt(5, component.getCategory().getCategoryId());

            return ps.executeUpdate(); // returns 1 if success
        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return 0;

    }

    public int updateComponent(Component component) {

        String sql = "Update Products SET name = ?, description = ?, price = ?,\n"
                + "stock = ?, category_id = ?, status = ?\n"
                + "WHERE product_id = ? ";

        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setString(1, component.getName());
            ps.setString(2, component.getDescription());
            ps.setDouble(3, component.getPrice());
            ps.setInt(4, component.getStock());
            ps.setInt(5, component.getCategory().getCategoryId());
            ps.setBoolean(6, component.isStatus());
            ps.setInt(7, component.getId());

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

    public int getLastInsertedComponentId() {
        String sql = "SELECT MAX(product_id) FROM Products WHERE product_type = 'Component'";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception ex) {
            Logger.getLogger(ComponentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1;
    }
}
