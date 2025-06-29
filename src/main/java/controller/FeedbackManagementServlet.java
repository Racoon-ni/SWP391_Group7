package controller;

import DAO.FeedbackDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Feedback;

@WebServlet("/feedbacks")
public class FeedbackManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        FeedbackDAO dao = new FeedbackDAO();
        List<Feedback> feedbacks = dao.getAllFeedback();
        request.setAttribute("feedbacks", feedbacks);
        request.getRequestDispatcher("/WEB-INF/include/feedback-management.jsp").forward(request, response);
    }
}
