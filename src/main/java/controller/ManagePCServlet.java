/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import model.PC;
import DAO.pcDAO;

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
            request.getRequestDispatcher("/WEB-INF/include/add-pc.jsp").forward(request, response);
        } else if (view.equalsIgnoreCase("edit")) {
            int id = Integer.parseInt(request.getParameter("id"));
            pcDAO p = new pcDAO();
            
            PC pc = p.getPCById(id);
            
            request.setAttribute("pc", pc);
            
            request.getRequestDispatcher("/WEB-INF/include/edit-pc.jsp").forward(request, response);
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
