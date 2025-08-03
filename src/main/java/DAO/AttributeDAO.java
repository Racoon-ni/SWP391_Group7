/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

/**
 *
 * @author ThinhLVCE181726 <your.name at your.org>
 */

import config.DBConnect;
import model.Attribute;
import java.sql.*;
import java.util.*;

public class AttributeDAO {
    public List<Attribute> getAllAttributes() {
        List<Attribute> list = new ArrayList<>();
        String sql = "SELECT a.attribute_id, a.name, a.unit, a.category_id, c.name AS category_name " +
                     "FROM Attributes a JOIN Categories c ON a.category_id = c.category_id";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Attribute attr = new Attribute();
                attr.setAttributeId(rs.getInt("attribute_id"));
                attr.setName(rs.getString("name"));
                attr.setCategoryId(rs.getInt("category_id"));
                attr.setUnit(rs.getString("unit"));
                attr.setCategoryName(rs.getString("category_name"));
                list.add(attr);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Attribute getAttributeById(int id) {
        String sql = "SELECT a.attribute_id, a.name, a.unit, a.category_id, c.name AS category_name " +
                     "FROM Attributes a JOIN Categories c ON a.category_id = c.category_id " +
                     "WHERE a.attribute_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Attribute attr = new Attribute();
                attr.setAttributeId(rs.getInt("attribute_id"));
                attr.setName(rs.getString("name"));
                attr.setCategoryId(rs.getInt("category_id"));
                attr.setUnit(rs.getString("unit"));
                attr.setCategoryName(rs.getString("category_name"));
                return attr;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public void insertAttribute(Attribute attr) {
        String sql = "INSERT INTO Attributes (name, category_id, unit) VALUES (?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, attr.getName());
            ps.setInt(2, attr.getCategoryId());
            ps.setString(3, attr.getUnit());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void updateAttribute(Attribute attr) {
        String sql = "UPDATE Attributes SET name=?, category_id=?, unit=? WHERE attribute_id=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, attr.getName());
            ps.setInt(2, attr.getCategoryId());
            ps.setString(3, attr.getUnit());
            ps.setInt(4, attr.getAttributeId());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void deleteAttribute(int attributeId) {
        String sql = "DELETE FROM Attributes WHERE attribute_id=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attributeId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
