<%@ page pageEncoding="UTF-8" %>
<style>
    .sidebar {
        position: fixed;
        top: 80px;
        left: 0;
        width: 220px;
        height: calc(100% - 80px);
        background-color: #ffffff;
        border-right: 1px solid #ddd;
        padding-top: 20px;
    }

    .sidebar a {
        display: block;
        padding: 14px 20px;
        color: #333;
        font-size: 16px;
        text-decoration: none;
    }

    .sidebar a:hover {
        background-color: #007bff;
        color: white;
    }
</style>

<!-- Sidebar Section -->
<div class="sidebar">
    <a href="view-profile">Thông tin tài khoản</a>
    <a href="ViewAddress">Sổ địa chỉ</a>
    <a href="change-password">Đổi mật khẩu</a>
    <a href="ViewMyVoucher">Kho voucher</a>
    <a href="ViewWishlist">Danh sách yêu thích</a>
</div>