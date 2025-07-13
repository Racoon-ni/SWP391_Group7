
// === CustomerChangePasswordServlet.java ===
package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import DAO.CustomerDAO;
import model.Customer;
import model.User;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/change-password")
public class CustomerChangePasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/include/customer-change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        List<String> errors = new ArrayList<>();

        String oldPassword = req.getParameter("oldPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (!CustomerDAO.checkOldPassword(user.getId(), oldPassword)) {
            errors.add("Mật khẩu cũ không đúng.");
        }

        String regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{6,20}$";
        if (!newPassword.matches(regex)) {
            errors.add("Mật khẩu mới phải từ 6-8 ký tự, gồm chữ hoa, chữ thường và số.");
        }

        if (!newPassword.equals(confirmPassword)) {
            errors.add("Xác nhận mật khẩu không khớp.");
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            Customer customer = new CustomerDAO().getCustomerById(user.getId());
            req.setAttribute("customer", customer);
            req.getRequestDispatcher("/WEB-INF/include/customer-view-profile.jsp").forward(req, resp);
            return;
        }

        boolean success = CustomerDAO.updatePassword(user.getId(), newPassword);
        if (success) {
            resp.sendRedirect("view-profile?passwordChange=success");
        } else {
            resp.sendRedirect("view-profile?passwordChange=error");
        }
    }
}
