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
import model.Product;
import java.sql.*;
import java.util.*;

public class ProductDAO {
    public List<Product> getAllPCs() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE product_type = 'PC' AND status = 1";
        try (
            Connection conn = DBConnect.connect();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
        ) {
            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setStock(rs.getInt("stock"));
                p.setImageUrl(rs.getString("image_url"));
                p.setProductType(rs.getString("product_type"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setStatus(rs.getBoolean("status"));
                list.add(p);
            }
            System.out.println("DEBUG: Số lượng PC lấy được: " + list.size());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}