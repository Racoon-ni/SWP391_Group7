package controller;

import DAO.FeedbackDAO;
import model.Feedback;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/sendFeedback")
public class SendFeedbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Hiện form gửi feedback
        req.getRequestDispatcher("/WEB-INF/include/send-feedback.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Xử lý submit form
        User user = (User) req.getSession().getAttribute("user"); // hoặc "account"
        if (user == null) {
            resp.sendRedirect("login");
            return;
        }

        String title = req.getParameter("title");
        String message = req.getParameter("message");

        Feedback fb = new Feedback();
        fb.setUserId(user.getId());
        fb.setTitle(title);
        fb.setMessage(message);
        fb.setStatus("Pending");

        int result = new FeedbackDAO().addFeedback(fb);

        req.setAttribute("msg", result > 0 ? "Gửi phản hồi thành công!" : "Gửi thất bại, thử lại.");
        req.getRequestDispatcher("/WEB-INF/include/send-feedback.jsp").forward(req, resp);
    }
}
