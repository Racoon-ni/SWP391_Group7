package DAO;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author ADMIN
 */
import config.DBConnect;
import model.Banner;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BannerDAO {

    public List<Banner> getAllBanners() {
        List<Banner> list = new ArrayList<>();
        String sql = "SELECT * FROM Banners ORDER BY banner_id ASC";

        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Banner b = new Banner();
                b.setBannerId(rs.getInt("banner_id"));
                b.setProductId(rs.getInt("product_id"));
                b.setImageUrl(rs.getString("image_url"));
                b.setStatus(rs.getInt("status"));
                b.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // New method to get only active banners for home page display
    public List<Banner> getAllActiveBanners() {
        List<Banner> list = new ArrayList<>();
        String sql = "SELECT * FROM Banners WHERE status = 1 ORDER BY banner_id ASC";

        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Banner b = new Banner();
                b.setBannerId(rs.getInt("banner_id"));
                b.setProductId(rs.getInt("product_id"));
                b.setImageUrl(rs.getString("image_url"));
                b.setStatus(rs.getInt("status"));
                b.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Updated method to only update status
    public boolean updateBannerStatus(Banner b) {
        String sql = "UPDATE Banners SET status = ? WHERE banner_id = ?";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, b.getStatus());
            ps.setInt(2, b.getBannerId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // New method to insert banner
    public boolean insertBanner(Banner b) {
        String sql = "INSERT INTO Banners (image_url, status, created_at) VALUES (?, ?, CURRENT_TIMESTAMP)";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, b.getImageUrl());
            ps.setInt(2, b.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
