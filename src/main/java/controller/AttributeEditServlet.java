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

@WebServlet("/attribute-edit")
public class AttributeEditServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        AttributeDAO dao = new AttributeDAO();
        Attribute attribute = dao.getAttributeById(id);

        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("attribute", attribute);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("attribute-edit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String unit = request.getParameter("unit");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));

        Attribute attr = new Attribute();
        attr.setAttributeId(id);
        attr.setName(name);
        attr.setUnit(unit);
        attr.setCategoryId(categoryId);

        AttributeDAO dao = new AttributeDAO();
        dao.updateAttribute(attr);

        response.sendRedirect(request.getContextPath() + "/attributes");
    }
}