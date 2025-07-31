/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

/**
 *
 * @author ThinhLVCE181726
 */
import config.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Product;

public class ProductDAO {

    private int pcId;

    // Lấy tất cả PC
    public List<Product> getAllPC() throws Exception {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE product_type = 'PC' AND status = 1";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

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
                p.setStatus(rs.getInt("status"));
                // Thêm rating
                p.setAvgStars(getAverageStars(p.getProductId()));
                p.setTotalRatings(getTotalRatings(p.getProductId()));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy sản phẩm bằng ID 
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
                product.setStatus(rs.getInt("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return product;
    }

    // Lấy sản phẩm theo Category ID
    public List<Product> getProductByCategoryId(int categoryId) throws SQLException, ClassNotFoundException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE category_id = ? AND status = 1";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("product_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getString("image_url"),
                        rs.getString("product_type"),
                        rs.getInt("category_id"),
                        rs.getInt("status")
                );
                p.setAvgStars(getAverageStars(p.getProductId()));
                p.setTotalRatings(getTotalRatings(p.getProductId()));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return list;
    }

    // Lấy tất cả linh kiện
    public List<Product> getAllComponents() throws ClassNotFoundException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products p JOIN Categories c ON p.category_id = c.category_id WHERE p.product_type = 'Component' AND p.status = 1";

        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

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
                        rs.getInt("status")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy sản phẩm theo tên category
    public List<Product> getProductsByCategory(String category) throws ClassNotFoundException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products p JOIN Categories c ON p.category_id = c.category_id WHERE c.name = ? AND p.status = 1";

        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("product_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getString("image_url"),
                        rs.getString("product_type"),
                        rs.getInt("category_id"),
                        rs.getInt("status")
                );
                setRatingInfoForProduct(p, conn);
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private void setRatingInfoForProduct(Product p, Connection conn) {
        String sql = "SELECT COUNT(*) as total, AVG(CAST(stars AS FLOAT)) as avg FROM Ratings WHERE product_id = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getProductId());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                p.setTotalRatings(rs.getInt("total"));
                p.setAvgStars(rs.getDouble("avg"));
            } else {
                p.setTotalRatings(0);
                p.setAvgStars(0);
            }
        } catch (SQLException ex) {
            p.setTotalRatings(0);
            p.setAvgStars(0);
        }
    }

    public double getAverageStars(int productId) {
        String sql = "SELECT AVG(stars) FROM Ratings WHERE product_id = ?";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalRatings(int productId) {
        String sql = "SELECT COUNT(*) FROM Ratings WHERE product_id = ?";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Product getProductDetail(int productId) throws SQLException, ClassNotFoundException {
        Product product = null;
        String sql = "SELECT * FROM Products WHERE product_id = ? AND status = 1";
        System.out.println("DEBUG: Executing getProductDetail with productId = " + productId);

        try ( Connection conn = DBConnect.connect()) {
            if (conn == null) {
                System.err.println("DEBUG: Connection is null");
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }
            System.out.println("DEBUG: Connection established");
            try ( PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, productId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    product = new Product();
                    product.setProductId(rs.getInt("product_id"));
                    product.setName(rs.getString("name") != null ? rs.getString("name") : "");
                    product.setDescription(rs.getString("description") != null ? rs.getString("description") : "");
                    product.setPrice(rs.getDouble("price"));
                    product.setStock(rs.getInt("stock"));
                    product.setImageUrl(rs.getString("image_url") != null ? rs.getString("image_url") : "");
                    product.setProductType(rs.getString("product_type") != null ? rs.getString("product_type") : "");
                    product.setCategoryId(rs.getInt("category_id"));
                    product.setStatus(rs.getInt("status"));
                    System.out.println("DEBUG: Product found - Name = " + product.getName());
                } else {
                    System.out.println("DEBUG: No product found for productId = " + productId);
                }
            }
        } catch (SQLException e) {
            System.err.println("DEBUG: SQLException in getProductDetail: " + e.getMessage());
            e.printStackTrace();
            throw e;
        } catch (Exception e) {
            System.err.println("DEBUG: Unexpected error in getProductDetail: " + e.getMessage());
            e.printStackTrace();
            throw new SQLException("Lỗi không xác định khi lấy chi tiết sản phẩm", e);
        }
        return product;
    }

    public Product getPCById(int pcId) throws Exception {
        String sql = "SELECT * FROM Products WHERE product_id = ? AND product_type = 'PC'";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pcId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product pc = new Product();
                pc.setProductId(rs.getInt("product_id"));
                pc.setName(rs.getString("name"));
                pc.setDescription(rs.getString("description"));
                pc.setPrice(rs.getDouble("price"));
                pc.setStock(rs.getInt("stock"));
                pc.setImageUrl(rs.getString("image_url"));
                return pc;
            }
        }
        return null;
    }

    public void sendNewProductNotification(String productName) {
        String message = "Sản phẩm mới \"" + productName + "\" đã được cập nhật!";
        NotificationDAO notiDAO = new NotificationDAO();
        String sql = "SELECT user_id FROM Users WHERE role = 'Customer'";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int userId = rs.getInt("user_id");
                notiDAO.sendNotification(userId, message, "Product");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Product> searchProducts(String keyword) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE status = 1 AND (name LIKE ? OR description LIKE ?)";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchValue = "%" + keyword + "%";
            ps.setString(1, searchValue);
            ps.setString(2, searchValue);
            ResultSet rs = ps.executeQuery();
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
                p.setStatus(rs.getInt("status"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> filterProducts(String categoryId, String priceRange) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Products WHERE status = 1");
        List<Object> params = new ArrayList<>();

        if (categoryId != null && !categoryId.isEmpty()) {
            sql.append(" AND category_id = ?");
            params.add(Integer.parseInt(categoryId));
        }
        if (priceRange != null && !priceRange.isEmpty()) {
            switch (priceRange) {
                case "1":
                    sql.append(" AND price < 2000000");
                    break;
                case "2":
                    sql.append(" AND price >= 2000000 AND price <= 5000000");
                    break;
                case "3":
                    sql.append(" AND price > 5000000 AND price <= 10000000");
                    break;
                case "4":
                    sql.append(" AND price > 10000000");
                    break;
            }
        }
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
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
                p.setStatus(rs.getInt("status"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countAllProducts() {
        String sql = "SELECT COUNT(*) FROM Products WHERE status=1";
        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Product> getProductsByPage(int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE status=1 ORDER BY product_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try ( Connection conn = DBConnect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                // set các trường cho p...
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getAllProducts() throws Exception {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products ";
        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

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
                p.setStatus(rs.getInt("status"));
                // Thêm rating
                p.setAvgStars(getAverageStars(p.getProductId()));
                p.setTotalRatings(getTotalRatings(p.getProductId()));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
