/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import config.DBConnect;
import model.CustomPCBuild;
import model.CustomPCBuildDetail;
import model.Product;

import java.sql.*;
import java.util.*;

/**
 *
 * @author Long
 */
public class CustomPCBuildDAO {
    // Lưu build mới, trả về buildId

    public int createBuild(int userId, String name, double totalPrice, Map<String, Product> build) {
        int buildId = -1;
        Connection conn = null;
        PreparedStatement psBuild = null;
        PreparedStatement psDetail = null;
        ResultSet rs = null;
        try {
            conn = DBConnect.connect();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // 1. Insert CustomPCBuilds (lấy buildId mới)
            String sqlBuild = "INSERT INTO CustomPCBuilds (user_id, name, total_price, created_at) VALUES (?, ?, ?, GETDATE());";
            psBuild = conn.prepareStatement(sqlBuild, Statement.RETURN_GENERATED_KEYS);
            psBuild.setInt(1, userId);
            psBuild.setString(2, name);
            psBuild.setDouble(3, totalPrice);
            psBuild.executeUpdate();
            rs = psBuild.getGeneratedKeys();
            if (rs.next()) {
                buildId = rs.getInt(1);
            } else {
                conn.rollback();
                return -1;
            }

            // 2. Insert từng linh kiện vào CustomPCBuildDetails
            String sqlDetail = "INSERT INTO CustomPCBuildDetails (build_id, component_id, quantity) VALUES (?, ?, ?);";
            psDetail = conn.prepareStatement(sqlDetail);
            for (Product p : build.values()) {
                if (p != null) {
                    psDetail.setInt(1, buildId);
                    psDetail.setInt(2, p.getProductId());
                    psDetail.setInt(3, 1); // mặc định mỗi linh kiện 1
                    psDetail.addBatch();
                }
            }
            psDetail.executeBatch();

            conn.commit();
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ignored) {
            }
            e.printStackTrace();
            buildId = -1;
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception ignored) {
            }
            try {
                if (psDetail != null) {
                    psDetail.close();
                }
            } catch (Exception ignored) {
            }
            try {
                if (psBuild != null) {
                    psBuild.close();
                }
            } catch (Exception ignored) {
            }
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
                conn.close();
            } catch (Exception ignored) {
            }
        }
        return buildId;
    }

    // Lấy danh sách build theo user
    public List<CustomPCBuild> getBuildsByUser(int userId) {
        List<CustomPCBuild> list = new ArrayList<>();
        String sql = "SELECT * FROM CustomPCBuilds WHERE user_id = ?";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CustomPCBuild build = new CustomPCBuild();
                build.setBuildId(rs.getInt("build_id"));
                build.setUserId(rs.getInt("user_id"));
                build.setName(rs.getString("name"));
                build.setTotalPrice(rs.getDouble("total_price"));
                build.setCreatedAt(rs.getTimestamp("created_at"));
                build.setComponents(getBuildDetails(build.getBuildId())); // load detail luôn
                list.add(build);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy chi tiết từng build
    public List<CustomPCBuildDetail> getBuildDetails(int buildId) {
        List<CustomPCBuildDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM CustomPCBuildDetails WHERE build_id = ?";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, buildId);
            ResultSet rs = ps.executeQuery();
            ProductDAO productDAO = new ProductDAO();
            while (rs.next()) {
                CustomPCBuildDetail detail = new CustomPCBuildDetail();
                detail.setBuildId(buildId);
                detail.setComponentId(rs.getInt("component_id"));
                detail.setQuantity(rs.getInt("quantity"));
                // Lấy thông tin sản phẩm
                Product p = productDAO.getProductById(detail.getComponentId());
                detail.setProduct(p);
                list.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
