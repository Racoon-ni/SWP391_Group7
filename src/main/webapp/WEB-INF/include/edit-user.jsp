<%-- 
    Document   : edit-user
    Created on : Jun 24, 2025, 10:35:07 PM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<title>Update User Status</title>

<style>
    .toggle-password {
        display: flex;
        transform: translateY(-50%);
        cursor: pointer;
        font-size: 1.2em;
        color: #333;
        margin-top: -18px;
        margin-right: 10px;
        justify-content: flex-end;
    }
</style>
<div class="container">
    <h1>Cập nhật trạng thái tài khoản</h1>

    <form method="POST" action="${pageContext.request.contextPath}/manage-user">
        <input type="hidden" name="action" value="edit" />        
        <input type="hidden" name="id" value="${requestScope.user.id}" />        

        <div class="form-group">
            <label>Tên đăng nhập</label>
            <input type="text" value="${requestScope.user.username}" class="form-control" readonly>
        </div>
        <br/>
        <div class="form-group">
            <label>Email:</label>
            <input type="text" value="${requestScope.user.email}" class="form-control" readonly>
        </div>

        <br/>
        <div class="form-group">
            <label>Vai trò:</label>
            <select name="role" class="form-control">
                <option value="Staff"
                        <c:if test="${not empty user && user.role == 'Staff'}">selected</c:if>>
                            Staff
                        </option>
                        <option value="Admin"
                        <c:if test="${not empty user && user.role == 'Admin'}">selected</c:if>>
                            Admin
                        </option>
                        <option value="Customer"
                        <c:if test="${not empty user && user.role == 'Customer'}">selected</c:if>>
                            Customer
                        </option>
                </select>   
            </div>

            <br/>
            <div class="form-group">
                <label>Trạng thái:</label>
                <select name="status" class="form-control">
                <c:choose>
                    <c:when test="${not empty user && user.status == true}">
                        <option value ="true" selected> Còn hoạt động </option>
                        <option value ="false">Dừng hoạt động</option>
                    </c:when>
                    <c:otherwise>
                        <option value ="true"> Còn hoạt động </option>
                        <option value ="false" selected>Dừng hoạt động</option>
                    </c:otherwise>
                </c:choose>


            </select>   
        </div>

        <br/>
        <button type="submit" class="btn btn-primary">Cập Nhật</button>
    </form>
</div>

<script>
    function togglePassword() {
        const passwordInput = document.getElementById("password");
        const icon = document.getElementById("togglePassword");
        const isPassword = passwordInput.type === "password";
        passwordInput.type = isPassword ? "text" : "password";
        icon.classList.toggle("fa-eye");
        icon.classList.toggle("fa-eye-slash");
    }
</script>