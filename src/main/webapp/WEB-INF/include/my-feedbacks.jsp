<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*, java.text.SimpleDateFormat, model.Feedback" %>
<!DOCTYPE html>
<html>
<head>
    <title>Phản hồi của tôi</title>
    <meta charset="UTF-8" />
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100">

    <div class="max-w-5xl mx-auto p-4 sm:p-8">
        <h1 class="text-3xl sm:text-4xl font-bold text-blue-600 mb-6 text-center">📋 Phản hồi của bạn</h1>

        <div class="bg-white shadow-lg rounded-xl p-4 sm:p-6 overflow-x-auto">
            <table class="min-w-full table-auto text-sm text-gray-800 border border-gray-300 rounded-lg">
                <thead class="bg-blue-100 text-blue-800">
                    <tr>
                        <th class="border px-4 py-2 text-left">#</th>
                        <th class="border px-4 py-2 text-left">Tiêu đề</th>
                        <th class="border px-4 py-2 text-left">Nội dung</th>
                        <th class="border px-4 py-2 text-left">Ngày gửi</th>
                        <th class="border px-4 py-2 text-left">Trạng thái</th>
                        <th class="border px-4 py-2 text-left">Phản hồi từ admin</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Feedback> feedbacks = (List<Feedback>) request.getAttribute("feedbacks");
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                        int i = 1;
                        if (feedbacks != null && !feedbacks.isEmpty()) {
                            for (Feedback fb : feedbacks) {
                    %>
                    <tr class="<%= (i % 2 == 0) ? "bg-white" : "bg-gray-50" %> hover:bg-blue-50 transition">
                        <td class="border px-4 py-2"><%= i++ %></td>
                        <td class="border px-4 py-2"><%= fb.getTitle() %></td>
                        <td class="border px-4 py-2"><%= fb.getMessage() %></td>
                        <td class="border px-4 py-2"><%= sdf.format(fb.getCreatedAt()) %></td>
                        <td class="border px-4 py-2"><%= fb.getStatus() %></td>
                        <td class="border px-4 py-2">
                            <%
                                String reply = fb.getReplyMessage();
                                if (reply != null && !reply.trim().isEmpty()) {
                            %>
                            <div class="text-green-700 font-medium"><%= reply %></div>
                            <% if (fb.getReplyAt() != null) { %>
                            <div class="text-xs text-gray-500 italic mt-1">
                                (Phản hồi lúc: <%= sdf.format(fb.getReplyAt()) %>)
                            </div>
                            <% } %>
                            <% } else { %>
                            <span class="italic text-gray-500">Chưa có phản hồi</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="6" class="text-center text-gray-500 py-6 italic">📭 Bạn chưa gửi phản hồi nào.</td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>

        <!-- ✅ Nút quay về -->
                <!-- ✅ Nút quay về gọn ở góc trái -->
        <div class="mt-4">
            <a href="sendFeedback"
               class="inline-block bg-blue-600 text-white px-4 py-2 rounded shadow hover:bg-blue-700 transition text-sm">
                ← Quay về
            </a>
        </div>

    </div>

</body>
</html>
