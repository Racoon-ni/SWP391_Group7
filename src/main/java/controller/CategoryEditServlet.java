/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;


import DAO.CategoriesDAO;
import model.Category;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author ThinhLVCE181726 <your.name at your.org>
 */
@WebServlet("/category-edit")
public class CategoryEditServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        CategoriesDAO dao = new CategoriesDAO();
        Category category = dao.getCategoryById(id);
        List<Category> categories = dao.getAllCategories();

        request.setAttribute("category", category);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("category-edit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String categoryType = request.getParameter("categoryType");
        String parentIdStr = request.getParameter("parentId");

        Category cat = new Category();
        cat.setCategoryId(id);
        cat.setName(name);
        cat.setCategoryType(categoryType);
        if (parentIdStr != null && !parentIdStr.isEmpty()) {
            cat.setParentId(Integer.parseInt(parentIdStr));
        } else {
            cat.setParentId(null);
        }

        CategoriesDAO dao = new CategoriesDAO();
        dao.updateCategory(cat);

        response.sendRedirect(request.getContextPath() + "/categories");
    }
}
