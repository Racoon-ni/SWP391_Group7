<%-- 
    Document   : pop-up-chat
    Created on : Jun 18, 2025, 1:39:44 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>
<%@ page pageEncoding="UTF-8" %>
<style>
    /* Floating chat button */
    .open-button {
        border: none;
        position: fixed;
        bottom: -8px;
        right: 20px;
        z-index: 999;
    }

    /* Chat popup container */
    .form-popup {
        display: none;
        position: fixed;
        bottom: -1px;
        right: 10px;
        width: 250px;
        border-radius: 24px;
        box-shadow: 0 0 10px rgba(0,0,0,0.2);
        z-index: 999;
        background-color: white;
        overflow: hidden;
        font-family: sans-serif;
    }

    .chat-title {
        background-color: #007bff; /* or use the exact color from the image if needed */
        color: white;
        padding: 5px 30px;
        text-align: center;
        font-size: 13px;
        border-top-left-radius: 20px;
        border-top-right-radius: 20px;
        border-bottom-left-radius: 0;
        border-bottom-right-radius: 0;
    }


    /* Chat messages area */
    .chat-body {
        padding: 10px;
        max-height: 300px;
        overflow-y: auto;
        height: 200px;
    }

    .chat-message {
        background-color: #e4e4e4;
        padding: 8px 12px;
        border-radius: 15px;
        margin-bottom: 10px;
        display: inline-block;
        font-size: 13px;
    }

    /* Chat input area */
    .chat-input-container {
        display: flex;
        border-top: 1px solid #ccc;
        padding: 5px;
    }

    .chat-input {
        flex: 1;
        border: none;
        padding: 8px;
        font-size: 13px;
        border-radius: 20px;
        background-color: #f1f1f1;
        margin-right: 5px;
        margin-bottom: 2px;
    }

    .chat-send-btn {
        background-color: #007bff;
        border: none;
        border-radius: 50%;
        width: 28px;
        height: 28px;
        color: white;
        font-size: 14px;
        cursor: pointer;
        margin-top: 4px;
    }

    /* Hide scrollbar */
    .chat-body::-webkit-scrollbar {
        display: none;
    }
    .chat-body {
        -ms-overflow-style: none;
        scrollbar-width: none;
    }
</style>

<!-- Chat toggle button -->
<button class="open-button chat-title" onclick="openForm()">CHAT với tư vấn viên</button>

<!-- Chat form -->
<div class="form-popup" id="myForm">
    <div class="chat-title">CHAT với tư vấn viên</div>
    <div class="chat-body" id="chatBody">
        <div class="chat-message">Xin chào, chúng tôi có thể giúp gì cho bạn ?</div>
    </div>
    <div class="chat-input-container">
        <input type="text" class="chat-input" id="chatInput" placeholder="Nhắn tin" />
        <button class="chat-send-btn">➤</button>
    </div>
</div>

<script>
    function openForm() {
        document.getElementById("myForm").style.display = "block";
        document.addEventListener('click', handleOutsideClick);
    }

    function closeForm() {
        document.getElementById("myForm").style.display = "none";
        document.removeEventListener('click', handleOutsideClick);
    }

    function handleOutsideClick(event) {
        const form = document.getElementById("myForm");
        const button = document.querySelector(".open-button");

        // If the click is NOT inside the form AND not on the open button
        if (!form.contains(event.target) && !button.contains(event.target)) {
            closeForm();
        }
    }

</script>
