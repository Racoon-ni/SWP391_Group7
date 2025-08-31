/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.AttributeDAO;
import model.Attribute;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author ThinhLVCE181726 <your.name at your.org>
 */

@WebServlet("/attributes")
public class AttributeListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check quyền admin nếu muốn
        HttpSession session = request.getSession(false);
        model.User user = (model.User) session.getAttribute("user");
        if (user == null || !"Admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        AttributeDAO attrDao = new AttributeDAO();
        DAO.CategoriesDAO catDao = new DAO.CategoriesDAO();

        String categoryIdParam = request.getParameter("categoryId");
        List<model.Attribute> attributes;
        if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            int categoryId = Integer.parseInt(categoryIdParam);
            attributes = attrDao.getAttributesByCategory(categoryId);
            request.setAttribute("selectedCategoryId", categoryId);
        } else {
            attributes = attrDao.getAllAttributes();
        }

        List<model.Category> categories = catDao.getAllCategories();

        request.setAttribute("attributes", attributes);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("attribute-list.jsp").forward(request, response);
    }
}
