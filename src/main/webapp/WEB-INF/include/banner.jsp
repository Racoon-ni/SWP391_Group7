<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Banner</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
    <style>
        .banner-img { max-width: 150px; max-height: 100px; border-radius: 8px; object-fit: cover; }
        .table td, .table th { vertical-align: middle; }
        .text-small { font-size: 0.875rem; color: #6c757d; }
    </style>
</head>
<body>
<div class="main-content container mt-4">

    <a href="${pageContext.request.contextPath}/dash-board" class="btn btn-outline-primary mb-3">
        ⬅ Quay về trang chủ
    </a>

    <h2>Quản lý Banner</h2>

    <!-- Thông báo -->
    <c:if test="${param.updated eq 'true'}">
        <div class="alert alert-success alert-dismissible fade show">
            Cập nhật thành công! <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.updated eq 'false' || param.error eq 'true'}">
        <div class="alert alert-danger alert-dismissible fade show">
            Cập nhật thất bại! <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.uploaded eq 'true'}">
        <div class="alert alert-success alert-dismissible fade show">
            Upload banner thành công! <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.uploaded eq 'false'}">
        <div class="alert alert-danger alert-dismissible fade show">
            Upload banner thất bại!
            <c:if test="${param.error eq 'invalidtype'}"> Định dạng file không hợp lệ.</c:if>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Bảng banner -->
    <table class="table table-bordered table-striped">
        <thead class="table-dark">
        <tr>
            <th style="width:70px">ID</th>
            <th>Ảnh</th>
            <th>Link</th>
            <th style="width:180px">Trạng thái</th>
            <th style="width:180px">Ngày tạo</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty banners}">
                <c:forEach var="b" items="${banners}">
                    <tr>
                        <td>${b.bannerId}</td>

                        <!-- ẢNH + LINK -->
                        <td>
                            <c:choose>
                                <c:when test="${not empty b.targetUrl}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(b.targetUrl,'http')}">
                                            <a href="${b.targetUrl}" target="_blank" rel="noopener">
                                                <img src="${pageContext.request.contextPath}${b.imageUrl}" class="banner-img" alt="Banner ${b.bannerId}">
                                            </a>
                                            <div class="text-small">${b.targetUrl}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}${b.targetUrl}">
                                                <img src="${pageContext.request.contextPath}${b.imageUrl}" class="banner-img" alt="Banner ${b.bannerId}">
                                            </a>
                                            <div class="text-small">${pageContext.request.contextPath}${b.targetUrl}</div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}${b.imageUrl}" class="banner-img" alt="Banner ${b.bannerId}">
                                    <div class="text-small text-muted">Không có link</div>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <!-- Link hiển thị -->
                        <td>
                            <c:choose>
                                <c:when test="${not empty b.targetUrl}">
                                    <code>
                                        <c:choose>
                                            <c:when test="${fn:startsWith(b.targetUrl,'http')}">${b.targetUrl}</c:when>
                                            <c:otherwise>${pageContext.request.contextPath}${b.targetUrl}</c:otherwise>
                                        </c:choose>
                                    </code>
                                </c:when>
                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                            </c:choose>
                        </td>

                        <!-- Trạng thái -->
                        <td>
                            <form method="post" class="d-flex gap-2 align-items-center" action="${pageContext.request.contextPath}/manage-banner">
                                <input type="hidden" name="action" value="updateStatus" />
                                <input type="hidden" name="bannerId" value="${b.bannerId}" />
                                <select name="status" class="form-select">
                                    <option value="1" ${b.status == 1 ? "selected" : ""}>Hiển thị</option>
                                    <option value="0" ${b.status == 0 ? "selected" : ""}>Ẩn</option>
                                </select>
                                <button type="submit" class="btn btn-outline-secondary btn-sm">Lưu</button>
                            </form>
                        </td>

                        <td><fmt:formatDate value="${b.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="5" class="text-center text-muted">Chưa có banner nào được tạo.</td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>

    <!-- Upload banner mới -->
    <div class="card mt-4">
        <div class="card-header">
            <h5>Upload Banner Mới</h5>
        </div>
        <div class="card-body">
            <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/manage-banner">
                <input type="hidden" name="action" value="upload" />

                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="bannerFile" class="form-label">Chọn ảnh banner:</label>
                        <input type="file" class="form-control" id="bannerFile" name="bannerFile" accept="image/*" required>
                    </div>

                    <div class="col-md-4">
                        <label for="linkUrl" class="form-label">Link đích (tuỳ chọn):</label>
                        <input type="url" class="form-control" id="linkUrl" name="linkUrl" placeholder="https://... hoặc /khuyen-mai">
                        <div class="form-text">Nếu nhập, ảnh sẽ link tới trang này.</div>
                    </div>

                    <div class="col-md-2">
                        <label for="status" class="form-label">Trạng thái:</label>
                        <select name="status" id="status" class="form-select">
                            <option value="1">Hiển thị</option>
                            <option value="0">Ẩn</option>
                        </select>
                    </div>

                    <div class="col-12 d-flex justify-content-end">
                        <button type="submit" class="btn btn-success">Upload</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
