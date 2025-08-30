/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import DAO.UserDAO;
import model.User;
import utils.ValidationUtils;

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
        String dobStr = request.getParameter("dateOfBirth");
        String phoneRaw = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");

        String phone = ValidationUtils.normalizePhoneVN(phoneRaw);

        Date dobSql = null;
        try {
            if (dobStr != null && !dobStr.isEmpty()) {
                dobSql = Date.valueOf(dobStr);
            }
        } catch (Exception e) {
            // sẽ gắn lỗi ở errors
        }

        Map<String, String> errors = new HashMap<>();
        UserDAO dao = new UserDAO();

        // Required
        if (username == null || username.trim().isEmpty()) {
            errors.put("username", "Bắt buộc.");
        }
        if (password == null || password.trim().isEmpty()) {
            errors.put("password", "Bắt buộc.");
        }

        // Email
        if (!ValidationUtils.isValidEmail(email)) {
            errors.put("email", "Email không hợp lệ.");
        } else if (dao.emailExists(email)) {
            errors.put("email", "Email đã tồn tại.");
        }

        // Fullname
        if (!ValidationUtils.isValidFullname(fullname)) {
            errors.put("fullname", "Họ tên không chứa số/ký tự đặc biệt.");
        }

        // DOB & 18+
        if (dobSql == null) {
            errors.put("dateOfBirth", "Ngày sinh không hợp lệ.");
        } else if (!ValidationUtils.isAdult(dobSql.toLocalDate())) {
            errors.put("dateOfBirth", "Nhân viên phải từ 18 tuổi.");
        }

        // Phone VN + unique (nếu nhập)
        if (!ValidationUtils.isValidVNPhoneOrEmpty(phone)) {
            errors.put("phone", "SĐT phải là số di động VN hợp lệ (03/05/07/08/09 + 8 số).");
        } else if (phone != null && !phone.isEmpty() && dao.phoneExists(phone)) {
            errors.put("phone", "SĐT đã tồn tại.");
        }

        // Username unique
        if (dao.usernameExists(username)) {
            errors.put("username", "Tên đăng nhập đã tồn tại.");
        }

        if (!errors.isEmpty()) {
            User form = new User();
            form.setUsername(username);
            form.setPassword(password);
            form.setEmail(email);
            form.setFullname(fullname);
            form.setDateOfBirth(dobSql);
            form.setPhone(phone);
            form.setGender(gender);
            form.setAddress(address);
            form.setRole("Staff");
            form.setStatus(true);

            request.setAttribute("errors", errors);
            request.setAttribute("formData", form);
            request.getRequestDispatcher("/WEB-INF/include/staff-create.jsp").forward(request, response);
            return;
        }

        // Create Staff account
        User user = new User(0, username, password, email, fullname, dobSql, address, phone, gender, "Staff", true);
        if (dao.addStaff(user) == 1) {
            response.sendRedirect("StaffList?message=Thêm nhân viên & tạo account Staff thành công!");
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
