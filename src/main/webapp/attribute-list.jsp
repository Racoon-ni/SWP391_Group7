<%-- 
    Document   : attribute-list
    Created on : Jul 25, 2025, 10:32:48 AM
    Author     : ThinhLVCE181726 <your.name at your.org>
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Thuộc tính</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
    <style>
        body { background: #f6f7fb; }
        .container { max-width: 900px; margin-top: 36px; }
        .table thead { background: #1450bd; color: #fff; }
        .action-btns a { margin-right: 8px; }
        .page-title { font-size: 2rem; font-weight: 700; color: #1450bd; margin-bottom: 20px; }
    </style>
</head>
<body>
<div class="container bg-white p-4 shadow rounded-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div class="page-title">Quản lý Thuộc tính</div>
        <a href="attribute-create" class="btn btn-success rounded-3 fw-bold px-4">
            + Thêm mới
        </a>
    </div>
    <table class="table align-middle">
        <thead>
            <tr>
                <th>#</th>
                <th>Tên thuộc tính</th>
                <th>Đơn vị</th>
                <th>Danh mục</th>
                <th style="width: 180px;">Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="attr" items="${attributes}">
                <tr>
                    <td>${attr.attributeId}</td>
                    <td class="fw-semibold">${attr.name}</td>
                    <td>
                        <c:choose>
                            <c:when test="${empty attr.unit}">-</c:when>
                            <c:otherwise>${attr.unit}</c:otherwise>
                        </c:choose>
                    </td>
                    <td>${attr.categoryName}</td>
                    <td class="action-btns">
                        <a href="attribute-edit?id=${attr.attributeId}" class="btn btn-warning btn-sm rounded-3">Sửa</a>
                        <a href="attribute-delete?id=${attr.attributeId}" class="btn btn-danger btn-sm rounded-3"
                            onclick="return confirm('Bạn có chắc chắn muốn xóa thuộc tính này?');">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty attributes}">
                <tr>
                    <td colspan="5" class="text-center text-muted py-4">Chưa có thuộc tính nào.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>
</body>
</html>
