package controller;

import DAO.FeedbackDAO;
import model.Feedback;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/reply-feedback-form")
public class ReplyFeedbackFormServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        FeedbackDAO dao = new FeedbackDAO();
        Feedback fb = dao.getFeedbackById(id);
        request.setAttribute("feedback", fb);

        request.getRequestDispatcher("/WEB-INF/include/reply-feedback.jsp").forward(request, response);
    }
}
