<%-- 
    Document   : pc-list
    Created on : Jun 18, 2025, 8:50:06 PM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@page import="model.PC"%>
<%@page import="java.util.ArrayList"%>
<%@ page pageEncoding="UTF-8" %>
<%@include file="../include/admin-side-bar.jsp" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<title>PCs List</title>

<%    ArrayList<PC> pcList = (ArrayList<PC>) request.getAttribute("pcList");
%>
<div class="main-content">
    <div class="d-flex justify-content-end">
        <a href="${pageContext.request.contextPath}/manage-pc?view=add" class="btn btn-success">
            <i class="fa-solid fa-square-plus"></i> Thêm PC
        </a>
    </div>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th scope="col" style="text-align: center">ID</th>
                <th scope="col">Name</th>
                <th scope="col">Description</th>
                <th scope="col">Price</th>
                <th scope="col">Stock</th>
                <th scope="col">Image</th>
                <th scope="col">Status</th>
                <th scope="col">Category Name</th>
                <th scope="col" style="text-align: center">Action</th>
            </tr>
        </thead>
        <tbody class="table-group-divider">
            <%      for (PC pc : pcList) {
            %>
            <tr>
                <th scope="row" style="text-align: center"><%= pc.getId()%></th>
                <td scope="row"><%= pc.getName()%></td>
                <td><%= pc.getDescription()%></td>
                <td><%= pc.getPrice()%></td>
                <td><%= pc.getPrice()%></td>
                <td><%= pc.getImageUrl()%></td>
                <td><%= pc.isStatus() ? "Còn bán" : "Hết hàng"%></td>
                <td><%= pc.getCategory().getName()%></td>
                <td class="d-flex justify-content-center gap-2" style="text-align: center">

                    <a href="${pageContext.request.contextPath}/manage-pc?view=edit&id=<%= pc.getId()%>" class="btn btn-warning">
                        <i class="fa-solid fa-pen-to-square"></i>
                    </a>

                    <!-- Delete button for each PC -->
                    <a href="#" class="btn btn-danger" data-bs-toggle="modal"
                       data-bs-target="#deleteModal"
                       data-pcid="<%= pc.getId()%>">
                        <i class="fa-solid fa-trash"></i>
                    </a>

                    <!-- One shared modal -->
                    <%@ include file="delete-pc.jsp" %>

                </td>

            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>