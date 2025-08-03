/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.ProductDAO;
import model.Product;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;
/**
 *
 * @author ThinhLVCE181726 <your.name at your.org>
 */

@WebServlet("/search")
public class SearchProductServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        System.out.println("Search keyword: " + keyword); // Test log

        ProductDAO productDAO = new ProductDAO();
        List<Product> resultList = productDAO.searchProducts(keyword);

        System.out.println("Search result size: " + resultList.size()); // Test log

        request.setAttribute("products", resultList);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("search-result.jsp").forward(request, response);
    }
}
