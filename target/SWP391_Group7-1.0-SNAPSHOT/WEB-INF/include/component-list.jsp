<%-- 
    Document   : pc-list
    Created on : Jun 18, 2025, 8:50:06 PM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@page import="model.Component"%>
<%@page import="java.util.ArrayList"%>
<%@ page pageEncoding="UTF-8" %>
<%@include file="../include/admin-side-bar.jsp" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<title>PCs List</title>

<%
    ArrayList<Component> componentList = (ArrayList<Component>) request.getAttribute("componentList");
%>
<div class="main-content">
    <div class="d-flex justify-content-end">
        <a href="${pageContext.request.contextPath}/manage-component?view=add" class="btn btn-success">
            <i class="fa-solid fa-square-plus"></i> Thêm Linh Kiện
        </a>
    </div>
    <%
        if (!componentList.isEmpty() && componentList != null) {
    %>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th scope="col" style="text-align: center">ID</th>
                <th scope="col">Tên</th>
                <th scope="col">Mô tả</th>
                <th scope="col">Giá</th>
                <th scope="col">Tồn kho</th>
                <th scope="col">Ảnh</th>
                <th scope="col">Trạng thái</th>
                <th scope="col">Thể loại</th>
                <th scope="col" style="text-align: center">Chức năng</th>
            </tr>
        </thead>
        <tbody class="table-group-divider">
            <%
                for (Component comp : componentList) {
            %>
            <tr>
                <th scope="row" style="text-align: center"><%= comp.getId()%></th>
                <td scope="row"><%= comp.getName()%></td>
                <td><%= comp.getDescription()%></td>
                <td><%= comp.getPrice()%></td>
                <td><%= comp.getStock()%></td>
                <td><%= comp.getImageUrl()%></td>
                <td><%= comp.isStatus() ? "Còn bán" : "Hết hàng"%></td>
                <td><%= comp.getCategory().getName()%></td>
                <td class="d-flex justify-content-center gap-2" style="text-align: center">

                    <a href="${pageContext.request.contextPath}/manage-component?view=edit&id=<%= comp.getId()%>" class="btn btn-warning">
                        <i class="fa-solid fa-pen-to-square"></i>
                    </a>

                    <!-- Delete button for each PC -->
                    <a href="#" class="btn btn-danger" data-bs-toggle="modal"
                       data-bs-target="#deleteModal"
                       data-pcid="<%= comp.getId()%>">
                        <i class="fa-solid fa-trash"></i>
                    </a>

                    <!-- One shared modal -->
                    <%@ include file="delete-component.jsp" %>

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