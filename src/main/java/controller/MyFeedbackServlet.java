/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import DAO.FeedbackDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Feedback;
import model.User;

/**
 *
 * @author hoaia
 */
@WebServlet("/my-feedbacks")
public class MyFeedbackServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user"); // cần đăng nhập trước

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        FeedbackDAO dao = new FeedbackDAO();
        List<Feedback> feedbacks = dao.getFeedbacksByUser(user.getId());

        request.setAttribute("feedbacks", feedbacks);
        request.getRequestDispatcher("WEB-INF/include/my-feedbacks.jsp").forward(request, response);
    }
}
