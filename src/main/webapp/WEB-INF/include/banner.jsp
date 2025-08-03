<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý Banner</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
        <style>
            .banner-img {
                max-width: 150px;
                max-height: 100px;
                border-radius: 8px;
                object-fit: cover;
            }
            .form-inline {
                display: flex;
                flex-wrap: nowrap;
                gap: 8px;
            }
            .table td, .table th {
                vertical-align: middle;
            }
        </style>
    </head>
    <body>
        <div class="main-content">
            <h2>Quản lý Banner</h2>

            <c:if test="${param.updated eq 'true'}">
                <div class="alert alert-success alert-dismissible fade show">
                    Cập nhật thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.updated eq 'false' || param.error eq 'true'}">
                <div class="alert alert-danger alert-dismissible fade show">
                    Cập nhật thất bại!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.uploaded eq 'true'}">
                <div class="alert alert-success alert-dismissible fade show">
                    Upload banner thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.uploaded eq 'false'}">
                <div class="alert alert-danger alert-dismissible fade show">
                    Upload banner thất bại!
                    <c:if test="${param.error eq 'invalidtype'}"> Định dạng file không hợp lệ.</c:if>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
            </c:if>

            <table class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Ảnh</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty banners}">
                            <c:forEach var="b" items="${banners}">
                                <tr>
                            <form method="post" class="form-inline">
                                <input type="hidden" name="action" value="updateStatus" />
                                <input type="hidden" name="bannerId" value="${b.bannerId}" />
                                <td>${b.bannerId}</td>
                                <td>
                                    <img src="${pageContext.request.contextPath}${b.imageUrl}" 
                                         class="banner-img" alt="Banner ${b.bannerId}">
                                </td>
                                <td>
                                    <select name="status" class="form-select" onchange="this.form.submit()">
                                        <option value="1" ${b.status == 1 ? "selected" : ""}>Hiển thị</option>
                                        <option value="0" ${b.status == 0 ? "selected" : ""}>Ẩn</option>
                                    </select>
                                </td>
                                <td>
                                    <fmt:formatDate value="${b.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </td>
                            </form>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="4" class="text-center text-muted">
                                Chưa có banner nào được tạo.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>

            <div class="card mt-4">
                <div class="card-header">
                    <h5>Upload Banner Mới</h5>
                </div>
                <div class="card-body">
                    <form method="post" enctype="multipart/form-data" 
                          action="${pageContext.request.contextPath}/manage-banner">
                        <input type="hidden" name="action" value="upload" />
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="bannerFile" class="form-label">Chọn ảnh banner:</label>
                                    <input type="file" class="form-control" id="bannerFile" name="bannerFile" 
                                           accept="image/*" required>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="mb-3">
                                    <label for="status" class="form-label">Trạng thái:</label>
                                    <select name="status" class="form-select">
                                        <option value="1">Hiển thị</option>
                                        <option value="0">Ẩn</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="mb-3">
                                    <label class="form-label">&nbsp;</label>
                                    <div>
                                        <button type="submit" class="btn btn-success">Upload</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>


