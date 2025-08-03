<%@page import="model.User" %>
<%@page import="model.Notification" %>
<%@page import="java.util.*" %>
<%@page import="DAO.NotificationDAO" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    NotificationDAO dao = new NotificationDAO();
    dao.markAllRead(user.getId());
    List<Notification> notiList = dao.getByUser(user.getId());
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thông báo của bạn</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f9;
                margin: 0;
                padding: 20px;
            }

            h2 {
                text-align: center;
                color: #333;
            }

            .notifications-container {
                max-width: 600px;
                margin: 20px auto;
            }

            .notification-box {
                background-color: #fff;
                border-radius: 10px;
                padding: 16px 20px;
                margin-bottom: 15px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                display: flex;
                align-items: center;
                transition: transform 0.2s, box-shadow 0.2s;
            }

            .notification-box:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(0,0,0,0.15);
            }

            .notification-unread {
                border-left: 5px solid #ffcc00;
                background-color: #fffdee;
            }

            .notification-icon {
                font-size: 24px;
                color: #ffcc00;
                margin-right: 15px;
            }

            .notification-content {
                flex: 1;
            }

            .notification-message {
                font-size: 16px;
                margin-bottom: 5px;
                color: #333;
                font-weight: 500;
            }

            .notification-meta {
                font-size: 0.9em;
                color: #888;
            }

            p.empty {
                text-align: center;
                color: #777;
                margin-top: 50px;
            }
        </style>
    </head>
    <body>
        <h2>📢 Thông báo của bạn</h2>
        <div class="notifications-container">
            <% if (notiList.isEmpty()) { %>
            <p class="empty">📭 Không có thông báo nào.</p>
            <% } else {
            for (Notification noti : notiList) {%>
            <div class="notification-box <%= noti.isRead() ? "" : "notification-unread"%>">
                <i class="fa-solid fa-bell notification-icon"></i>
                <div class="notification-content">
                    <div class="notification-message">
                        <strong><%= noti.getTitle()%></strong><br/>
                        <%= noti.getMessage()%>
                    </div>
                    <div class="notification-meta">
                        <% if (noti.getLink() != null && !noti.getLink().isEmpty()) {%>
                        👉 <a href="<%= noti.getLink()%>">Xem chi tiết</a> |
                        <% }%>
                        🕒 <%= noti.getCreatedAt()%>
                    </div>
                </div>
            </div>
            <%  }
            }%>
        </div>
    </body>
</html>
