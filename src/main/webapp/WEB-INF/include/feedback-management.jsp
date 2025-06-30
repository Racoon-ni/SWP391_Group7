<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*, model.Feedback, java.text.SimpleDateFormat" %>
s
<html>
    <head>
        <title>Quản lý phản hồi</title>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="max-w-7xl mx-auto p-8">
            <h1 class="text-3xl font-bold mb-6 text-gray-800">Quản lý phản hồi</h1>

            <table class="min-w-full table-auto border border-gray-300 rounded-md text-sm text-gray-800">
                <thead class="bg-gray-100 text-left">
                    <tr>
                        <th class="border border-gray-300 px-4 py-2">#</th>
                        <th class="border border-gray-300 px-4 py-2">Khách hàng</th>
                        <th class="border border-gray-300 px-4 py-2">Tiêu đề</th>
                        <th class="border border-gray-300 px-4 py-2">Nội dung</th>
                        <th class="border border-gray-300 px-4 py-2">Trạng thái</th>
                        <th class="border border-gray-300 px-4 py-2">Ngày gửi</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Feedback> feedbacks = (List<Feedback>) request.getAttribute("feedbacks");
                        if (feedbacks != null && !feedbacks.isEmpty()) {
                            int index = 1;
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            for (Feedback fb : feedbacks) {
                    %>
                    <tr class="<%= (index % 2 == 0) ? "bg-gray-50" : "bg-white"%>">
                        <td class="border border-gray-300 px-4 py-2"><%= index++%></td>
                        <td class="border border-gray-300 px-4 py-2"><%= fb.getUserName()%></td>
                        <td class="border border-gray-300 px-4 py-2"><%= fb.getTitle()%></td>
                        <td class="border border-gray-300 px-4 py-2"><%= fb.getMessage()%></td>
                        <td class="border border-gray-300 px-4 py-2"><%= fb.getStatus()%></td>
                        <td class="border border-gray-300 px-4 py-2">
                            <%= (fb.getCreatedAt() != null) ? sdf.format(fb.getCreatedAt()) : ""%>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="6" class="text-center border border-gray-300 px-4 py-2 text-gray-500">
                            Chưa có phản hồi nào.
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </body>
</html>
