<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Feedback" %>

<%
    Feedback fb = (Feedback) request.getAttribute("feedback");
%>

<html>
    <head>
        <title>Trả lời phản hồi</title>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    </head>
    <body class="bg-gray-50 text-gray-800">
        <div class="max-w-3xl mx-auto p-8 bg-white shadow-lg mt-10 rounded-lg">
            <h2 class="text-2xl font-bold mb-4">Phản hồi cho: <span class="text-blue-600"><%= fb.getUserName()%></span></h2>

            <div class="mb-4">
                <label class="font-semibold">Tiêu đề:</label>
                <p class="ml-2 text-gray-700"><%= fb.getTitle()%></p>
            </div>

            <div class="mb-4">
                <label class="font-semibold">Nội dung khách gửi:</label>
                <p class="ml-2 text-gray-700 whitespace-pre-wrap"><%= fb.getMessage()%></p>
            </div>

            <form method="post" action="reply-feedback">
                <!-- Thêm hidden input để truyền feedbackId và customerId -->
                <input type="hidden" name="feedbackId" value="<%= fb.getFeedbackId()%>"/>
                <input type="hidden" name="customerId" value="<%= fb.getUserId()%>"/>

                <div class="mb-4">
                    <label for="adminReply" class="font-semibold">Phản hồi của admin:</label>
                    <textarea name="adminReply" id="adminReply" required rows="6"
                              class="w-full p-3 border border-gray-300 rounded mt-2 resize-none"
                              placeholder="Nhập nội dung phản hồi..."></textarea>
                </div>

                <div class="text-right">
                    <button type="submit"
                            class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded transition duration-300">
                        Gửi phản hồi
                    </button>
                </div>
            </form>
        </div>
    </body>
</html>
