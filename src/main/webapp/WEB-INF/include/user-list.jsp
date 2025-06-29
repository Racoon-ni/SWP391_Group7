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
<title>Danh sách tài khoản</title>

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
                <th scope="col">Họ và Tên</th>
                <th scope="col">Ngày Sinh</th>
                <th scope="col">Địa Chỉ</th>
                <th scope="col">Số Điện Thoại</th>
                <th scope="col">Vai trò</th>
                <th scope="col">Trạng thái</th>
                <th scope="col" style="text-align: center">Chức năng</th>
            </tr>
        </thead>
        <tbody class="table-group-divider">
            <%
                for (User user : userList) {
            %>
            <tr>
                <th scope="row" style="text-align: center"><%= user.getId()%></th>
                <td scope="row"><%= user.getUsername()%></td>
                <td><%= user.getEmail()%></td>
                <td><%= user.getFullname()%></td>
                <td><%= user.getDateOfBirth()%></td>
                <td><%= user.getAddress()%></td>
                <td><%= user.getPhone()%></td>
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
    <p>Không có tài khoản nào trong danh sách này</p>
    <%
        }
    %>
</div>