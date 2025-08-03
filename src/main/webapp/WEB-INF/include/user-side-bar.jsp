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
            <a href="#">Quản lý đơn hàng</a>
            <a href="#">Sở địa chỉ</a>
            <a href="#">Thông báo</a>
            <a href="#">Điểm thành viên</a>
            <!-- Thêm mục Kho voucher -->
            <a href="ViewMyVoucher">Kho voucher</a>
            <a href="ViewWishlist">Danh sách yêu thích</a>
        </div>