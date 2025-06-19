package controller;

import DAO.ProductDAO;
import model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/view-products")
public class ProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tạo đối tượng ProductDAO để lấy dữ liệu sản phẩm
        ProductDAO dao = new ProductDAO();
        ArrayList<Product> products = dao.getAllProducts();

        // Đưa danh sách sản phẩm vào request attribute
        request.setAttribute("products", products);

        // Chuyển tiếp tới JSP để hiển thị
        request.getRequestDispatcher("view/products.jsp").forward(request, response);
    }
}
