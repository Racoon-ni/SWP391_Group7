<%@ include file="/WEB-INF/include/header.jsp" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List" %>

<%
    List<String> errors = (List<String>) request.getAttribute("errors");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<style>
 .sidebar {
        position: fixed;
        top: 80px;
        left: 0;
        width: 250px;
        height: calc(100% - 80px);
        background-color: #f8f9fa;
        padding-top: 20px;
        border-right: 1px solid #ddd;
        z-index: 500;
    }
    .sidebar a {
        display: block;
        padding: 15px;
        color: #333;
        text-decoration: none;
        font-size: 18px;
    }
    .sidebar a:hover {
        background-color: #007bff;
        color: white;
    }
    </style>
<div class="sidebar">
    <a href="view-profile">Thông tin tài khoản</a>
    <a href="#">Quản lý đơn hàng</a>
    <a href="ViewAddress">Sổ địa chỉ</a>
    <a href="#">Thông báo</a>
    <a href="change-password">Đổi mật khẩu</a>
    <a href="ViewMyVoucher">Kho voucher</a>
    <a href="ViewWishlist">Danh sách yêu thích</a>
</div>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

<div style="display: flex; justify-content: center; align-items: flex-start; padding: 100px 1rem;">
    <div style="width: 100%; max-width: 500px; border: 1px solid #e0e0e0; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 16px rgba(0,0,0,0.05);">

        <!-- Header -->
        <div style="background: linear-gradient(135deg, #2563eb, #1d4ed8); color: white; font-weight: 600; font-size: 1.2rem; padding: 1.25rem;">
            Đổi mật khẩu
        </div>

        <!-- Body -->
        <div style="padding: 2rem; background-color: #fff;">
            <!-- Hiển thị thông báo -->
            <c:if test="${not empty errors}">
                <div class="alert alert-danger" style="color: #dc2626; background: #fee2e2; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                    <ul style="margin: 0; padding-left: 1rem;">
                        <c:forEach var="err" items="${errors}">
                            <li>${err}</li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>
            <c:if test="${param.success eq 'true'}">
                <div class="alert alert-success" style="color: #059669; background: #d1fae5; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                    Đổi mật khẩu thành công!
                </div>
            </c:if>
            <c:if test="${param.error eq 'true'}">
                <div class="alert alert-danger" style="color: #dc2626; background: #fee2e2; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                    Có lỗi xảy ra khi đổi mật khẩu. Vui lòng thử lại!
                </div>
            </c:if>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/change-password" method="post">
                <!-- Mật khẩu cũ -->
                <div class="mb-4 position-relative">
                    <label>Mật khẩu cũ</label>
                    <input type="password" name="oldPassword" id="oldPassword" class="form-control" required
                           style="width: 100%; padding: 10px 40px 10px 12px; border: 1px solid #ddd; border-radius: 8px;" />
                    <i class="toggle-password fas fa-eye"
                       toggle="#oldPassword"
                       style="position: absolute; top: 50%; right: 14px; transform: translateY(-50%); cursor: pointer; color: #999;"></i>
                </div>

                <!-- Mật khẩu mới -->
                <div class="mb-4 position-relative">
                    <label>Mật khẩu mới</label>
                    <input type="password" name="newPassword" id="newPassword" class="form-control" required
                           style="width: 100%; padding: 10px 40px 10px 12px; border: 1px solid #ddd; border-radius: 8px;" />
                    <i class="toggle-password fas fa-eye"
                       toggle="#newPassword"
                       style="position: absolute; top: 50%; right: 14px; transform: translateY(-50%); cursor: pointer; color: #999;"></i>
                    <small style="font-size: 0.75rem; color: #888;">Ít nhất 1 chữ hoa, 1 chữ thường, 1 số và 6–8 ký tự</small>
                </div>

                <!-- Nhập lại mật khẩu -->
                <div class="mb-4 position-relative">
                    <label>Xác nhận mật khẩu mới</label>
                    <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" required
                           style="width: 100%; padding: 10px 40px 10px 12px; border: 1px solid #ddd; border-radius: 8px;" />
                    <i class="toggle-password fas fa-eye"
                       toggle="#confirmPassword"
                       style="position: absolute; top: 50%; right: 14px; transform: translateY(-50%); cursor: pointer; color: #999;"></i>
                </div>

                <!-- Footer nút -->
                <hr />
                <div style="display: flex; justify-content: flex-end; gap: 1rem;">
                    <a href="${pageContext.request.contextPath}/view-profile"
                       class="btn"
                       style="border-radius: 8px; background-color: #f3f3f3; border: 1px solid #ccc; padding: 8px 20px;">
                        <u>Hủy</u>
                    </a>
                    <button type="submit"
                            class="btn"
                            style="border-radius: 8px; background-color: #2563eb; color: white; padding: 8px 20px; border: none;">
                        Đổi mật khẩu
                    </button>
                </div>
            </form>
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

    // Client-side validation
    document.querySelector("form").addEventListener("submit", function (e) {
        const oldPass = document.getElementById("oldPassword").value.trim();
        const newPass = document.getElementById("newPassword").value.trim();
        const confirmPass = document.getElementById("confirmPassword").value.trim();
        const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{6,8}$/;
        let errors = [];

        if (!oldPass || !newPass || !confirmPass) {
            errors.push("Vui lòng điền đầy đủ các trường.");
        }

        if (oldPass === newPass) {
            errors.push("Mật khẩu mới không được trùng với mật khẩu cũ.");
        }


        if (!regex.test(newPass)) {
            errors.push("Mật khẩu mới phải từ 6–8 ký tự, gồm chữ hoa, chữ thường và số.");
        }

        if (newPass !== confirmPass) {
            errors.push("Xác nhận mật khẩu không khớp.");
        }

        if (errors.length > 0) {
            e.preventDefault();
            alert(errors.join("\n"));
        }
    });
</script>