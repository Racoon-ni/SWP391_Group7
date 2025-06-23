/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.ProductDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;

/**
 *
 * @author NghiLTTCE182357
 */
@WebServlet(name = "ViewComponentDetailServlet", urlPatterns = {"/ViewComponentDetail"})
public class ViewComponentDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy categoryId từ tham số URL
            int categoryId = Integer.parseInt(request.getParameter("id"));
            System.out.println("DEBUG: categoryId = " + categoryId);

            // Gọi DAO để lấy danh sách sản phẩm
            ProductDAO productDAO = new ProductDAO();
            List<Product> products = productDAO.getProductByCategoryId(categoryId);
            System.out.println("DEBUG: Số sản phẩm = " + products.size());

            // Đặt danh sách sản phẩm vào request attribute
            request.setAttribute("productList", products);
            request.setAttribute("categoryId", categoryId); // Lưu categoryId để sử dụng nếu cần

            // Chuyển tiếp đến JSP
            request.getRequestDispatcher("/WEB-INF/include/viewComponentDetail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            System.err.println("ID danh mục không hợp lệ: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID danh mục không hợp lệ.");
        } catch (Exception e) {
            System.err.println("Lỗi trong ViewComponentDetailServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể lấy sản phẩm.");
        }
    }
}