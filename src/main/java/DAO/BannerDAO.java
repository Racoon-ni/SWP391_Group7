package DAO;

import config.DBConnect;
import model.Banner;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BannerDAO {

    public List<Banner> getAllBanners() {
        List<Banner> list = new ArrayList<>();
        String sql = "SELECT * FROM Banners ORDER BY banner_id ASC";

        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Banner b = new Banner();
                b.setBannerId(rs.getInt("banner_id"));
                b.setProductId(rs.getObject("product_id") == null ? 0 : rs.getInt("product_id"));
                b.setImageUrl(rs.getString("image_url"));
                b.setStatus(rs.getInt("status"));
                b.setCreatedAt(rs.getTimestamp("created_at"));
                b.setTargetUrl(rs.getString("target_url")); // ✅
                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Chỉ lấy banner đang hiển thị (dùng ở trang Home)
    public List<Banner> getAllActiveBanners() {
        List<Banner> list = new ArrayList<>();
        String sql = "SELECT * FROM Banners WHERE status = 1 ORDER BY banner_id ASC";

        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Banner b = new Banner();
                b.setBannerId(rs.getInt("banner_id"));
                b.setProductId(rs.getObject("product_id") == null ? 0 : rs.getInt("product_id"));
                b.setImageUrl(rs.getString("image_url"));
                b.setStatus(rs.getInt("status"));
                b.setCreatedAt(rs.getTimestamp("created_at"));
                b.setTargetUrl(rs.getString("target_url")); // ✅
                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Cập nhật trạng thái
    public boolean updateBannerStatus(Banner b) {
        String sql = "UPDATE Banners SET status = ? WHERE banner_id = ?";
        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, b.getStatus());
            ps.setInt(2, b.getBannerId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thêm mới banner (có product_id & target_url tuỳ chọn)
    public boolean insertBanner(Banner b) {
        String sql = "INSERT INTO Banners (product_id, image_url, status, target_url, created_at) " +
                     "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (b.getProductId() > 0) {
                ps.setInt(1, b.getProductId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }

            ps.setString(2, b.getImageUrl());
            ps.setInt(3, b.getStatus());

            if (b.getTargetUrl() != null && !b.getTargetUrl().trim().isEmpty()) {
                ps.setString(4, b.getTargetUrl().trim());
            } else {
                ps.setNull(4, Types.NVARCHAR);
            }

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
