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
import model.User;
import java.util.ArrayList;

/**
 *
 * @author Admin
 */
@WebServlet(name = "StaffDeleteServlet", urlPatterns = {"/StaffDelete"})
public class StaffDeleteServlet extends HttpServlet {

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
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            UserDAO dao = new UserDAO();
            ArrayList<User> userList = dao.getAllUser();
            User staff = null;
            for (User u : userList) {
                if (u.getId() == id && "staff".equalsIgnoreCase(u.getRole())) {
                    staff = u;
                    break;
                }
            }
            if (staff == null) {
                // Không tìm thấy -> chuyển về danh sách kèm thông báo lỗi
                response.sendRedirect("StaffList?error=Không tìm thấy nhân viên hoặc bạn không có quyền xoá.");
                return;
            }
            // Xóa mềm
            staff.setStatus(false);
            dao.deleteUser(id);

            // Xóa thành công, chuyển hướng về danh sách kèm thông báo thành công
            response.sendRedirect("StaffList?message=Đã xoá nhân viên thành công!");
        } catch (Exception e) {
            // Có lỗi bất ngờ
            response.sendRedirect("StaffList?error=Xoá nhân viên thất bại.");
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
        processRequest(request, response);
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
