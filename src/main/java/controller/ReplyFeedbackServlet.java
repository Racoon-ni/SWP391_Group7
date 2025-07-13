package controller;

import DAO.FeedbackDAO;
import DAO.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/reply-feedback")
public class ReplyFeedbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            // ✅ Lấy tham số từ form
            int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String replyMessage = request.getParameter("adminReply");

            // ✅ Lấy ID admin đang đăng nhập từ session
            Integer adminId = (Integer) session.getAttribute("adminId");

            boolean isSuccess = false;

            // ✅ Kiểm tra dữ liệu đầu vào
            if (adminId != null && replyMessage != null && !replyMessage.trim().isEmpty()) {
                FeedbackDAO feedbackDAO = new FeedbackDAO();

                // ✅ Admin trả lời feedback (update DB)
                int updated = feedbackDAO.replyToFeedback(feedbackId, adminId, replyMessage);
                isSuccess = (updated > 0);

                // ✅ Nếu update thành công -> Gửi thông báo cho khách hàng
                if (isSuccess) {
                    NotificationDAO notiDAO = new NotificationDAO();
                    String title = "Phản hồi của bạn đã được trả lời";
                    String message = "Admin đã trả lời phản hồi của bạn. Vui lòng kiểm tra chi tiết.";
                    String link = "/my-feedbacks";

                    notiDAO.sendNotification(customerId, title, message, link);
                }
            }

            // ✅ Gửi trạng thái xử lý về để hiển thị thông báo
            session.setAttribute("status", isSuccess ? "success" : "fail");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("status", "fail");
        }

        // ✅ Redirect về trang quản lý phản hồi
        response.sendRedirect(request.getContextPath() + "/feedbacks");
    }
}
