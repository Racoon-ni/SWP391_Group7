<%@page import="DAO.NotificationDAO"%>
<%@page import="java.util.List"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html;charset=UTF-8" language="java" %>

<%@page import="model.User" %>
<%@page import="model.Notification" %>
<%@page import="java.util.*" %>

<%
    NotificationDAO notiDao = new NotificationDAO();
    int unreadCount = 0;
    List<Notification> notifications = new ArrayList<>();
    String contextPath = request.getContextPath();

    if (session.getAttribute("user") != null) {
        User u = (User) session.getAttribute("user");
        unreadCount = notiDao.countUnreadByUser(u.getId());
        notifications = notiDao.getByUser(u.getId());
    }
%>

<head>
    <title>PC Store</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Annie+Use+Your+Telescope&display=swap" rel="stylesheet" />

    <style>
        .shadowed-navbar {
            border-bottom: 2px solid black;
            box-shadow: 0px 8px 8px -4px rgba(0, 0, 0, 0.4);
            z-index: 1030;
            padding: 0 10px;
            margin-bottom: 20px;
        }

        .annie-use-your-telescope {
            font-family: "Annie Use Your Telescope", cursive;
        }

        .dropdown-toggle::after {
            display: none !important;
        }

        /* Notification dropdown */
        .notification-dropdown {
            width: 360px;
            max-height: 480px;
            overflow-y: auto;
            padding: 0;
            border-radius: 10px;
        }

        .notification-item {
            display: flex;
            gap: 12px;
            padding: 12px 16px;
            border-bottom: 1px solid #eee;
            transition: background-color 0.2s;
            text-decoration: none;
            color: inherit;
        }
        .notification-item:hover {
            background-color: #f1f9ff;
        }
        .notification-item.unread {
            background-color: #fffef5;
            font-weight: 600;
        }

        .notification-icon {
            flex-shrink: 0;
            font-size: 1.2rem;
            color: #0d6efd;
        }

        .notification-content {
            flex-grow: 1;
        }

        .notification-message {
            margin-bottom: 4px;
            color: #212529;
            font-size: 0.95rem;
        }

        .notification-time {
            font-size: 0.8rem;
            color: #6c757d;
        }

        .notification-empty {
            text-align: center;
            padding: 16px;
            color: #6c757d;
            font-style: italic;
        }

        .notification-badge {
            position: absolute;
            top: -4px;
            right: -6px;
            background: red;
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 11px;
            font-weight: bold;
        }

        .notification-view-all, .notification-delete {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            padding: 12px;
            font-weight: 600;
            font-size: 0.9rem;
            border-top: 1px solid #eee;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .notification-view-all {
            color: #0d6efd;
            background-color: #f8f9fa;
        }
        .notification-view-all:hover {
            background-color: #e7f1ff;
            color: #084298;
        }

        .notification-delete {
            color: #dc3545;
            background-color: #fdf2f2;
        }
        .notification-delete:hover {
            background-color: #ffe0e0;
            color: #b02a37;
        }
    </style>
</head>

