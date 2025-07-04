/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 *
 * @author Huynh Trong Nguyen - CE190356
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

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
        request.getRequestDispatcher("WEB-INF/include/login.jsp").forward(request, response);
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
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        HttpSession session = request.getSession(false);

        UserDAO uDAO = new UserDAO();

        User user = uDAO.getUser(username, password);
        if (user == null) {
           request.setAttribute("error", "Sai tài khoản hoặc mật khẩu");
                request.getRequestDispatcher("/WEB-INF/include/login.jsp").forward(request, response);
        } else {
            session.setAttribute("user", user);

            if (uDAO.login(user) && user.getRole().equalsIgnoreCase("Customer")) {
                
                request.setAttribute("success", "Đăng nhập thành công");
                session.setAttribute("logged", true);
                request.getRequestDispatcher("/home.jsp").forward(request, response);
                
            } else if (uDAO.login(user) && (user.getRole().equalsIgnoreCase("Admin")
                    || user.getRole().equalsIgnoreCase("Staff"))) {
                
                request.setAttribute("success", "Đăng nhập thành công");
                session.setAttribute("logged", true);
                request.getRequestDispatcher("/dash-board.jsp").forward(request, response);
                
            } else {
                request.setAttribute("error", "Sai tài khoản hoặc mật khẩu");
                request.getRequestDispatcher("/WEB-INF/include/login.jsp").forward(request, response);
            }

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
