package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import DAO.FeedbackDAO;

@WebServlet("/send-feedback")
public class SendFeedbackServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        String message = request.getParameter("message");

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId != null && title != null && message != null &&
            !title.trim().isEmpty() && !message.trim().isEmpty()) {

            FeedbackDAO dao = new FeedbackDAO();
            boolean success = dao.saveFeedback(userId, title.trim(), message.trim());

            if (success) {
                request.setAttribute("success", "Thank you for your feedback!");
            } else {
                request.setAttribute("error", "Error saving feedback. Please try again.");
            }
        } else {
            request.setAttribute("error", "All fields are required.");
        }

        request.getRequestDispatcher("WEB-INF/include/feedback.jsp").forward(request, response);
    }
}


