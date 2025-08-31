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
        HttpSession session = request.getSession(false);

        UserDAO uDAO = new UserDAO();
        User user = uDAO.getUser(username, password);

        if (user == null) {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu");
            request.getRequestDispatcher("/WEB-INF/include/login.jsp").forward(request, response);
        } else {
            session.setAttribute("user", user);

            if (user.getRole().equalsIgnoreCase("Customer")) {
                session.setAttribute("logged", true);
                // ✅ Gọi lại HomeServlet để lấy banner
                response.sendRedirect("home");

            } else {

                session.setAttribute("logged", true);
                session.setAttribute("adminId", user.getId());
                request.getRequestDispatcher("dash-board").forward(request, response);

            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
