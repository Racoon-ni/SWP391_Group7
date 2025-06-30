package controller;


import DAO.ProductDAO;
import DAO.VoucherDAO;
import DAO.RatingDAO;             // Thêm dòng này
import model.Product;
import model.Rating;             // Thêm dòng này
import java.util.List;           // Thêm dòng này

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Product;
import model.Voucher;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {
    
    private ProductDAO productDAO = new ProductDAO();
    private RatingDAO ratingDAO = new RatingDAO();    // Thêm dòng này

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("id"));  // Lấy ID từ URL
        
        // Lấy sản phẩm từ DB theo ID
        Product product = productDAO.getProductById(productId);
         VoucherDAO dao = new VoucherDAO();
        List<Voucher> vouchers = dao.getAllVouchers();
        request.setAttribute("vouchers", vouchers);
        
        // Lấy tất cả đánh giá sản phẩm
        List<Rating> ratings = ratingDAO.getRatingsByProductId(productId);

        // Nếu tìm thấy sản phẩm, forward đến JSP
        if (product != null) {
            request.setAttribute("product", product);
            request.setAttribute("ratings", ratings);   // Đưa ratings xuống jsp
            request.getRequestDispatcher("/product-detail.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sản phẩm không tồn tại");
        }
    }
}
