<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<%
    String msg = (String) request.getAttribute("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Gửi phản hồi</title>
    <meta charset="UTF-8" />
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100">

    <div class="min-h-screen flex items-center justify-center py-10 px-4">
        <div class="bg-white rounded-xl shadow-xl w-full max-w-lg p-8">
            <h1 class="text-3xl font-bold text-blue-600 text-center mb-6">📩 Gửi phản hồi</h1>

            <% if (msg != null && !msg.trim().isEmpty()) { %>
            <div class="mb-4 p-3 bg-green-100 text-green-800 rounded-md border border-green-300">
                <%= msg %>
            </div>
            <% } %>

            <form method="post" class="space-y-5">
                <div>
                    <label class="block mb-1 text-sm font-medium text-gray-700">Tiêu đề</label>
                    <input name="title" required
                           class="w-full border border-gray-300 px-3 py-2 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                           placeholder="Tiêu đề phản hồi" />
                </div>

                <div>
                    <label class="block mb-1 text-sm font-medium text-gray-700">Nội dung</label>
                    <textarea name="message" required
                              class="w-full border border-gray-300 px-3 py-2 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                              rows="4" placeholder="Nội dung"></textarea>
                </div>

                <div class="flex flex-col sm:flex-row sm:space-x-4 space-y-2 sm:space-y-0 mt-6">
                    <a href="home.jsp"
                       class="flex-1 bg-gray-500 hover:bg-gray-600 text-white py-2 px-4 rounded-md text-center transition duration-200">
                        ← Quay về Trang chủ
                    </a>

                    <button type="submit"
                            class="flex-1 bg-blue-600 hover:bg-blue-700 text-white py-2 px-4 rounded-md transition duration-200">
                        Gửi phản hồi
                    </button>

                    <a href="my-feedbacks"
                       class="flex-1 bg-blue-500 hover:bg-blue-600 text-white py-2 px-4 rounded-md text-center transition duration-200">
                        Xem phản hồi của tôi
                    </a>
                </div>
            </form>
        </div>
    </div>

</body>
</html>