<c:if test="${not empty success}"> <%@include file="toast.jsp" %> </c:if>

    <nav class="navbar navbar-expand-lg navbar-light bg-light shadowed-navbar">
        <div class="container-fluid">
            <!-- LOGO -->
            <a class="navbar-brand fw-bold annie-use-your-telescope"
               href="${pageContext.request.contextPath}/home"
            style="font-size: 4rem">
            <span style="color: orange">PC</span><span style="color: black"> Store</span>
        </a>

        <%@include file="top-nav.jsp" %>

        <!-- SEARCH BAR -->
        <form action="${pageContext.request.contextPath}/search" method="GET" class="flex-grow-1 mx-3" style="max-width: 500px;">
            <div class="position-relative">
                <input type="text" name="keyword" class="form-control pe-5" placeholder="Bạn cần tìm kiếm gì?" required style="border-radius: 16px" />
                <button type="submit" class="btn position-absolute top-50 end-0 translate-middle-y pe-3 border-0 bg-transparent">
                    <i class="fas fa-search text-muted"></i>
                </button>
            </div>
        </form>

        <!-- RIGHT NAV -->
        <div class="d-flex align-items-center gap-4">
            <!-- USER -->
            <c:if test="${not empty user}">
                <div class="dropdown">
                    <a class="nav-link dropdown-toggle d-flex align-items-center" data-bs-toggle="dropdown">
                        <span>Chào, ${user.username}</span>
                        <i class="fa-regular fa-circle-user ms-2" style="font-size: large"></i>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/view-profile">Thông tin tài khoản</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng Xuất</a></li>
                    </ul>
                </div>
            </c:if>
            <c:if test="${empty user}">
                <a class="nav-link d-flex align-items-center" href="${pageContext.request.contextPath}/login">
                    <i class="fa-regular fa-user me-1"></i> Đăng nhập/Đăng ký
                </a>
            </c:if>

            <!-- BUILD PC -->
            <a class="nav-link d-flex align-items-center" href="${pageContext.request.contextPath}/BuildPC">
                <i class="fas fa-desktop me-1"></i> Build PC
            </a>

            <!-- GIỎ HÀNG -->
            <a class="nav-link d-flex align-items-center" href="${pageContext.request.contextPath}/my-carts">
                <i class="fas fa-shopping-cart me-1"></i> Giỏ hàng
            </a>

            <!-- ĐƠN HÀNG -->
            <a class="nav-link d-flex align-items-center" href="${pageContext.request.contextPath}/my-orders">
                <i class="fas fa-receipt me-1"></i> Đơn hàng của tôi
            </a>

            <!-- VOUCHER -->
            <a class="nav-link d-flex align-items-center" href="${pageContext.request.contextPath}/ViewAllVouhers">
                <i class="fas fa-ticket-alt me-1"></i> Danh sách Voucher
            </a>

            <!-- NOTIFICATION -->
            <c:if test="${not empty user}">
                <div class="dropdown">
                    <a class="nav-link position-relative dropdown-toggle" href="#" id="notificationDropdown"
                       role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-bell fa-lg"></i>
                        <% if (unreadCount > 0) {%>
                        <span id="notificationBadge" class="notification-badge">
                            <%= unreadCount%>
                        </span>
                        <% } %>
                    </a>

                    <ul class="dropdown-menu dropdown-menu-end shadow notification-dropdown" aria-labelledby="notificationDropdown">
                        <% if (notifications.isEmpty()) { %>
                        <li class="notification-empty">📭 Không có thông báo nào</li>
                            <% } else {
                                for (Notification n : notifications) {%>
                        <li>
                            <a class="notification-item <%= !n.isRead() ? "unread" : ""%>"
                               href="<%= contextPath + (n.getLink() != null ? n.getLink() : "#")%>">
                                <div class="notification-icon">
                                    <i class="fas fa-bell"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-message"><%= n.getMessage()%></div>
                                    <div class="notification-time"><%= n.getCreatedAt()%></div>
                                </div>
                            </a>
                        </li>
                        <% }
                            }%>

                        <!-- Nút xem tất cả -->
                        <li>
                            <a class="notification-view-all" href="${pageContext.request.contextPath}/notifications">
                                <i class="fas fa-list"></i> Xem tất cả
                            </a>
                        </li>

                        <!-- Nút xoá thông báo đã đọc -->
                        <li>
                            <form action="${pageContext.request.contextPath}/notification/delete-read" method="post" style="margin:0;">
                                <button type="submit" class="notification-delete w-100 border-0 bg-transparent">
                                    <i class="fas fa-trash-alt"></i> Xóa đã đọc
                                </button>
                            </form>
                        </li>
                    </ul>
                </div>
            </c:if>
        </div>
    </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.min.js"></script>

<script>
    document.getElementById('notificationDropdown')?.addEventListener('click', function () {
        fetch('<%= contextPath%>/notification/mark-all-read', {method: 'POST'})
                .then(() => {
                    const badge = document.getElementById('notificationBadge');
                    if (badge) {
                        badge.style.display = 'none';
                    }
                });
    });
</script>
