package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 *
 * @author nguyen Tan Phat - CE171269
 */
@WebServlet("/handle404")
public class Handle404Servlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

//        // Lấy session nếu có
//        HttpSession session = req.getSession(false);
//        String role = "guest";
//
//        if (session != null && session.getAttribute("role") != null) {
//            role = session.getAttribute("role").toString(); // admin / customer
//        }
//
//        if (session != null && session.getAttribute("role") != null) {
//            role = session.getAttribute("role").toString(); // admin / customer
//        }
//
//        // Đẩy role qua view
//        req.setAttribute("userRole", role);

        // Forward tới View
        req.getRequestDispatcher("/WEB-INF/include/404.jsp").forward(req, resp);
    }
}
