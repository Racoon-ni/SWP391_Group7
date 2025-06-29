package controller;

import DAO.ProductDAO;
import DAO.RatingDAO;   // <-- Thêm dòng này
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;   // <-- Thêm dòng này
import model.Product;
import model.Rating;    // <-- Thêm dòng này

@WebServlet(name = "ViewComponentDetailServlet", urlPatterns = {"/ViewComponentDetail"})
public class ViewComponentDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy productId từ tham số URL
            int productId = Integer.parseInt(request.getParameter("productId"));
            System.out.println("DEBUG: productId = " + productId);

            // Gọi DAO để lấy sản phẩm
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductDetail(productId);
            System.out.println("DEBUG: Product = " + (product != null ? product.getName() : "null"));

            if (product == null) {
                System.out.println("DEBUG: Product not found for productId = " + productId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm.");
                return;
            }

            // LẤY DANH SÁCH ĐÁNH GIÁ
            RatingDAO ratingDAO = new RatingDAO();
            List<Rating> ratingList = ratingDAO.getRatingsByProductId(productId);
            request.setAttribute("ratingList", ratingList); // <-- Gửi sang JSP

            // Đặt sản phẩm vào request attribute
            request.setAttribute("product", product);

            // Chuyển tiếp đến JSP
            System.out.println("DEBUG: Forwarding to viewComponentDetail.jsp");
            request.getRequestDispatcher("/WEB-INF/include/viewComponentDetail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            System.err.println("DEBUG: Invalid productId format: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sản phẩm không hợp lệ.");
        } catch (SQLException e) {
            System.err.println("DEBUG: SQLException in ViewComponentDetailServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi cơ sở dữ liệu: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("DEBUG: Unexpected error in ViewComponentDetailServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể lấy chi tiết sản phẩm: " + e.getMessage());
        }
    }
}
