package controller;

import DAO.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet("/deleteFeedback")
public class DeleteFeedbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // Không tạo session mới nếu chưa tồn tại
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            // Chưa login -> redirect về login
            response.sendRedirect("login.jsp?error=notloggedin");
            return;
        }

        String feedbackIdParam = request.getParameter("feedbackId");
        if (feedbackIdParam == null || feedbackIdParam.isEmpty()) {
            response.sendRedirect("my-feedbacks?error=missingid");
            return;
        }

        try {
            int feedbackId = Integer.parseInt(feedbackIdParam);

            FeedbackDAO dao = new FeedbackDAO();
            boolean deleted = dao.deleteFeedbackIfPending(feedbackId, user.getId());

            if (deleted) {
                response.sendRedirect("my-feedbacks");
            } else {
                response.sendRedirect("my-feedbacks?error=notfound");
            }

        } catch (NumberFormatException e) {
            // feedbackId không hợp lệ
            response.sendRedirect("my-feedbacks?error=invalidid");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("my-feedbacks?error=1");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
