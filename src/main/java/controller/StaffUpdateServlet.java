/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import DAO.UserDAO;
import java.sql.Date;
import model.User;

/**
 *
 * @author Admin
 */
@WebServlet(name = "StaffUpdateServlet", urlPatterns = {"/StaffUpdate"})
public class StaffUpdateServlet extends HttpServlet {

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
        int id = Integer.parseInt(request.getParameter("id"));
        UserDAO dao = new UserDAO();
        User staff = dao.getUserById(id);
        if (staff == null || !"staff".equalsIgnoreCase(staff.getRole())) {
            response.sendError(404, "Không tìm thấy nhân viên.");
            return;
        }
        request.setAttribute("staff", staff);
        request.getRequestDispatcher("/WEB-INF/include/staff-update.jsp").forward(request, response);
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
        int id = Integer.parseInt(request.getParameter("id"));
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        boolean status = "on".equals(request.getParameter("status"));

        // Xử lý ngày sinh (có thể null)
        Date dateOfBirth = null;
        if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
            dateOfBirth = Date.valueOf(dateOfBirthStr); // yyyy-MM-dd
        }

        UserDAO dao = new UserDAO();
        User staff = dao.getUserById(id);
        if (staff == null || !"staff".equalsIgnoreCase(staff.getRole())) {
            response.sendError(404, "Không tìm thấy nhân viên.");
            return;
        }

        staff.setEmail(email);
        staff.setFullname(fullname);
        staff.setPhone(phone);
        staff.setGender(gender);
        staff.setAddress(address);
        staff.setDateOfBirth(dateOfBirth);
        staff.setStatus(status);

        dao.updateStaff(staff);

        // Sau khi cập nhật thành công, chuyển về danh sách với message
        response.sendRedirect("StaffList?message=Cập nhật nhân viên thành công!");
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
