<%-- 
    Document   : edit-user
    Created on : Jun 24, 2025, 10:35:07 PM
    Author     : Huynh Trong Nguyen - CE190356
--%>


<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<title>Cập nhật trạng thái tài khoản</title>
<%@include file="../include/admin-side-bar.jsp" %>
<style>
    body {
        background-color: #f0f7ff;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        padding: 30px 0;
    }
    
    .page-header {
        background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
        color: white;
        padding: 25px 30px;
        border-radius: 15px;
        margin-bottom: 30px;
        box-shadow: 0 10px 30px rgba(37, 117, 252, 0.2);
    }
    
    .card-container {
        background-color: white;
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        overflow: hidden;
        transition: transform 0.3s ease;
    }
    
    .card-container:hover {
        transform: translateY(-5px);
    }
    
    .card-header {
        background: linear-gradient(135deg, #13f1fc 0%, #0470dc 100%);
        color: white;
        padding: 20px 30px;
        font-weight: 600;
        font-size: 1.2rem;
        border-bottom: none;
    }
    
    .card-body {
        padding: 30px;
    }
    
    .form-group {
        margin-bottom: 25px;
        position: relative;
    }
    
    .form-label {
        font-weight: 600;
        color: #4a5568;
        margin-bottom: 8px;
        display: block;
    }
    
    .form-control {
        border-radius: 10px;
        padding: 12px 15px 12px 45px;
        border: 2px solid #e2e8f0;
        transition: all 0.3s ease;
        font-size: 1rem;
    }
    
    .form-control:focus {
        border-color: #3182ce;
        box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.3);
    }
    
    .form-control[readonly] {
        background-color: #f8fafc;
        border-style: dashed;
        color: #718096;
    }
    
    .input-icon {
        position: absolute;
        left: 15px;
        top: 42px;
        color: #a0aec0;
    }
    
    .btn-update {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border: none;
        padding: 12px 30px;
        border-radius: 50px;
        font-weight: 600;
        font-size: 1rem;
        color: white;
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        transition: all 0.3s;
        margin-right: 10px;
    }
    
    .btn-update:hover {
        transform: translateY(-3px);
        box-shadow: 0 7px 20px rgba(102, 126, 234, 0.6);
    }
    
    .btn-back {
        background: linear-gradient(135deg, #a1c4fd 0%, #c2e9fb 100%);
        border: none;
        padding: 12px 30px;
        border-radius: 50px;
        font-weight: 600;
        font-size: 1rem;
        color: #4a5568;
        box-shadow: 0 5px 15px rgba(161, 196, 253, 0.4);
        transition: all 0.3s;
    }
    
    .btn-back:hover {
        transform: translateX(-3px);
        box-shadow: 0 7px 20px rgba(161, 196, 253, 0.6);
    }
    
    /* Custom toggle switch */
    .toggle-container {
        display: flex;
        align-items: center;
        margin-top: 10px;
    }
    
    .toggle-switch {
        position: relative;
        display: inline-block;
        width: 60px;
        height: 34px;
        margin-right: 15px;
    }
    
    .toggle-switch input {
        opacity: 0;
        width: 0;
        height: 0;
    }
    
    .toggle-slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: #cbd5e0;
        transition: .4s;
        border-radius: 34px;
    }
    
    .toggle-slider:before {
        position: absolute;
        content: "";
        height: 26px;
        width: 26px;
        left: 4px;
        bottom: 4px;
        background-color: white;
        transition: .4s;
        border-radius: 50%;
    }
    
    input:checked + .toggle-slider {
        background-color: #48bb78;
    }
    
    input:focus + .toggle-slider {
        box-shadow: 0 0 1px #48bb78;
    }
    
    input:checked + .toggle-slider:before {
        transform: translateX(26px);
    }
    
    .status-text {
        font-weight: 600;
        font-size: 1rem;
    }
    
    .status-active {
        color: #48bb78;
    }
    
    .status-inactive {
        color: #e53e3e;
    }
    
    .user-info {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
    }
    
    .user-avatar {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        background: linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 15px;
        color: white;
        font-size: 1.5rem;
        font-weight: bold;
    }
    
    .user-name {
        font-size: 1.2rem;
        font-weight: 600;
        color: #4a5568;
    }
    
    .user-email {
        color: #718096;
        font-size: 0.9rem;
    }
</style>

<div class="container">

    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card-container">
                <div class="card-header">
                    <i class="fas fa-user-shield me-2"></i>Thông tin tài khoản
                </div>
                <div class="card-body">
                    <div class="user-info">
                        <div class="user-avatar">
                            ${requestScope.user.username.substring(0,1).toUpperCase()}
                        </div>
                        <div>
                            <div class="user-name">${requestScope.user.username}</div>
                            <div class="user-email">${requestScope.user.email}</div>
                        </div>
                    </div>

                    <form method="POST" action="${pageContext.request.contextPath}/manage-user">
                        <input type="hidden" name="action" value="edit" />        
                        <input type="hidden" name="id" value="${requestScope.user.id}" />        

                        <div class="form-group">
                            <label class="form-label">Tên đăng nhập</label>
                            <i class="fas fa-user input-icon"></i>
                            <input type="text" value="${requestScope.user.username}" class="form-control" readonly>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Email</label>
                            <i class="fas fa-envelope input-icon"></i>
                            <input type="text" value="${requestScope.user.email}" class="form-control" readonly>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Trạng thái tài khoản</label>
                            
                            <div class="toggle-container">
                                <label class="toggle-switch">
                                    <input type="checkbox" name="status" value="true" 
                                           ${not empty user && user.status == true ? 'checked' : ''} 
                                           onchange="updateStatusText(this)">
                                    <span class="toggle-slider"></span>
                                </label>
                                <span id="statusText" class="status-text ${not empty user && user.status == true ? 'status-active' : 'status-inactive'}">
                                    ${not empty user && user.status == true ? 'Còn hoạt động' : 'Dừng hoạt động'}
                                </span>
                            </div>
                        </div>

                        <div class="d-flex mt-4">
                            <button type="submit" class="btn btn-update">
                                <i class="fas fa-save me-2"></i>Cập Nhật
                            </button>
                            <a href="${pageContext.request.contextPath}/manage-user" class="btn btn-back">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function updateStatusText(checkbox) {
        const statusText = document.getElementById('statusText');
        if (checkbox.checked) {
            statusText.textContent = 'Còn hoạt động';
            statusText.classList.add('status-active');
            statusText.classList.remove('status-inactive');
        } else {
            statusText.textContent = 'Dừng hoạt động';
            statusText.classList.add('status-inactive');
            statusText.classList.remove('status-active');
        }
    }
</script>

