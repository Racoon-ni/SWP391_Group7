/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import config.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Attribute;
import model.ProductAttribute;

/**
 *
 * @author Huynh Trong Nguyen - CE190356
 */
public class ProductAttributeDAO {

    public ArrayList<ProductAttribute> getAttributeByProductId(int p_id) {
        ArrayList<ProductAttribute> pAttList = new ArrayList<>();
        String sql = "SELECT p.[attribute_id], a.name, [value] ,a.unit\n"
                + "FROM [ProductAttributes] p\n"
                + "JOIN Attributes a on a.attribute_id = p.attribute_id\n"
                + "WHERE p.product_id = ?";

        try (
                 PreparedStatement ps = DBConnect.prepareStatement(sql);) {
            ps.setInt(1, p_id);
            try ( ResultSet rs = ps.executeQuery();) {
                while (rs.next()) {
                    int id = rs.getInt("attribute_id");
                    String name = rs.getString("name");
                    String value = rs.getString("value");
                    String unit = rs.getString("unit");

                    Attribute a = new Attribute(id, name, id, unit, "");
                    ProductAttribute pAtt = new ProductAttribute(p_id, a, value);

                    pAttList.add(pAtt);
                }

            }
        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return pAttList;
    }

    public ArrayList<ProductAttribute> getAttributes(int c_id) {
        ArrayList<ProductAttribute> pAttList = new ArrayList<>();
        String sql = "SELECT [attribute_id], a.[name], [unit]\n"
                + "FROM [Attributes] a\n"
                + "JOIN Categories c on c.category_id = a.category_id\n"
                + "WHERE c.category_id = ? \n"
                + "ORDER BY a.attribute_id";

        try (
                 PreparedStatement ps = DBConnect.prepareStatement(sql);) {
            ps.setInt(1, c_id);
            try ( ResultSet rs = ps.executeQuery();) {
                while (rs.next()) {
                    int id = rs.getInt("attribute_id");
                    String name = rs.getString("name");
                    String unit = rs.getString("unit");

                    Attribute a = new Attribute(id, name, c_id, unit, "");
                    ProductAttribute pAtt = new ProductAttribute(0, a, "");

                    pAttList.add(pAtt);
                }

            }
        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return pAttList;
    }

    public Map<String, List<String>> getAttrValueOptions(int c_id) {
        Map<String, Set<String>> tempMap = new HashMap<>();
        Map<String, List<String>> attrValueOptions = new HashMap<>();

        String sql = "SELECT p.attribute_id, a.name, value, a.unit, p.product_id "
                + "FROM ProductAttributes p "
                + "JOIN Attributes a ON a.attribute_id = p.attribute_id "
                + "WHERE a.category_id = ? "
                + "ORDER BY a.attribute_id";

        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, c_id);  // set the category_id correctly

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String attrName = rs.getString("name");
                    String value = rs.getString("value");

                    tempMap.computeIfAbsent(attrName, k -> new HashSet<>()).add(value);
                }

                // Convert Set to List
                for (Map.Entry<String, Set<String>> entry : tempMap.entrySet()) {
                    attrValueOptions.put(entry.getKey(), new ArrayList<>(entry.getValue()));
                }

            } catch (Exception ex) {
                Logger.getLogger(ProductAttributeDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (Exception ex) {
            Logger.getLogger(ProductAttributeDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return attrValueOptions;
    }

    public void updateProductAttributeValue(int productId, int attributeId, String value) {
        String sql = "UPDATE ProductAttributes SET value = ? WHERE product_id = ? AND attribute_id = ?";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setString(1, value);
            ps.setInt(2, productId);
            ps.setInt(3, attributeId);
            ps.executeUpdate();
        } catch (Exception ex) {
            Logger.getLogger(ProductAttributeDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void addProductAttributeValue(int productId, int attributeId, String value) {
        String sql = "INSERT INTO ProductAttributes (product_id, attribute_id, value) VALUES (?, ?, ?)";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, attributeId);
            ps.setString(3, value);
            ps.executeUpdate();
        } catch (Exception ex) {
            Logger.getLogger(ProductAttributeDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public int delete(int id) {
        String deleteAttributesQuery = "DELETE FROM ProductAttributes WHERE product_id = ?";
        String deleteProductQuery = "DELETE FROM Products WHERE product_id = ?";

        try ( Connection conn = DBConnect.getConnection()) {
            conn.setAutoCommit(false); // Start transaction

            try (
                     PreparedStatement psAttr = conn.prepareStatement(deleteAttributesQuery);  PreparedStatement psProd = conn.prepareStatement(deleteProductQuery)) {
                psAttr.setInt(1, id);
                psAttr.executeUpdate(); // delete related attributes first

                psProd.setInt(1, id);
                int result = psProd.executeUpdate(); // now delete product

                conn.commit();
                return result;

            } catch (Exception e) {
                conn.rollback(); // rollback if any error
                Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, e);
                return 0;
            }
        } catch (Exception ex) {
            Logger.getLogger(pcDAO.class.getName()).log(Level.SEVERE, null, ex);
            return 0;
        }
    }

}
