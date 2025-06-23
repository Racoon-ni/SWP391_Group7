
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
    .user-ma{
        margin: 0;
    }

    .wrapper {
        display: flex;
    }

    .sidebar {
        width: 250px;
        height: 100vh; /* Chiều cao toàn màn hình */
        background-color: #343a40; /* Màu nền xám đậm */
        color: white;
        position: fixed;
        top: 0;
        left: 0;
        padding-top: 80px;
        display: flex;
        flex-direction: column;
    }

    .content-wrapper {
        flex: 1; /* Để chiếm hết phần còn lại của màn hình */
        margin-left: 250px; /* Để tránh bị che */
        padding: 20px;
    }


    .sidebar-title {
        text-align: center;
        margin-bottom: 20px;
        font-size: 20px;
        font-weight: bold;
    }

    .sidebar a {
        color: white;
        text-decoration: none;
        display: flex;
        align-items: center;
        padding: 12px 20px;
        transition: background 0.3s;
    }

    .sidebar a i {
        margin-right: 10px;
    }

    .sidebar a:hover,
    .sidebar a.active {
        background-color: #007bff; /* Màu xanh khi hover hoặc active */
        border-left: 4px solid white;
    }

    /* Nút đăng xuất */
    .logout-container {
        margin-top: auto;
        padding: 20px;
        text-align: center;
    }

    .logout-btn {
        color: white;
        background-color: red;
        padding: 10px;
        border-radius: 5px;
        display: inline-block;
        transition: background 0.3s;
    }

    .logout-btn:hover {
        background-color: darkred;
    }

    /* Nội dung chính */
    .main-content {
        margin-left: 250px; /* Đẩy nội dung ra xa sidebar */
        padding: 20px;
        width: calc(100% - 250px);
    }
</style>

<!-- Sidebar -->
<div class="sidebar">
    <h4 class="sidebar-title">Dashboard</h4> 

    <a href="#">
        <i class="fa-solid fa-square-poll-vertical"></i> Thống kê bán hàng
    </a>

    <a href="${pageContext.request.contextPath}/manage-pc">
        <i class="fa-solid fa-computer"></i>Quản lý PC
    </a>

    <a href="#">
        <i class="fas fa-users"></i> Quản lý linh kiện
    </a>

    <a href="#">
        <i class="fas fa-users"></i> Quản lý nhân viên
    </a>

    <a href="#">
        <i class="fas fa-users"></i> Quản lý khách hàng
    </a>

    <a href="#">
        <i class="fas fa-users"></i> Quản lý phản hồi
    </a>

    <a href="#">
        <i class="fas fa-users"></i> Quản lý thể loại
    </a>
    
    <a href="${pageContext.request.contextPath}/manage-orders">
        <i class="fas fa-shopping-cart"></i> Quản lý đơn hàng
    </a>

    <a href="#">
        <i class="fas fa-shopping-cart"></i> Quản lý Voucher
    </a>

    <!-- Logout button -->
    <div class="logout-container">
        <a href="#" class="logout-btn" id="logoutButton">
            <i class="fas fa-sign-out-alt"></i> Đăng xuất
        </a>
    </div>
</div>

<!-- Modal xác nhận đăng xuất -->
<div class="modal fade" id="logoutModal" tabindex="-1" aria-labelledby="logoutModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="logoutModalLabel">Xác nhận đăng xuất</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Bạn có chắc chắn muốn đăng xuất không?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <a href="#" class="btn btn-danger">
                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap Bundle (gồm Popper) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>


<!-- Fix lỗi modal bị đen màn hình -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        var logoutModal = new bootstrap.Modal(document.getElementById("logoutModal"));
        document.getElementById("logoutButton").addEventListener("click", function (event) {
            event.preventDefault();
            logoutModal.show();
        });

        document.getElementById("logoutModal").addEventListener("hidden.bs.modal", function () {
            document.querySelectorAll(".modal-backdrop").forEach(el => el.remove());
            document.body.classList.remove("modal-open");
            document.body.style.overflow = "";
        });
    });
</script>