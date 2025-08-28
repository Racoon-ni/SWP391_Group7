package controller;

import DAO.PasswordResetTokenDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("token", req.getParameter("token"));
        req.getRequestDispatcher("WEB-INF/include/reset-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String newPassword = req.getParameter("password");

        boolean success = new PasswordResetTokenDAO().updatePasswordByToken(token, newPassword);

        if (success) req.setAttribute("message", "Đổi mật khẩu thành công! Hãy đăng nhập lại.");
        else req.setAttribute("error", "Token không hợp lệ hoặc đã hết hạn.");

        req.getRequestDispatcher("WEB-INF/include/reset-password.jsp").forward(req, resp);
    }
}
