/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;
import DAO.AttributeDAO;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 *
 * @author ThinhLVCE181726 <your.name at your.org>
 */

@WebServlet("/attribute-delete")
public class AttributeDeleteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        AttributeDAO dao = new AttributeDAO();
        dao.deleteAttribute(id);
        response.sendRedirect(request.getContextPath() + "/attributes");
    }
}