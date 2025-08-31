package controller;

import DAO.PasswordResetTokenDAO;
import DAO.UserDAO;
import model.User;
import util.EmailUtil;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.UUID;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("WEB-INF/include/forgot-password.jsp").forward(request, response);

    }

   @Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String email = req.getParameter("email");

    // Validate email trước khi xử lý
    if (email == null || email.isEmpty()) {
        req.setAttribute("error", "Vui lòng nhập email!");
        req.getRequestDispatcher("WEB-INF/include/forgot-password.jsp").forward(req, resp);
        return;
    }

    // Regex: chỉ cho phép chữ, số, dấu chấm, gạch dưới + bắt buộc đuôi @gmail.com
    String emailRegex = "^[a-zA-Z0-9._]+@gmail\\.com$";
    if (!email.matches(emailRegex)) {
        req.setAttribute("error", "Email không hợp lệ! Vui lòng nhập đúng định dạng @gmail.com và không chứa ký tự đặc biệt.");
        req.getRequestDispatcher("WEB-INF/include/forgot-password.jsp").forward(req, resp);
        return;
    }

    // 1. Lấy user theo email
    UserDAO userDAO = new UserDAO();
    User user = userDAO.getUserIdByEmail(email);

    if (user == null) {
        req.setAttribute("error", "Email không tồn tại!");
        req.getRequestDispatcher("WEB-INF/include/forgot-password.jsp").forward(req, resp);
        return;
    }

    // 2. Tạo token và lưu vào DB
    String token = UUID.randomUUID().toString();
    LocalDateTime make = LocalDateTime.now();
    LocalDateTime expiry = make.plusMinutes(30);

    PasswordResetTokenDAO tokenDAO = new PasswordResetTokenDAO();
    tokenDAO.saveToken(user.getId(), token, expiry);

    // 3. Tạo link reset
    String resetLink = req.getRequestURL().toString().replace("forgot-password", "reset-password?token=" + token);

    // 4. Gửi email
    String subject = "Đặt lại mật khẩu - PC Store";
    String body = "<p>Xin chào <b>" + user.getFullname() + "</b>,</p>"
            + "<p>Nhấn vào liên kết để đặt lại mật khẩu: <a href='" + resetLink + "'>" + resetLink + "</a></p>"
            + "<p>Liên kết này sẽ hết hạn sau 30 phút.</p>";

    try {
        EmailUtil.sendEmail(email, subject, body); // gửi HTML
    } catch (Exception e) {
        e.printStackTrace();
        req.setAttribute("error", "Gửi email thất bại. Vui lòng thử lại.");
        req.getRequestDispatcher("WEB-INF/include/forgot-password.jsp").forward(req, resp);
        return;
    }

    // 5. Thông báo gửi thành công
    req.setAttribute("message", "Link đặt lại mật khẩu đã được gửi tới email của bạn!");
    req.getRequestDispatcher("WEB-INF/include/forgot-password.jsp").forward(req, resp);
}

}
