/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.UserDAO;
import DAO.orderDAO;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.OrderDetail;

import model.User;

/**
 *
 * @author Huynh Trong Nguyen - CE190356
 */
@WebServlet(name = "ManageUserServlet", urlPatterns = {"/manage-user"})
public class ManageUserServlet extends HttpServlet {

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

            UserDAO uDAO = new UserDAO();

            ArrayList<User> userList = uDAO.getAllUser();

            request.setAttribute("userList", userList);

            request.getRequestDispatcher("/WEB-INF/include/user-list.jsp").forward(request, response);

        } else if (view.equalsIgnoreCase("edit")) {
            int id = Integer.parseInt(request.getParameter("id"));
            UserDAO uDAO = new UserDAO();

            User user = uDAO.getUserById(id);

            request.setAttribute("user", user);

            request.getRequestDispatcher("/WEB-INF/include/edit-user.jsp").forward(request, response);
        } else if (view.equalsIgnoreCase("details")) {
            int id = Integer.parseInt(request.getParameter("id"));
            UserDAO uDAO = new UserDAO();
            orderDAO dao = new orderDAO();
            
            User user = uDAO.getUserById(id);
            List<OrderDetail> orderDetails = dao.getOrderDetailsByUserId(id);
            
            request.setAttribute("user", user);
            request.setAttribute("orderDetails", orderDetails);
            request.getRequestDispatcher("/WEB-INF/include/user-details.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/include/user-list.jsp").forward(request, response);
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
        UserDAO uDAO = new UserDAO();
        if (act != null) {
            switch (act) {
                case "edit": // not validate yetư
                    int id = Integer.parseInt(request.getParameter("id"));
                    String role = request.getParameter("role");
                    boolean status = Boolean.parseBoolean(request.getParameter("status"));
                    Date d = new Date();

                    if (uDAO.updateUser(new User(id, "", "", "", "", d, "", "", "", role, status)) == 1) {
                        response.sendRedirect(request.getContextPath() + "/manage-user");
                    }

                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/manage-user");
                    break;
            }

        } else {
            response.sendRedirect(request.getContextPath() + "/manage-user");
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
