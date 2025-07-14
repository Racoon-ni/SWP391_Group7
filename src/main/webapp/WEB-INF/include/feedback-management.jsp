<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="java.util.*, model.Feedback, java.text.SimpleDateFormat" %>
<html>
    <head>
        <title>Quản lý phản hồi</title>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    </head>
    <body>

        <%-- ✅ Hiển thị thông báo nếu có status từ session --%>
        <%
            String status = (String) session.getAttribute("status");
            if (status != null) {
                session.removeAttribute("status");
        %>
        <div id="alertBox" class="fixed top-5 right-5 z-50 px-4 py-3 rounded shadow-lg text-white
             <%= "success".equals(status) ? "bg-green-500" : "bg-red-500"%>">
            <%= "success".equals(status) ? "Phản hồi thành công!" : "Phản hồi thất bại!"%>
        </div>
        <script>
            setTimeout(() => {
                const alert = document.getElementById("alertBox");
                if (alert)
                    alert.style.display = "none";
            }, 5000);
        </script>
        <% } %>

        <div class="max-w-7xl mx-auto p-8">
            <h1 class="text-3xl font-bold mb-6 text-gray-800">Quản lý phản hồi</h1>

            <div class="mb-6">
                <a href="${pageContext.request.contextPath}/dash-board"
                   class="inline-flex items-center px-4 py-2 bg-gray-700 text-white text-sm font-semibold rounded-lg shadow-md hover:bg-gray-800 transition duration-300">
                    ← Quay lại
                </a>
            </div>

            <table class="min-w-full table-auto border border-gray-300 rounded-md text-sm text-gray-800">
                <thead class="bg-gray-100 text-left">
                    <tr>
                        <th class="border px-4 py-2">#</th>
                        <th class="border px-4 py-2">Khách hàng</th>
                        <th class="border px-4 py-2">Tiêu đề</th>
                        <th class="border px-4 py-2">Nội dung</th>
                        <th class="border px-4 py-2">Trạng thái</th>
                        <th class="border px-4 py-2">Ngày gửi</th>
                        <th class="border px-4 py-2">Phản hồi từ Admin</th>
                        <th class="border px-4 py-2">Ngày phản hồi</th>
                        <th class="border px-4 py-2">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Feedback> feedbacks = (List<Feedback>) request.getAttribute("feedbacks");
                        if (feedbacks != null && !feedbacks.isEmpty()) {
                            int index = 1;
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                            for (Feedback fb : feedbacks) {
                    %>
                    <tr class="<%= (index % 2 == 0) ? "bg-gray-50" : "bg-white"%> hover:bg-gray-100 transition">
                        <td class="border px-4 py-3"><%= index++%></td>
                        <td class="border px-4 py-3"><%= fb.getUserName()%></td>
                        <td class="border px-4 py-3"><%= fb.getTitle()%></td>
                        <td class="border px-4 py-3"><%= fb.getMessage()%></td>
                        <td class="border px-4 py-3">
                            <% if ("Pending".equalsIgnoreCase(fb.getStatus())) { %>
                            <span class="inline-block bg-yellow-100 text-yellow-800 px-2 py-1 rounded-full text-xs font-semibold">Chờ xử lý</span>
                            <% } else { %>
                            <span class="inline-block bg-green-100 text-green-800 px-2 py-1 rounded-full text-xs font-semibold">Đã trả lời</span>
                            <% }%>
                        </td>
                        <td class="border px-4 py-3"><%= fb.getCreatedAt() != null ? sdf.format(fb.getCreatedAt()) : ""%></td>
                        <td class="border px-4 py-3">
                            <% if (fb.getReplyMessage() != null && !fb.getReplyMessage().trim().isEmpty()) {%>
                            <span class="text-green-700"><%= fb.getReplyMessage()%></span>
                            <% } else { %>
                            <span class="text-gray-400 italic">Chưa có phản hồi</span>
                            <% }%>
                        </td>
                        <td class="border px-4 py-3"><%= fb.getReplyAt() != null ? sdf.format(fb.getReplyAt()) : "-"%></td>
                        <td class="border px-4 py-3">
                            <% if ("Pending".equalsIgnoreCase(fb.getStatus())) {%>
                            <a href="reply-feedback-form?id=<%= fb.getFeedbackId()%>"
                               class="inline-block bg-blue-500 text-white px-3 py-1 rounded-lg hover:bg-blue-600 transition">
                                Trả lời
                            </a>
                            <% } else { %>
                            <span class="text-green-600 font-semibold">Đã trả lời</span>
                            <% } %>
                        </td>
                    </tr>
                    <% }
                } else { %>
                    <tr>
                        <td colspan="9" class="text-center text-gray-500 py-4">Chưa có phản hồi nào.</td>
                    </tr>
                    <% }%>
                </tbody>
            </table>
        </div>
    </body>
</html>
