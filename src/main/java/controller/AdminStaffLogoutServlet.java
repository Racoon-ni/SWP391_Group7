package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/logout")
public class AdminStaffLogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate(); // huỷ session
        }

        resp.sendRedirect("login"); // chuyển về trang đăng nhập
    }
}
