<%@ include file="/WEB-INF/include/admin-side-bar.jsp" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="content-wrapper">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mt-3 mb-3">
            <h2 class="mb-0">Danh sách nhân viên</h2>
            <a href="StaffCreate" class="btn btn-success">
                <i class="fa-solid fa-plus"></i> Thêm mới nhân viên
            </a>
        </div>

        <!-- ALERT thông báo thành công hoặc cập nhật -->
        <c:if test="${not empty param.message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check"></i> ${param.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- BẢNG DANH SÁCH NHÂN VIÊN -->
        <div class="table-responsive shadow rounded-4">
            <table class="table table-hover table-bordered align-middle mb-0">
                <thead class="table-primary">
                    <tr>
                        <th>ID</th>
                        <th>Họ tên</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>SĐT</th>
                        <th>Giới tính</th>
                        <th>Ngày sinh</th>
                        <th>Địa chỉ</th>
                        <th>Trạng thái</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="staff" items="${staffList}">
                        <tr>
                            <td>${staff.id}</td>
                            <td>${staff.fullname}</td>
                            <td>${staff.username}</td>
                            <td>${staff.email}</td>
                            <td>${staff.phone}</td>
                            <td>${staff.gender}</td>
                            <td>
                                <fmt:formatDate value="${staff.dateOfBirth}" pattern="dd/MM/yyyy" />
                            </td>
                            <td>${staff.address}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${staff.status}">
                                        <span class="badge bg-success">Hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Khoá</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <a href="StaffDetail?id=${staff.id}" class="btn btn-info btn-sm me-1 mb-1" title="Chi tiết">
                                    <i class="fa-solid fa-eye"></i>
                                </a>
                                <a href="StaffUpdate?id=${staff.id}" class="btn btn-warning btn-sm me-1 mb-1" title="Sửa">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </a>
                                <a href="StaffDelete?id=${staff.id}" 
                                   class="btn btn-danger btn-sm mb-1 btn-delete-staff" 
                                   data-staff-id="${staff.id}" title="Xoá">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty staffList}">
                        <tr>
                            <td colspan="10" class="text-center text-muted">Không có dữ liệu nhân viên</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal xác nhận xoá nhân viên -->
<div class="modal fade" id="deleteStaffModal" tabindex="-1" aria-labelledby="deleteStaffModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="deleteStaffModalLabel">Xác nhận xoá</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>
            <div class="modal-body">
                Bạn có chắc chắn muốn xoá nhân viên này không?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <a id="confirmDeleteBtn" href="#" class="btn btn-danger">
                    <i class="fa-solid fa-trash"></i> Xoá
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Script xử lý modal xoá -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Chọn tất cả nút xoá
        document.querySelectorAll(".btn-delete-staff").forEach(function (btn) {
            btn.addEventListener("click", function (event) {
                event.preventDefault();
                // Lấy href của nút
                var deleteUrl = this.getAttribute("href");
                // Gán cho nút xác nhận trong modal
                document.getElementById("confirmDeleteBtn").setAttribute("href", deleteUrl);
                // Hiện modal Bootstrap
                var modal = new bootstrap.Modal(document.getElementById("deleteStaffModal"));
                modal.show();
            });
        });
    });
</script>

<!-- Xóa alert sau khi hiển thị 1 lần (ngăn lặp lại khi refresh) -->
<script>
    if (window.location.search.indexOf('message=') > -1) {
        window.history.replaceState({}, document.title, window.location.pathname);
    }
</script>
