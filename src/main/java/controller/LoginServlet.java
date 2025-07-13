package controller;

import DAO.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("WEB-INF/include/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // ✅ Tạo session nếu chưa có
        HttpSession session = request.getSession(true);

        UserDAO uDAO = new UserDAO();
        User user = uDAO.getUser(username, password);

        if (user == null) {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu");
            request.getRequestDispatcher("/WEB-INF/include/login.jsp").forward(request, response);
        } else {
            session.setAttribute("user", user);

            if (uDAO.login(user) && user.getRole().equalsIgnoreCase("Customer")) {
                session.setAttribute("logged", true);
                request.setAttribute("success", "Đăng nhập thành công");
                request.getRequestDispatcher("/home.jsp").forward(request, response);

            } else if (uDAO.login(user)
                    && (user.getRole().equalsIgnoreCase("Admin") || user.getRole().equalsIgnoreCase("Staff"))) {

                session.setAttribute("logged", true);
                session.setAttribute("adminId", user.getId()); // ✅ DÒNG QUAN TRỌNG
                request.setAttribute("success", "Đăng nhập thành công");
                request.getRequestDispatcher("/dash-board.jsp").forward(request, response);

            } else {
                request.setAttribute("error", "Sai tài khoản hoặc mật khẩu");
                request.getRequestDispatcher("/WEB-INF/include/login.jsp").forward(request, response);
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Login Servlet handles user login and role-based redirection.";
    }
}
