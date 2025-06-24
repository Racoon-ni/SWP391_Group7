<%-- 
    Document   : user-list
    Created on : Jun 24, 2025, 8:59:06 PM
    Author     : Huynh Trong Nguyen - CE190356
--%>
<%@page import="model.User"%>
<%@page import="java.util.ArrayList"%>
<%@ page pageEncoding="UTF-8" %>
<%@include file="../include/admin-side-bar.jsp" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<title>Users List</title>
<style>
    .password-wrapper {
        display: flex;
        align-items: center;
        gap: 4px;  /*spacing between stars and eye icon*/ 
        
    }

    .password-wrapper button {
        background: none;
        border: none;
        padding: 0;
        margin: 0;
        cursor: pointer;
    }

    .password-wrapper i {
        font-size: 14px;  adjust size 
        color: #444;
    }
</style>

<%
    ArrayList<User> userList = (ArrayList<User>) request.getAttribute("userList");
%>
<div class="main-content">
<!--    <div class="d-flex justify-content-end">
        <a href="${pageContext.request.contextPath}/manage-component?view=add" class="btn btn-success">
            <i class="fa-solid fa-square-plus"></i> Thêm tài khoản
        </a>
    </div>-->
    <%
        if (!userList.isEmpty() && userList != null) {
    %>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th scope="col" style="text-align: center">ID</th>
                <th scope="col">Tên đăng nhập</th>
                <th scope="col">Email</th>
                <th scope="col">Password đã mã hóa</th>
                <th scope="col">Vai trò</th>
                <th scope="col">Trạng thái</th>
                <th scope="col" style="text-align: center">Chức năng</th>
            </tr>
        </thead>
        <tbody class="table-group-divider">
            <%
                for (User user : userList) {
                    String spanId = "pwd" + user.getId();
            %>
            <tr>
                <th scope="row" style="text-align: center"><%= user.getId()%></th>
                <td scope="row"><%= user.getUsername()%></td>
                <td><%= user.getEmail()%></td>
                <td scope="row" style="text-align: center">
                    <div class="password-wrapper">
                        <span id="<%= spanId%>">**********************</span>
                        <button onclick="togglePwd('<%= spanId%>', this, '<%= user.getPassword()%>')" style="background:none; border:none; cursor:pointer;">
                            <i class="fa fa-eye"></i>
                        </button>
                    </div>
                </td>
                <td><%= user.getRole()%></td>
                <td><%= user.isStatus() ? "Còn hoạt động" : "Dừng hoạt động"%></td>
                <td class="d-flex justify-content-center gap-2" style="text-align: center">

                    <a href="${pageContext.request.contextPath}/manage-user?view=edit&id=<%= user.getId()%>" class="btn btn-warning">
                        <i class="fa-solid fa-pen-to-square"></i>
                    </a>

                </td>

            </tr>
            <%
                }
            } else {
            %>
        </tbody>
    </table>
    <p>Không có PC nào trong danh sách này</p>
    <%
        }
    %>
</div>
<script>
    function togglePwd(spanId, btn, realPwd) {
        const el = document.getElementById(spanId);
        const icon = btn.querySelector('i');

        if (el.textContent === '**********************') {
            el.textContent = realPwd;
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            el.textContent = '**********************';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }
</script>