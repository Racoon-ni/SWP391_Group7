<%@include file="../include/header.jsp" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="model.Customer" %>
<%
    Customer customer = (Customer) request.getAttribute("customer");
%>
<title>Thông tin khách hàng</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f6f9;
        margin: 0;
        padding: 0;
    }

    /* Phần header */
    .header {
        background-color: #fff;
        padding: 20px;
        border-bottom: 1px solid #e1e1e1;
        display: flex;
        justify-content: space-between;
        align-items: center;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        z-index: 1000;
    }

    .header .logo {
        font-size: 24px;
        font-weight: bold;
        color: #005cbf;
    }

    .header .search-bar {
        border: 1px solid #ccc;
        padding: 8px;
        border-radius: 5px;
        width: 300px;
    }

    .header .user-info {
        font-size: 16px;
        color: #333;
    }

    /* Sidebar */
    .sidebar {
        position: fixed;
        top: 80px; /* Khoảng cách từ header */
        left: 0;
        width: 250px;
        height: calc(100% - 80px); /* Chiều cao sidebar */
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

    /* Phần chính */
    .main-content {
        margin-left: 250px;
        margin-top: 80px; /* Khoảng cách từ header */
        padding: 40px;
        max-width: 800px;
        margin: auto;
    }

    .container {
        background-color: white;
        border-radius: 10px;
        padding: 30px;
        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
    }

    .container h2 {
        color: #333;
        text-align: center;
        margin-bottom: 20px;
    }

    .form-field {
        margin-bottom: 20px;
    }

    .form-field label {
        font-weight: bold;
        font-size: 16px;
        display: block;
        margin-bottom: 5px;
    }

    .form-field input {
        width: 100%;
        padding: 10px;
        border-radius: 5px;
        border: 1px solid #ccc;
        background-color: #f1f1f1;
        font-size: 14px;
        color: #555;
    }

    .update-btn {
        width: 100%;
        padding: 12px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
    }

    .update-btn:hover {
        background-color: #0056b3;
    }

    .back-link {
        display: block;
        text-align: center;
        margin-top: 20px;
        font-size: 16px;
        color: #007bff;
        text-decoration: none;
    }

    .back-link:hover {
        text-decoration: underline;
    }

    /* Pop-up modal */
    .modal {
        display: none; /* Ẩn modal mặc định */
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }

    .modal-content {
        background-color: white;
        padding: 20px;
        border-radius: 10px;
        width: 400px;
        max-width: 90%;
    }

    .modal-content input {
        width: 100%;
        padding: 10px;
        margin-bottom: 10px;
        border-radius: 5px;
        border: 1px solid #ccc;
    }

    .close-btn {
        background-color: #dc3545;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
    }

    .close-btn:hover {
        background-color: #c82333;
    }

    .edit-btn {
        background-color: #28a745;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    .edit-btn:hover {
        background-color: #218838;
    }
</style>

<!-- Header Section -->
<div class="header">
    <div class="logo">PC Store</div>
    <input type="text" class="search-bar" placeholder="Tìm kiếm...">
    <div class="user-info">
        <span>Chào bạn Long</span>
    </div>
</div>

<!-- Sidebar Section -->
<div class="sidebar">
    <a href="view-profile">Thông tin tài khoản</a>
    <a href="#">Quản lý đơn hàng</a>
    <a href="#">Sở địa chỉ</a>
    <a href="#">Thông báo</a>
    <a href="#">Điểm thành viên</a>
    <!-- Thêm mục Kho voucher -->
    <a href="#">Kho voucher</a>
</div>

<!-- Main Content Section -->
<div class="main-content">
    <div class="container">
        <h2>Thông tin khách hàng</h2>

        <div class="form-field">
            <label>Họ tên</label>
            <input type="text" name="fullName" value="<%= customer.getFullName()%>" readonly id="fullName" />
        </div>


        <div class="form-field">
            <label>Email</label>
            <input type="text" name="email" value="<%= customer.getEmail()%>" readonly id="email" />
        </div>

        <button class="update-btn" id="editBtn">Chỉnh sửa</button>

 
    </div>
</div>

<!-- Modal for Edit Profile -->
<div class="modal" id="editModal">
    <div class="modal-content">
        <h3>Chỉnh sửa thông tin</h3>

        <form id="editForm">
            <div class="form-field">
                <label>Họ tên</label>
                <input type="text" name="fullName" value="<%= customer.getFullName()%>" id="editFullName" />
            </div>


            <div class="form-field">
                <label>Email</label>
                <input type="text" name="email" value="<%= customer.getEmail()%>" id="editEmail" />
            </div>

            <button type="submit" class="edit-btn">Cập nhật</button>
            <button type="button" class="close-btn" id="closeModal">Đóng</button>
        </form>
    </div>
</div>

<script>
    // Hiển thị popup khi nhấn "Chỉnh sửa"
    document.getElementById('editBtn').onclick = function () {
        document.getElementById('editModal').style.display = 'flex';
    };

    // Đóng popup
    document.getElementById('closeModal').onclick = function () {
        document.getElementById('editModal').style.display = 'none';
    };

    // Sự kiện cập nhật thông tin
    document.getElementById('editForm').onsubmit = function (event) {
        event.preventDefault();
        alert('Thông tin đã được cập nhật');
        document.getElementById('editModal').style.display = 'none';
    };
</script>

<%@include file="../include/footer.jsp" %>
