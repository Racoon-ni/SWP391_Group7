<%@ include file="/WEB-INF/include/header.jsp" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="model.Customer" %>
<%@ page import="java.util.List" %>
<%
    Customer customer = (Customer) request.getAttribute("customer");
    List<String> errors = (List<String>) request.getAttribute("errors");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<title>Thông tin khách hàng</title>

<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f6f9;
        margin: 0;
        padding: 0;
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
    .main-content {
        margin-left: 250px;
        margin-top: 80px;
        display: flex;
        justify-content: center; /* căn giữa ngang */
        padding: 40px;
    }
    .container {
        background-color: white;
        border-radius: 10px;
        padding: 30px;
        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        width: 100%;
        max-width: 600px; /* cố định độ rộng */
    }

    h2 {
        text-align: center;
        color: #333;
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
    .form-field input,
    .form-field select {
        width: 100%;
        padding: 10px;
        border-radius: 5px;
        border: 1px solid #ccc;
        background-color: #f1f1f1;
        font-size: 14px;
        color: #555;
    }
    .btn-update {
        width: 100%;
        padding: 12px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
    }
    .btn-update:hover {
        background-color: #0056b3;
    }
    .alert {
        padding: 12px;
        margin-bottom: 15px;
        border-radius: 5px;
        font-size: 14px;
    }
    .alert-success {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }
    .alert-error {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }
</style>

<!-- Sidebar -->
<div class="sidebar">
    <a href="view-profile">Thông tin tài khoản</a>
    <a href="#">Quản lý đơn hàng</a>
    <a href="#">Sổ địa chỉ</a>
    <a href="#">Thông báo</a>
    <a href="#">Điểm thành viên</a>
    <a href="change-password">Đổi mật khẩu</a>
    <a href="ViewVouchers">Kho voucher</a>
    <a href="ViewWishlist">Danh sách yêu thích</a>
</div>

<!-- Main content -->
<div class="main-content">
    <div class="container">
        <h2>Thông tin khách hàng</h2>

        <% if (success != null) { %>
        <div class="alert alert-success">Cập nhật thông tin thành công!</div>
        <% } else if (error != null) { %>
        <div class="alert alert-error">Có lỗi xảy ra khi cập nhật thông tin.</div>
        <% } %>

        <% if (errors != null && !errors.isEmpty()) { %>
        <div class="alert alert-error">
            <ul>
                <% for (String err : errors) {%>
                <li><%= err%></li>
                    <% } %>
            </ul>
        </div>
        <% }%>

        <form method="post" action="${pageContext.request.contextPath}/update-profile">
            <div class="form-field">
                <label>Họ tên</label>
                <input type="text" name="fullName" value="<%= customer.getFullName()%>" required />
            </div>

            <div class="form-field">
                <label>Email</label>
                <input type="email" name="email" value="<%= customer.getEmail()%>" required />
            </div>

            <div class="form-field">
                <label>Giới tính</label>
                <select name="gender">
                    <option value="Nam" <%= "Nam".equals(customer.getGender()) ? "selected" : ""%>>Nam</option>
                    <option value="Nữ" <%= "Nữ".equals(customer.getGender()) ? "selected" : ""%>>Nữ</option>
                    <option value="Khác" <%= "Khác".equals(customer.getGender()) ? "selected" : ""%>>Khác</option>
                </select>
            </div>

            <div class="form-field">
                <label>Ngày sinh</label>
                <input type="date" name="dob" value="<%= customer.getDateOfBirth()%>" required />
            </div>

            <div class="form-field">
                <label>Số điện thoại</label>
                <input type="text" name="phone" value="<%= customer.getPhone()%>" required />
            </div>

            <div class="form-field">
                <label>Địa chỉ</label>
                <input type="text" name="address" value="<%= customer.getAddress()%>" required />
            </div>

            <button type="submit" class="btn-update">Cập nhật thông tin</button>
        </form>
    </div>
</div>
