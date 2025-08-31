package controller;

import DAO.NotificationDAO;
import model.Notification;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/notifications"})
public class NotificationServlet extends HttpServlet {

    private NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user"); // user đang đăng nhập

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                List<Notification> notifications = notificationDAO.getByUser(user.getId());
                int unreadCount = notificationDAO.countUnreadByUser(user.getId());
                request.setAttribute("notifications", notifications);
                request.setAttribute("unreadCount", unreadCount);
                request.getRequestDispatcher("WEB-INF/include/notifications.jsp").forward(request, response);
                break;

            case "markRead":
                int id = Integer.parseInt(request.getParameter("id"));
                notificationDAO.markRead(id);
                response.sendRedirect("notifications");
                break;

            case "markAllRead":
                notificationDAO.markAllRead(user.getId());
                response.sendRedirect("notifications");
                break;

            case "deleteRead":
                notificationDAO.deleteReadNotifications(user.getId());
                response.sendRedirect("notifications");
                break;

            default:
                response.sendRedirect("notifications");
                break;
        }
    }
}

