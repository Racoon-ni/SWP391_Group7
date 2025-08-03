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
:root {
    --primary-color: #2563eb;
    --primary-hover: #1d4ed8;
    --primary-light: #dbeafe;
    --success-color: #059669;
    --success-light: #d1fae5;
    --error-color: #dc2626;
    --error-light: #fee2e2;
    --gray-50: #f9fafb;
    --gray-100: #f3f4f6;
    --gray-200: #e5e7eb;
    --gray-300: #d1d5db;
    --gray-400: #9ca3af;
    --gray-500: #6b7280;
    --gray-600: #4b5563;
    --gray-700: #374151;
    --gray-800: #1f2937;
    --gray-900: #111827;
    --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
    --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
    --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
    --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    --border-radius: 8px;
    --border-radius-lg: 12px;
    --transition: all 0.15s cubic-bezier(0.4, 0, 0.2, 1);
}

* {
    box-sizing: border-box;
}

body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    line-height: 1.5;
    color: var(--gray-900);
    margin: 0;
    padding: 0;
}

.modal-dialog {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    padding: 1rem;
}

.modal-content {
    width: 100%;
    max-width: 448px;
    border-radius: var(--border-radius-lg);
    box-shadow: var(--shadow-xl);
    overflow: hidden;
    border: 1px solid var(--gray-200);
    background: white;
}

.modal-header {
    background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-hover) 100%);
    color: white;
    font-weight: 600;
    font-size: 1.25rem;
    padding: 1.5rem;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    letter-spacing: -0.025em;
}

.modal-body {
    background-color: var(--gray-50);
    padding: 2rem;
}

.form-group {
    margin-bottom: 1.5rem;
    position: relative;
}

.form-group label {
    font-size: 0.875rem;
    font-weight: 600;
    margin-bottom: 0.5rem;
    display: block;
    color: var(--gray-700);
    letter-spacing: 0.025em;
}

.form-control {
    width: 100%;
    padding: 0.75rem 3rem 0.75rem 1rem;
    border-radius: var(--border-radius);
    border: 2px solid var(--gray-300);
    font-size: 0.875rem;
    line-height: 1.25rem;
    color: var(--gray-900);
    background-color: white;
    transition: var(--transition);
    outline: none;
}

.form-control:focus {
    border-color: var(--primary-color);
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

.form-control:invalid {
    border-color: var(--error-color);
}

.form-control:invalid:focus {
    border-color: var(--error-color);
    box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1);
}

.toggle-password {
    position: absolute;
    top: 50%;
    right: 0.75rem;
    transform: translateY(-50%);
    cursor: pointer;
    font-size: 1rem;
    color: var(--gray-400);
    transition: var(--transition);
    padding: 0.25rem;
    border-radius: 4px;
}

.toggle-password:hover {
    color: var(--primary-color);
    background: var(--primary-light);
}

.form-text {
    font-size: 0.75rem;
    color: var(--gray-500);
    margin-top: 0.25rem;
    line-height: 1.25rem;
}

.modal-footer {
    padding: 1.5rem 2rem;
    background-color: var(--gray-50);
    border-top: 1px solid var(--gray-200);
    display: flex;
    justify-content: flex-end;
    gap: 0.75rem;
}

.btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0.625rem 1.5rem;
    border-radius: var(--border-radius);
    font-size: 0.875rem;
    font-weight: 500;
    line-height: 1.25rem;
    border: 2px solid;
    cursor: pointer;
    transition: var(--transition);
    text-decoration: none;
    outline: none;
    letter-spacing: 0.025em;
}

.btn:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}

.btn-primary {
    background-color: var(--primary-color);
    border-color: var(--primary-color);
    color: white;
}

.btn-primary:hover:not(:disabled) {
    background-color: var(--primary-hover);
    border-color: var(--primary-hover);
    transform: translateY(-1px);
    box-shadow: var(--shadow-md);
}

.btn-primary:focus {
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.2);
}

.btn-secondary {
    background-color: white;
    border-color: var(--gray-300);
    color: var(--gray-700);
}

.btn-secondary:hover:not(:disabled) {
    background-color: var(--gray-50);
    border-color: var(--gray-400);
    transform: translateY(-1px);
    box-shadow: var(--shadow-md);
}

.alert {
    padding: 1rem;
    border-radius: var(--border-radius);
    margin-bottom: 1.5rem;
    border: 1px solid;
    animation: slideIn 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.alert-success {
    background: var(--success-light);
    border-color: #a7f3d0;
    color: var(--success-color);
}

.alert-danger {
    background: var(--error-light);
    border-color: #fecaca;
    color: var(--error-color);
}

@keyframes slideIn {
    from {
        opacity: 0;
        transform: translateY(-0.5rem);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.spinner {
    animation: spin 1s linear infinite;
    margin-left: 0.5rem;
}

@keyframes spin {
    from {
        transform: rotate(0deg);
    }
    to {
        transform: rotate(360deg);
    }
}

/* Responsive Design */
@media (max-width: 640px) {
    .modal-dialog {
        padding: 0.5rem;
    }

    .modal-body {
        padding: 1.5rem;
    }

    .modal-footer {
        flex-direction: column-reverse;
        padding: 1.5rem;
    }

    .btn {
        width: 100%;
        justify-content: center;
    }
}

/* Focus management for accessibility */
.form-control:focus-visible,
.btn:focus-visible,
.toggle-password:focus-visible {
    outline: 2px solid var(--primary-color);
    outline-offset: 2px;
}

/* High contrast mode support */
@media (prefers-contrast: high) {
    .form-control {
        border-width: 2px;
    }
    
    .btn {
        border-width: 2px;
    }
}

/* Reduced motion support */
@media (prefers-reduced-motion: reduce) {
    * {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
    }
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
