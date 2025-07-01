<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<%
    String msg = (String) request.getAttribute("msg");
%>
<html>
    <head>
        <title>Gửi phản hồi</title>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    </head>
    <body class="bg-gray-100">
        <div class="min-h-screen flex items-center justify-center py-10">
            <div class="bg-white shadow-lg rounded-lg p-8 max-w-xl w-full">
                <h1 class="text-3xl font-bold mb-6 text-center">Gửi phản hồi</h1>

                <% if (msg != null && !msg.trim().isEmpty()) {%>
                <div class="mb-4 p-2 bg-green-100 text-green-800 rounded"><%= msg%></div>
                <% }%>

                <form method="post" class="space-y-4">
                    <div>
                        <label class="block mb-1 font-semibold">Tiêu đề</label>
                        <input name="title" required class="w-full border border-gray-300 px-3 py-2 rounded focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Tiêu đề phản hồi">
                    </div>
                    <div>
                        <label class="block mb-1 font-semibold">Nội dung</label>
                        <textarea name="message" required class="w-full border border-gray-300 px-3 py-2 rounded focus:outline-none focus:ring-2 focus:ring-blue-500" rows="4" placeholder="Nội dung"></textarea>
                    </div>
                    <div class="flex flex-col sm:flex-row sm:space-x-4 space-y-2 sm:space-y-0 mt-4">
                        <button type="submit" class="flex-1 bg-green-600 text-white py-2 px-4 rounded hover:bg-green-700 transition">Gửi phản hồi</button>
                        <a href="home.jsp" class="flex-1 bg-gray-500 text-white py-2 px-4 rounded hover:bg-gray-700 transition text-center">
                            ← Quay về Trang chủ
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>
