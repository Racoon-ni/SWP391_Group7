/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;


import DAO.AttributeDAO;
import DAO.CategoryDAO;
import model.Attribute;
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

@WebServlet("/attribute-create")
public class AttributeCreateServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("attribute-create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String unit = request.getParameter("unit");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));

        Attribute attr = new Attribute();
        attr.setName(name);
        attr.setUnit(unit);
        attr.setCategoryId(categoryId);

        AttributeDAO dao = new AttributeDAO();
        dao.insertAttribute(attr);

        response.sendRedirect(request.getContextPath() + "/attributes");
    }
}