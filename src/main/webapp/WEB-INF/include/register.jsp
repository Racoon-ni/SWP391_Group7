<%-- 
    Document   : login
    Created on : Jun 18, 2025, 8:09:07 PM
    Author     : Huynh Trong Nguyen - CE190356
--%>
<%@include file="/WEB-INF/include/header.jsp" %>
<%@ page pageEncoding="UTF-8" %>
<style>
    /* Container */
    .login-container {
        background: white;
        padding: 40px;
        border-radius: 16px;
        box-shadow: 0 6px 10px rgba(0, 0, 0, 0.2);
        text-align: center;
        width: 360px;
        border: 2px solid #c7e7fa;
    }

    /* Title */
    .login-container h2 {
        font-size: 2em;
        margin-bottom: 24px;
        color: #1e355d;
    }

    /* Inputs */
    .login-container input[type="text"],
    .login-container input[type="password"] {
        width: 100%;
        padding: 12px;
        margin-bottom: 12px;
        border-radius: 12px;
        border: 2px solid #b6d9f0;
        font-size: 1em;
    }

    /* Links */
    .links {
        display: flex;
        justify-content: space-between;
        margin-bottom: 20px;
        font-size: 0.9em;
    }

    .links a {
        text-decoration: none;
        color: #1e355d;
        font-weight: bold;
    }

    .links .highlight {
        color: #3e9ef1;
    }

    /* Login Button */
    .login-btn {
        background-color: #226bf3;
        color: white;
        padding: 12px;
        width: 100%;
        font-size: 1.1em;
        border: none;
        border-radius: 12px;
        cursor: pointer;
        transition: background 0.3s;
    }

    .login-btn:hover {
        background-color: #1b54c7;
    }

    /* Divider */
    .divider {
        margin: 20px 0;
        font-weight: bold;
    }

    .password-wrapper {
        position: relative;
        width: 100%;
    }

    .password-wrapper input {
        width: 100%;
        padding: 12px 40px 12px 12px; /* space for icon */
        border-radius: 12px;
        border: 2px solid #b6d9f0;
        font-size: 1em;
    }

    .toggle-password {
        position: absolute;
        top: 43%;
        right: 12px;
        transform: translateY(-50%);
        cursor: pointer;
        font-size: 1.2em;
        color: #333;
    }

</style>

<div style="display: flex; justify-content: center; align-items: center;">
    <div class="login-container">
        <h2>Đăng Ký</h2>

        <form action="${pageContext.request.contextPath}/register" method="POST">
            <input type="text" name="username" placeholder="Tên Người Dùng" required />

            <div class="password-wrapper">
                <input type="password" name="password" placeholder="Mật khẩu" required />
                <i class="fa-solid fa-eye toggle-password" onclick="togglePassword(this)"></i>
            </div>

            <div class="password-wrapper">
                <input type="password" name="valid_password" placeholder="Nhập Lại Mật khẩu" required />
                <i class="fa-solid fa-eye toggle-password" onclick="togglePassword(this)"></i>
            </div>

            <button type="submit" class="login-btn">Đăng Ký</button>
        </form>
    </div>
</div>


<script>
    function togglePassword(icon) {
        const input = icon.previousElementSibling;
        const isPassword = input.type === "password";

        input.type = isPassword ? "text" : "password";
        
        icon.classList.toggle("fa-eye");
        icon.classList.toggle("fa-eye-slash");
    }
</script>

<%@include file="/WEB-INF/include/footer.jsp" %>


