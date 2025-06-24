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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Product;
import java.sql.*;
import java.util.*;

public class ProductDAO {

    public List<Product> getAllPCs() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE product_type = 'PC' AND status = 1";
        try (
                 Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery();) {
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

    // lấy sản phẩm bằng ID 
    public Product getProductById(int productId) {
        Product product = null;
        String sql = "SELECT * FROM Products WHERE product_id = ?";
        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                product = new Product();
                product.setProductId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setImageUrl(rs.getString("image_url"));
                product.setProductType(rs.getString("product_type"));
                product.setCategoryId(rs.getInt("category_id"));
                product.setStatus(rs.getBoolean("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return product;
    }

    public List<Product> getProductByCategoryId(int categoryId) throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE category_id = ? AND status = 1";

        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new Product(
                        rs.getInt("product_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getString("image_url"),
                        rs.getString("product_type"),
                        rs.getInt("category_id"),
                        rs.getBoolean("status")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e; // Ném lại ngoại lệ để servlet xử lý
        }

        return list;
    }
   // Lấy tất cả các linh kiện
    public List<Product> getAllComponents() throws ClassNotFoundException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products p JOIN Categories c ON p.category_id = c.category_id WHERE p.product_type = 'Component' AND p.status = 1";
        
        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                list.add(new Product(
                    rs.getInt("product_id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("stock"),
                    rs.getString("image_url"),
                    rs.getString("product_type"),
                    rs.getInt("category_id"),
                    rs.getBoolean("status")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy sản phẩm theo category (ví dụ: RAM, CPU, Series)
    public List<Product> getProductsByCategory(String category) throws ClassNotFoundException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products p JOIN Categories c ON p.category_id = c.category_id WHERE c.name = ? AND p.status = 1";

        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);  // Set category name (RAM, CPU, etc.)
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new Product(
                    rs.getInt("product_id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("stock"),
                    rs.getString("image_url"),
                    rs.getString("product_type"),
                    rs.getInt("category_id"),
                    rs.getBoolean("status")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    }

   
    

