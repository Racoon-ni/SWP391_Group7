<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

<%@ page import="java.util.List" %>
<%@ page import="model.Customer" %>
<%
    List<String> errors = (List<String>) request.getAttribute("errors");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<style>
  .modal-dialog {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
}

.modal-content {
    width: 500px;
    border-radius: 12px;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
    overflow: hidden;
    border: none;
}

.modal-header {
    background-color: #007bff;
    color: white;
    font-weight: 600;
    font-size: 18px;
    padding: 16px 24px;
    border-bottom: none;
}

.modal-body {
    background-color: #f9f9f9;
    padding: 28px 32px;
}

.form-group {
    margin-bottom: 20px;
    position: relative;
}

.form-group label {
    font-size: 16px;
    font-weight: 600;
    margin-bottom: 8px;
    display: block;
    color: #333;
}

.form-control {
    width: 100%;
    padding: 12px 40px 12px 12px;
    border-radius: 8px;
    border: 1px solid #ccc;
    font-size: 15px;
    background-color: white;
}

.form-control:focus {
    border-color: #007bff;
    box-shadow: 0 0 0 2px rgba(0, 123, 255, .15);
    outline: none;
}

.toggle-password {
    position: absolute;
    top: 52%;
    right: 14px;
    transform: translateY(-50%);
    cursor: pointer;
    font-size: 18px;
    color: #888;
}

.toggle-password:hover {
    color: #007bff;
}

.form-text {
    font-size: 13px;
    color: #6c757d;
    margin-top: 6px;
}

.modal-footer {
    padding: 16px 32px;
    background-color: #f9f9f9;
    border-top: none;
    display: flex;
    justify-content: flex-end;
}

.btn {
    padding: 10px 24px;
    border-radius: 6px;
    font-size: 14px;
    font-weight: 500;
    transition: 0.2s ease-in-out;
}

.btn-primary {
    background-color: #007bff;
    border: none;
    color: white;
}

.btn-primary:hover {
    background-color: #0056b3;
}

.btn-secondary {
    background-color: white;
    border: 2px solid #333;
    color: #333;
    margin-right: 10px;
}

.btn-secondary:hover {
    background-color: #f0f0f0;
}



</style>

<div class="modal fade" id="changePasswordModal" tabindex="-1" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="changePasswordModalLabel">Đổi mật khẩu</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <c:if test="${not empty errors}">
                    <div class="alert alert-danger">
                        <ul>
                            <c:forEach var="err" items="${errors}">
                                <li>${err}</li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:if>
                <c:if test="${success eq 'true'}">
                    <div class="alert alert-success">Mật khẩu đã được thay đổi thành công!</div>
                </c:if>
                <c:if test="${error eq 'true'}">
                    <div class="alert alert-danger">Lỗi khi thay đổi mật khẩu!</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/change-password" method="post">
                    <div class="form-group mb-3 input-icon">
                        <label for="oldPassword">Mật khẩu cũ</label>
                        <input type="password" name="oldPassword" id="oldPassword" class="form-control" required />
                        <i class="toggle-password fas fa-eye" toggle="#oldPassword"></i>
                    </div>
                    <div class="form-group mb-3 input-icon">
                        <label for="newPassword">Mật khẩu mới</label>
                        <input type="password" name="newPassword" id="newPassword" class="form-control" required />
                        <i class="toggle-password fas fa-eye" toggle="#newPassword"></i>
                        <small class="form-text">Ít nhất 1 chữ hoa, 1 chữ thường, 1 số và 6-8 ký tự</small>
                    </div>
                    <div class="form-group mb-3 input-icon">
                        <label for="confirmPassword">Xác nhận mật khẩu mới</label>
                        <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" required />
                        <i class="toggle-password fas fa-eye" toggle="#confirmPassword"></i>
                    </div>
                    <div class="modal-footer">
                        <a href="${pageContext.request.contextPath}/view-profile" class="btn btn-secondary">Hủy</a>

                        <button type="submit" class="btn btn-primary">Đổi mật khẩu</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    document.querySelectorAll(".toggle-password").forEach(icon => {
        icon.addEventListener("click", function () {
            const target = document.querySelector(this.getAttribute("toggle"));
            const type = target.getAttribute("type") === "password" ? "text" : "password";
            target.setAttribute("type", type);
            this.classList.toggle("fa-eye");
            this.classList.toggle("fa-eye-slash");
        });
    });
</script>
