<%-- 
    Document   : category-list
    Created on : Jul 25, 2025, 9:51:31 AM
    Author     : ThinhLVCE181726 <your.name at your.org>
--%>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Thể loại</title>
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
        <div class="page-title">Quản lý Thể loại</div>
        <a href="category-create" class="btn btn-success rounded-3 fw-bold px-4">
            + Thêm mới
        </a>
    </div>
    <table class="table align-middle">
        <thead>
            <tr>
                <th>#</th>
                <th>Tên thể loại</th>
                <th>Loại</th>
                <th>Danh mục cha</th>
                <th style="width: 180px;">Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="cat" items="${categories}">
                <tr>
                    <td>${cat.categoryId}</td>
                    <td class="fw-semibold">${cat.name}</td>
                    <td>
                        <span class="badge bg-primary">${cat.categoryType == 'PC' ? 'PC' : 'Linh kiện'}</span>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${cat.parentName == null}">—</c:when>
                            <c:otherwise>${cat.parentName}</c:otherwise>
                        </c:choose>
                    </td>
                    <td class="action-btns">
                        <a href="category-edit?id=${cat.categoryId}" class="btn btn-warning btn-sm rounded-3">Sửa</a>
                        <a href="category-delete?id=${cat.categoryId}" class="btn btn-danger btn-sm rounded-3"
                            onclick="return confirm('Bạn có chắc chắn muốn xóa thể loại này?');">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty categories}">
                <tr>
                    <td colspan="5" class="text-center text-muted py-4">Chưa có thể loại nào.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>
</body>
</html>
