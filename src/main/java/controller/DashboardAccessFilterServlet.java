package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Servlet trung gian kiểm tra quyền truy cập vào trang quản trị (dashboard)
 * Chỉ cho phép admin và staff truy cập vào dash-board.jsp
 * Nếu không đủ quyền → chuyển hướng tới /access-denied
 */
@WebServlet("/dashboard")
public class DashboardAccessFilterServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        // Lấy session hiện tại nếu có
        HttpSession session = req.getSession(false);

        // Mặc định là guest nếu không có session hoặc role
        String role = "guest";
        if (session != null && session.getAttribute("role") != null) {
            role = session.getAttribute("role").toString();
        }

        // Kiểm tra vai trò được phép truy cập dashboard
        if ("admin".equals(role) || "staff".equals(role)) {
            // Được phép → forward đến trang quản trị chính
            req.getRequestDispatcher("dash-board.jsp").forward(req, resp);
        } else {
            // Không đủ quyền → chuyển hướng đến trang từ chối
            resp.sendRedirect("access-denied");
        }
    }
}
