/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CategoryDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import model.PC;
import DAO.pcDAO;
import model.Category;

/**
 *
 * @author Huynh Trong Nguyen - CE190356
 */
@WebServlet(name = "ManagePCServlet", urlPatterns = {"/manage-pc"})
public class ManagePCServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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

            pcDAO p = new pcDAO();

            ArrayList<PC> pcList = p.getAllPCs();

            request.setAttribute("pcList", pcList);

            request.getRequestDispatcher("/WEB-INF/include/pc-list.jsp").forward(request, response);

        } else if (view.equalsIgnoreCase("add")) {
            CategoryDAO c = new CategoryDAO();
            ArrayList<Category> cateList = c.getAllCategories();

            request.setAttribute("cateList", cateList);

            request.getRequestDispatcher("/WEB-INF/include/add-pc.jsp").forward(request, response);
        } else if (view.equalsIgnoreCase("edit")) {
            int id = Integer.parseInt(request.getParameter("id"));
            pcDAO p = new pcDAO();
            CategoryDAO c = new CategoryDAO();

            PC pc = p.getPCById(id);
            ArrayList<Category> cateList = c.getAllCategories();

            request.setAttribute("pc", pc);
            request.setAttribute("cateList", cateList);

            request.getRequestDispatcher("/WEB-INF/include/edit-pc.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/include/pc-list.jsp").forward(request, response);
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
        pcDAO p = new pcDAO();
        CategoryDAO c = new CategoryDAO();
        if (act != null) {
            switch (act) {
                case "create": // not validate yet
                    String name = request.getParameter("name");
                    String description = request.getParameter("description");
                    double price = Double.parseDouble(request.getParameter("price"));
                    int stock = Integer.parseInt(request.getParameter("stock"));
                    int cateId = Integer.parseInt(request.getParameter("cateId"));

                    if (p.addPC(new PC(0, name, description, price, stock, "", c.getCategoryById(cateId), true)) == 1) {
                        response.sendRedirect(request.getContextPath() + "/manage-pc");
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

                    if (p.updatePC(new PC(id, name, description, price, stock, "", c.getCategoryById(cateId), status)) == 1) {
                        response.sendRedirect(request.getContextPath() + "/manage-pc");
                    }

                    break;
                case "delete": // not validate yet
                    id = Integer.parseInt(request.getParameter("id"));

                    if (p.delete(id) == 1) {
                        response.sendRedirect(request.getContextPath() + "/manage-pc");
                    }

                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/manage-pc");
                    break;
            }

        } else {
            response.sendRedirect(request.getContextPath() + "/manage-pc");
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
