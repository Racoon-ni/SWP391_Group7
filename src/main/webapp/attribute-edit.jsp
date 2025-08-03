<%-- 
    Document   : attribute-edit
    Created on : Jul 25, 2025, 10:36:11 AM
    Author     : ThinhLVCE181726 <your.name at your.org>
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sửa Thuộc tính</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
    <style>
        body { background: #f6f7fb; }
        .container { max-width: 540px; margin-top: 60px; }
        .form-title { font-size: 1.7rem; font-weight: 700; color: #1450bd; margin-bottom: 24px; }
    </style>
</head>
<body>
<div class="container bg-white p-4 shadow rounded-4">
    <div class="form-title">Sửa Thuộc tính</div>
    <form method="post" autocomplete="off">
        <input type="hidden" name="id" value="${attribute.attributeId}" />
        <div class="mb-3">
            <label class="form-label">Tên thuộc tính</label>
            <input name="name" class="form-control" required value="${attribute.name}" />
        </div>
        <div class="mb-3">
            <label class="form-label">Đơn vị</label>
            <input name="unit" class="form-control" value="${attribute.unit}" placeholder="VD: GB, MHz" />
        </div>
        <div class="mb-4">
            <label class="form-label">Danh mục</label>
            <select name="categoryId" class="form-select" required>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.categoryId}" <c:if test="${attribute.categoryId == cat.categoryId}">selected</c:if>>
                        ${cat.name}
                    </option>
                </c:forEach>
            </select>
        </div>
        <button type="submit" class="btn btn-primary px-4 fw-bold rounded-3">Lưu thay đổi</button>
        <a href="attributes" class="btn btn-link">Quay lại</a>
    </form>
</div>
</body>
</html>
