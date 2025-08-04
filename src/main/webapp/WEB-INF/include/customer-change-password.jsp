<%@ include file="/WEB-INF/include/header.jsp" %>
<%@ page pageEncoding="UTF-8" %>
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
    .container-form {
        display: flex;
        justify-content: center;
        padding: 100px 1rem;
    }

    .form-box {
        width: 100%;
        max-width: 500px;
        border-radius: var(--radius);
        border: 1px solid var(--gray);
        background: white;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
    }

    .form-header {
        background: linear-gradient(135deg, var(--primary), var(--primary-hover));
        color: white;
        padding: 1.25rem;
        font-size: 1.2rem;
        font-weight: bold;
    }

    .form-body {
        padding: 2rem;
    }

    .form-footer {
        display: flex;
        justify-content: flex-end;
        gap: 1rem;
        padding-top: 1.5rem;
        border-top: 1px solid #eee;
    }


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
    <a href="my-orders">Quản lý đơn hàng</a>
    <a href="ViewAddress">Sổ địa chỉ</a>
    <a href="notifications">Thông báo</a>
    <a href="change-password">Đổi mật khẩu</a>
    <a href="ViewVouchers">Kho voucher</a>
    <a href="ViewWishlist">Danh sách yêu thích</a>
</div>


<div style="display: flex; justify-content: center; align-items: flex-start; padding: 100px 1rem;">
    <div style="width: 100%; max-width: 500px; border: 1px solid #e0e0e0; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 16px rgba(0,0,0,0.05);">

        <!-- Header -->
        <div style="background: linear-gradient(135deg, #2563eb, #1d4ed8); color: white; font-weight: 600; font-size: 1.2rem; padding: 1.25rem;">
            Đổi mật khẩu
        </div>

        <!-- Body -->
        <div style="padding: 2rem; background-color: #fff;">
            <form action="${pageContext.request.contextPath}/change-password" method="post">

                <!-- Mật khẩu cũ -->
                <div class="mb-4 position-relative">
                    <label style="font-weight: 600; margin-bottom: 6px; display: block;">Mật khẩu cũ</label>
                    <input type="password" name="oldPassword" id="oldPassword"
                           class="form-control pe-5"
                           style="border-radius: 8px; border: 1px solid #ddd; padding: 10px 40px 10px 12px;" required />
                    <i class="toggle-password fas fa-eye"
                       toggle="#oldPassword"
                       style="position: absolute; top: 50%; right: 14px; transform: translateY(-50%); cursor: pointer; color: #999;"></i>
                </div>

                <!-- Mật khẩu mới -->
                <div class="mb-4 position-relative">
                    <label style="font-weight: 600; margin-bottom: 6px; display: block;">Mật khẩu mới</label>
                    <input type="password" name="newPassword" id="newPassword"
                           class="form-control pe-5"
                           style="border-radius: 8px; border: 1px solid #ddd; padding: 10px 40px 10px 12px;" required />
                    <i class="toggle-password fas fa-eye"
                       toggle="#newPassword"
                       style="position: absolute; top: 50%; right: 14px; transform: translateY(-50%); cursor: pointer; color: #999;"></i>
                    <small style="font-size: 0.75rem; color: #888;">Ít nhất 1 chữ hoa, 1 chữ thường, 1 số và 6-8 ký tự</small>
                </div>

                <!-- Xác nhận mật khẩu -->
                <div class="mb-4 position-relative">
                    <label style="font-weight: 600; margin-bottom: 6px; display: block;">Xác nhận mật khẩu mới</label>
                    <input type="password" name="confirmPassword" id="confirmPassword"
                           class="form-control pe-5"
                           style="border-radius: 8px; border: 1px solid #ddd; padding: 10px 40px 10px 12px;" required />
                    <i class="toggle-password fas fa-eye"
                       toggle="#confirmPassword"
                       style="position: absolute; top: 50%; right: 14px; transform: translateY(-50%); cursor: pointer; color: #999;"></i>
                </div>

                <!-- Footer nút -->
                <hr />
                <div class="d-flex justify-content-end gap-3 mt-3">
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
</script>
