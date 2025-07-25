/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CategoryDAO;
import DAO.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import model.Product;

/**
 *
 * @author ThinhLVCE181726 <your.name at your.org>
 */
@WebServlet("/filter")
public class FilterProductServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String categoryId = request.getParameter("categoryId");
        String priceRange = request.getParameter("priceRange");

        // Lấy list category cho filter dropdown
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);

        // Lấy sản phẩm đã lọc
        ProductDAO productDAO = new ProductDAO();
        List<Product> filteredList = productDAO.filterProducts(categoryId, priceRange);
        request.setAttribute("products", filteredList);

        request.getRequestDispatcher("filter-result.jsp").forward(request, response);
    }
}
