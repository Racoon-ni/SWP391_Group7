<%-- 
    Document   : category-edit
    Created on : Jul 25, 2025, 10:08:55 AM
    Author     : ThinhLVCE181726 <your.name at your.org>
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sửa Thể loại</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
    <style>
        body { background: #f6f7fb; }
        .container { max-width: 540px; margin-top: 60px; }
        .form-title { font-size: 1.7rem; font-weight: 700; color: #1450bd; margin-bottom: 24px; }
    </style>
</head>
<body>
<div class="container bg-white p-4 shadow rounded-4">
    <div class="form-title">Sửa Thể loại</div>
    <form method="post" autocomplete="off">
        <input type="hidden" name="id" value="${category.categoryId}" />
        <div class="mb-3">
            <label class="form-label">Tên thể loại</label>
            <input name="name" class="form-control" required value="${category.name}" />
        </div>
        <div class="mb-3">
            <label class="form-label">Loại</label>
            <select name="categoryType" class="form-select" required>
                <option value="PC" <c:if test="${category.categoryType == 'PC'}">selected</c:if>>PC</option>
                <option value="Component" <c:if test="${category.categoryType == 'Component'}">selected</c:if>>Linh kiện</option>
            </select>
        </div>
        <div class="mb-4">
            <label class="form-label">Danh mục cha</label>
            <select name="parentId" class="form-select">
                <option value="">Không</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.categoryId}" <c:if test="${category.parentId == cat.categoryId}">selected</c:if>>
                        ${cat.name}
                    </option>
                </c:forEach>
            </select>
        </div>
        <button type="submit" class="btn btn-primary px-4 fw-bold rounded-3">Lưu thay đổi</button>
        <a href="categories" class="btn btn-link">Quay lại</a>
    </form>
</div>
</body>
</html>
