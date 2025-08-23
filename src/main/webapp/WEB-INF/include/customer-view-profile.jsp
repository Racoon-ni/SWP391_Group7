<%@ include file="/WEB-INF/include/header.jsp" %>
<%@page import="model.User"%>
<%@page import="DAO.CustomerDAO"%>

<%@ page pageEncoding="UTF-8" %>
<%@ page import="model.Customer" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<title>Thông tin khách hàng</title>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    .main-content {
        margin-left: 280px;
        padding: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .form-container {
        background: white;
        border-radius: 20px;
        padding: 40px;
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        width: 100%;
        max-width: 600px;
        position: relative;
        overflow: hidden;
    }

    .form-container::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 5px;
        background: linear-gradient(90deg, #667eea, #764ba2);
    }

    .form-title {
        font-size: 32px;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 10px;
        text-align: center;
    }

    .form-subtitle {
        color: #7f8c8d;
        font-size: 16px;
        text-align: center;
        margin-bottom: 30px;
    }

    .form-label {
        font-weight: 600;
        font-size: 16px;
        color: #2c3e50;
        margin-bottom: 8px;
    }

    .form-control:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
    }

    .btn-update {
        background: #1834c4;
        color: white;
        border: none;
        border-radius: 12px;
        font-size: 18px;
        font-weight: 600;
        padding: 12px;
        width: 100%;
    }

    .btn-update:hover {
        box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        transform: translateY(-2px);
    }

    .error-message {
        color: #e74c3c;
        font-size: 14px;
        margin-top: 8px;
        display: flex;
        align-items: center;
        gap: 5px;
    }
    .error-message::before {
        content: '⚠';
        font-size: 12px;
    }
</style>

<%@ include file="../include/user-side-bar.jsp" %>

<div class="main-content">
    <div class="form-container">
        <h1 class="form-title">Thông tin khách hàng</h1>
        <p class="form-subtitle">Cập nhật thông tin cá nhân của bạn</p>

        <% if (success != null) { %>
        <div class="alert alert-success">Cập nhật thông tin thành công!</div>
        <% } else if (error != null) { %>
        <div class="alert alert-danger">Có lỗi xảy ra khi cập nhật thông tin.</div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/update-profile">
            <div class="mb-3">
                <label class="form-label">Họ tên</label>
                <input type="text" name="fullName" value="${customer.fullName}" class="form-control" required />
                <c:if test="${not empty errorFullName}">
                    <div class="error-message">${errorFullName}</div>
                </c:if>
            </div>

            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" value="${customer.email}" class="form-control" required />
                <c:if test="${not empty errorEmail}">
                    <div class="error-message">${errorEmail}</div>
                </c:if>
            </div>

            <div class="mb-3">
                <label class="form-label">Giới tính</label>
                <select name="gender" class="form-select">
                    <option value="Nam" ${customer.gender eq 'Nam' ? 'selected="selected"' : ''}>Nam</option>
                    <option value="Nữ" ${customer.gender eq 'Nữ' ? 'selected="selected"' : ''}>Nữ</option>
                    <option value="Khác" ${customer.gender eq 'Khác' ? 'selected="selected"' : ''}>Khác</option>
                </select>
                <c:if test="${not empty errorGender}">
                    <div class="error-message">${errorGender}</div>
                </c:if>
            </div>

            <div class="mb-3">
                <label class="form-label">Ngày sinh</label>
                <input type="date" name="dob" value="${customer.dateOfBirth}" class="form-control" required />
                <c:if test="${not empty errorDob}">
                    <div class="error-message">${errorDob}</div>
                </c:if>
            </div>

            <div class="mb-3">
                <label class="form-label">Số điện thoại</label>
                <input type="text" name="phone" value="${customer.phone}" class="form-control" required />
                <c:if test="${not empty errorPhone}">
                    <div class="error-message">${errorPhone}</div>
                </c:if>
            </div>

            <button type="submit" class="btn-update">Cập nhật thông tin</button>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/include/footer.jsp" %>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
