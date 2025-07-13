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

    /* The message box is shown when the user clicks on the password field */
    #message {
        display:none;
        background: aliceblue;
        color: #000;
        position: relative;
        padding: 20px;
        margin-top: 10px;
    }

    #message p {
        padding: 10px 35px;
        font-size: 18px;
    }

    /* Add a green text color and a checkmark when the requirements are right */
    .valid {
        color: green;
    }

    .valid:before {
        position: relative;
        left: -35px;
        content: "✔";
    }

    /* Add a red text color and an "x" when the requirements are wrong */
    .invalid {
        color: red;
    }

    .invalid:before {
        position: relative;
        left: -35px;
        content: "✖";
    }

</style>

<c:if test="${not empty error}">
    <%@include file="toast.jsp" %>
</c:if>
<div style="display: flex; justify-content: center; align-items: center;">
    <div class="login-container">
        <h2>Đăng Ký</h2>

        <form action="${pageContext.request.contextPath}/register" method="POST">
            <input type="text" name="username" value="${username}" placeholder="Tên Người Dùng" required />

            <div class="password-wrapper">
                <input type="password" id="psw" name="psw" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" 
                       title="Must contain at least one number and one uppercase and lowercase letter, 
                       and at least 8 or more characters" placeholder="Mật khẩu" required>
                <i class="fa-solid fa-eye toggle-password" onclick="togglePassword(this)"></i>
            </div>

            <!-- Re-enter password field -->
            <div class="password-wrapper">
                <input type="password" id="confirm_password" name="valid_password" placeholder="Nhập Lại Mật khẩu" required />
                <i class="fa-solid fa-eye toggle-password" onclick="togglePassword(this)"></i>
            </div>



            <button type="submit" class="login-btn">Đăng Ký</button>
        </form>
        <!-- Message or validation indicator -->
        <p id="matchMessage" style="color: red; display: none;">Mật khẩu không khớp</p>
    </div>
    <div id="message" style="padding: 20px">
        <h5>Password must contain the following:</h5>
        <p id="letter" class="invalid">A <b>lowercase</b> letter</p>
        <p id="capital" class="invalid">A <b>capital (uppercase)</b> letter</p>
        <p id="number" class="invalid">A <b>number</b></p>
        <p id="length" class="invalid">Minimum <b>8 characters</b></p>
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

    const myInput = document.getElementById("psw");
    const confirmPassword = document.getElementById("confirm_password");
    const letter = document.getElementById("letter");
    const capital = document.getElementById("capital");
    const number = document.getElementById("number");
    const length = document.getElementById("length");
    const matchMessage = document.getElementById("matchMessage");
    const messageBox = document.getElementById("message");

    // When the user clicks on the password field, show the message box
    myInput.onfocus = function () {
        document.getElementById("message").style.display = "block";
    };

// Password strength check
    myInput.onkeyup = function () {
        // Lowercase letters
        if (/[a-z]/.test(myInput.value)) {
            letter.classList.add("valid");
            letter.classList.remove("invalid");
        } else {
            letter.classList.remove("valid");
            letter.classList.add("invalid");
        }

        // Uppercase letters
        if (/[A-Z]/.test(myInput.value)) {
            capital.classList.add("valid");
            capital.classList.remove("invalid");
        } else {
            capital.classList.remove("valid");
            capital.classList.add("invalid");
        }

        // Numbers
        if (/\d/.test(myInput.value)) {
            number.classList.add("valid");
            number.classList.remove("invalid");
        } else {
            number.classList.remove("valid");
            number.classList.add("invalid");
        }

        // Length
        if (myInput.value.length >= 8) {
            length.classList.add("valid");
            length.classList.remove("invalid");
        } else {
            length.classList.remove("valid");
            length.classList.add("invalid");
        }

        // Hide message box if all valid
        if (
                letter.classList.contains("valid") &&
                capital.classList.contains("valid") &&
                number.classList.contains("valid") &&
                length.classList.contains("valid")
                ) {
            messageBox.style.display = "none";
        } else {
            messageBox.style.display = "block";
        }
    };

// Match check on typing
    confirmPassword.onkeyup = function () {
        if (confirmPassword.value === myInput.value) {
            matchMessage.style.display = "none";
            confirmPassword.classList.remove("invalid");
            confirmPassword.classList.add("valid");
        } else {
            matchMessage.style.display = "block";
            matchMessage.textContent = "Mật khẩu không khớp";
            confirmPassword.classList.remove("valid");
            confirmPassword.classList.add("invalid");
        }
    };

</script>

<%@include file="/WEB-INF/include/footer.jsp" %>


