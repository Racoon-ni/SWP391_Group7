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

        PasswordResetTokenDAO p = new PasswordResetTokenDAO();
        String token = req.getParameter("token");

        if (p.getToken(token) == null || token.isEmpty()) {
           req.setAttribute("error", "token không tồn tại hoặc đã hết hạn!");
            req.getRequestDispatcher("WEB-INF/include/forgot-password.jsp").forward(req, resp);
        } else {
            req.setAttribute("token", token);
            req.getRequestDispatcher("WEB-INF/include/reset-password.jsp").forward(req, resp);
        }

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String newPassword = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        // Validate mật khẩu
        if (newPassword == null || confirmPassword == null
                || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ mật khẩu và xác nhận mật khẩu.");
            req.getRequestDispatcher("WEB-INF/include/reset-password.jsp").forward(req, resp);
            return;
        }

        // Không được chứa khoảng trắng
        if (newPassword.contains(" ")) {
            req.setAttribute("error", "Mật khẩu không được chứa khoảng trắng.");
            req.getRequestDispatcher("WEB-INF/include/reset-password.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra độ dài
        if (newPassword.length() < 8) {
            req.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự.");
            req.getRequestDispatcher("WEB-INF/include/reset-password.jsp").forward(req, resp);
            return;
        }

        // Regex: ít nhất 1 chữ hoa, 1 chữ thường và 1 chữ số
        String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$";
        if (!newPassword.matches(passwordRegex)) {
            req.setAttribute("error", "Mật khẩu phải chứa ít nhất 1 chữ hoa, 1 chữ thường và 1 chữ số.");
            req.getRequestDispatcher("WEB-INF/include/reset-password.jsp").forward(req, resp);
            return;
        }

        // Xác nhận mật khẩu nhập lại
        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu nhập lại không khớp.");
            req.getRequestDispatcher("WEB-INF/include/reset-password.jsp").forward(req, resp);
            return;
        }

        // Logic cũ - update mật khẩu bằng token
        boolean success = new PasswordResetTokenDAO().updatePasswordByToken(token, newPassword);

        if (success) {
            req.setAttribute("message", "Đổi mật khẩu thành công! Hãy đăng nhập lại.");
        } else {
            req.setAttribute("error", "Token không hợp lệ hoặc đã hết hạn.");
        }

        req.getRequestDispatcher("WEB-INF/include/reset-password.jsp").forward(req, resp);
    }
}
