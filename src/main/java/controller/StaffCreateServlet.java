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
import DAO.UserDAO;
import model.User;

/**
 *
 * @author Admin
 */
@WebServlet(name = "StaffCreateServlet", urlPatterns = {"/StaffCreate"})
public class StaffCreateServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

    }

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
        request.getRequestDispatcher("/WEB-INF/include/staff-create.jsp").forward(request, response);
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
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");

        java.sql.Date dateOfBirth = null;
        try {
            if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
                dateOfBirth = java.sql.Date.valueOf(dateOfBirthStr); // yyyy-MM-dd
            }
        } catch (Exception e) {
            request.setAttribute("error", "Ngày sinh không hợp lệ.");
            request.getRequestDispatcher("/WEB-INF/include/staff-create.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setFullname(fullname);
        user.setDateOfBirth(dateOfBirth);
        user.setPhone(phone);
        user.setGender(gender);
        user.setAddress(address);
        user.setRole("Staff");
        user.setStatus(true);

        UserDAO dao = new UserDAO();

        // Kiểm tra username trùng
        if (dao.usernameExists(username)) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại. Vui lòng nhập tên khác.");
            request.getRequestDispatcher("/WEB-INF/include/staff-create.jsp").forward(request, response);
            return;
        }
        // Kiểm tra email trùng
        if (dao.emailExists(email)) {
            request.setAttribute("error", "Email đã tồn tại. Vui lòng nhập email khác.");
            request.getRequestDispatcher("/WEB-INF/include/staff-create.jsp").forward(request, response);
            return;
        }

        if (dao.addStaff(user) == 1) {
            // Gửi thông báo thành công qua query string (1 lần duy nhất)
            response.sendRedirect("StaffList?message=Thêm nhân viên thành công!");
        } else {
            request.setAttribute("error", "Lỗi thêm nhân viên.");
            request.getRequestDispatcher("/WEB-INF/include/staff-create.jsp").forward(request, response);
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
