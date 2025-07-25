/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CategoryDAO;
import DAO.ComponentDAO;
import DAO.NotificationDAO;
import DAO.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import model.Category;
import model.Component;

/**
 *
 * @author Huynh Trong Nguyen - CE190356
 */
@WebServlet(name = "ManageComponentServlet", urlPatterns = {"/manage-component"})
public class ManageComponentServlet extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String view = request.getParameter("view");

        if (view == null || view.isEmpty() || view.equalsIgnoreCase("list")) {

            ComponentDAO comp = new ComponentDAO();
            CategoryDAO c = new CategoryDAO();

            ArrayList<Component> componentList;
            String cateId = request.getParameter("cateId");

            if (cateId == null || cateId.isEmpty()) {
                componentList = comp.getAllComponents(null);
            } else {
                componentList = comp.getAllComponents(cateId);
            }

            ArrayList<Category> cateList = c.getAllCategories();

            request.setAttribute("cateList", cateList);
            request.setAttribute("componentList", componentList);

            request.getRequestDispatcher("/WEB-INF/include/component-list.jsp").forward(request, response);

        } else if (view.equalsIgnoreCase("add")) {
            CategoryDAO c = new CategoryDAO();
            ArrayList<Category> cateList = c.getAllCategories();

            request.setAttribute("cateList", cateList);

            request.getRequestDispatcher("/WEB-INF/include/add-component.jsp").forward(request, response);
        } else if (view.equalsIgnoreCase("edit")) {
            int id = Integer.parseInt(request.getParameter("id"));
            ComponentDAO compDAO = new ComponentDAO();
            CategoryDAO c = new CategoryDAO();

            Component comp = compDAO.getComponentById(id);
            ArrayList<Category> cateList = c.getAllCategories();

            request.setAttribute("comp", comp);
            request.setAttribute("cateList", cateList);

            request.getRequestDispatcher("/WEB-INF/include/edit-component.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/include/component-list.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String act = request.getParameter("action");
        ComponentDAO comp = new ComponentDAO();
        CategoryDAO c = new CategoryDAO();
        if (act != null) {
            switch (act) {
                case "create":
                    String name = request.getParameter("name");
                    String description = request.getParameter("description");
                    double price = Double.parseDouble(request.getParameter("price"));
                    int stock = Integer.parseInt(request.getParameter("stock"));
                    int cateId = Integer.parseInt(request.getParameter("cateId"));

                    Component newComponent = new Component(0, name, description, price, stock, "", c.getCategoryById(cateId), true);
                    if (comp.addComponent(newComponent) == 1) {
                        int newId = comp.getLastInsertedComponentId();
                        new NotificationDAO().sendProductUpdateToAllUsers(name, "component", newId);

                        response.sendRedirect(request.getContextPath() + "/manage-component");
                    }
                    break;

                case "edit": // not validate yetư
                    int id = Integer.parseInt(request.getParameter("id"));
                    name = request.getParameter("name");
                    description = request.getParameter("description");
                    price = Double.parseDouble(request.getParameter("price"));
                    stock = Integer.parseInt(request.getParameter("stock"));
                    cateId = Integer.parseInt(request.getParameter("cateId"));
                    Boolean status = Boolean.parseBoolean(request.getParameter("status"));

                    if (comp.updateComponent(new Component(id, name, description, price, stock, "", c.getCategoryById(cateId), status)) == 1) {
                        response.sendRedirect(request.getContextPath() + "/manage-component");
                    }

                    break;
                case "delete": // not validate yet
                    id = Integer.parseInt(request.getParameter("id"));

                    if (comp.delete(id) == 1) {
                        response.sendRedirect(request.getContextPath() + "/manage-component");
                    }

                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/manage-component");
                    break;
            }

        } else {
            response.sendRedirect(request.getContextPath() + "/manage-component");
        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
