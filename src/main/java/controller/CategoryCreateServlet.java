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

@WebServlet("/category-create")
public class CategoryCreateServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách thể loại để chọn làm parent (tùy chọn)
        CategoriesDAO dao = new CategoriesDAO();
        List<Category> categories = dao.getAllCategories();
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("category-create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String categoryType = request.getParameter("categoryType");
        String parentIdStr = request.getParameter("parentId");

        Category cat = new Category();
        cat.setName(name);
        cat.setCategoryType(categoryType);
        if (parentIdStr != null && !parentIdStr.isEmpty()) {
            cat.setParentId(Integer.parseInt(parentIdStr));
        } else {
            cat.setParentId(null);
        }

        CategoriesDAO dao = new CategoriesDAO();
        dao.insertCategory(cat);

        response.sendRedirect(request.getContextPath() + "/categories");
    }
}