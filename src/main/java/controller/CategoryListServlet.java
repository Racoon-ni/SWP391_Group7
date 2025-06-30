/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CategoryDAO;
import model.Category;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
/**
 *
 * @author ThinhLVCE181726 <your.name at your.org>
 */
@WebServlet(name = "CategoryListServlet", urlPatterns = {"/categories"})
public class CategoryListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
        CategoryDAO dao = new CategoryDAO();
        List<Category> categories = dao.getAllCategories();
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/WEB-INF/include/categories.jsp").forward(req, resp);
    }
}