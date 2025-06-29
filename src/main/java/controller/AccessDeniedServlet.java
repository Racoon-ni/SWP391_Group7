package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/access-denied")
public class AccessDeniedServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        String role = "guest";

        if (session != null && session.getAttribute("role") != null) {
            role = session.getAttribute("role").toString(); // admin / customer
        }

        req.setAttribute("userRole", role);
        req.getRequestDispatcher("/WEB-INF/include/access-denied.jsp").forward(req, resp);
    }
}
