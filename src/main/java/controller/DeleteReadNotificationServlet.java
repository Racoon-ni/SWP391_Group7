package controller;

import DAO.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import java.io.IOException;

@WebServlet(name = "DeleteReadNotificationServlet", urlPatterns = {"/notification/delete-read"})
public class DeleteReadNotificationServlet extends HttpServlet {

    private NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            notificationDAO.deleteReadNotifications(user.getId());
        }

        response.sendRedirect(request.getContextPath() + "/home"); // hoặc /notifications nếu bạn có trang riêng
    }
}
