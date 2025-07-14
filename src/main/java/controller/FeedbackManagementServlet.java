package controller;

import DAO.FeedbackDAO;
import model.Feedback;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/feedbacks")
public class FeedbackManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        FeedbackDAO dao = new FeedbackDAO();

        // ✅ Lấy toàn bộ phản hồi từ DAO
        List<Feedback> feedbacks = dao.getAllFeedback();

        // ✅ Gửi danh sách phản hồi sang JSP
        request.setAttribute("feedbacks", feedbacks);

        // ✅ Forward tới trang quản lý phản hồi (admin)
        request.getRequestDispatcher("/WEB-INF/include/feedback-management.jsp").forward(request, response);
    }
}
