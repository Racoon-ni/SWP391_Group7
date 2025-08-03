/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.NotificationDAO;
import model.Notification;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.User;

/**
 *
 * @author hoaia
 */
@WebServlet("/notifications")
public class NotificationListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        NotificationDAO dao = new NotificationDAO();

        // ✅ Đánh dấu toàn bộ thông báo là đã đọc
        dao.markAllRead(user.getId());

        // ✅ Lấy danh sách thông báo
        List<Notification> list = dao.getByUser(user.getId());

        request.setAttribute("notifications", list);
        request.getRequestDispatcher("WEB-INF/include/notifications.jsp").forward(request, response);
    }
}
