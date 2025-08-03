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

@WebServlet("/categories")
public class CategoryListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check quyền admin ở đây nếu muốn
        HttpSession session = request.getSession(false);
        model.User user = (model.User) session.getAttribute("user");
        if (user == null || !"Admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CategoriesDAO dao = new CategoriesDAO();
        List<Category> categories = dao.getAllCategories();
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("category-list.jsp").forward(request, response);
    }
}