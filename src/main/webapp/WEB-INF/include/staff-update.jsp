<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/WEB-INF/include/admin-side-bar.jsp" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="content-wrapper">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6 col-md-8">
                <c:if test="${not empty staff}">
                    <div class="card shadow-lg rounded-4 mt-4">
                        <div class="card-header bg-warning text-dark text-center rounded-top-4">
                            <h3 class="mb-0">Cập nhật thông tin nhân viên</h3>
                        </div>
                        <div class="card-body p-4">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger mb-3">${error}</div>
                            </c:if>
                            <form action="StaffUpdate" method="post">
                                <input type="hidden" name="id" value="${staff.id}" />

                                <div class="mb-3">
                                    <label for="fullname" class="form-label">Họ tên</label>
                                    <input type="text" class="form-control" id="fullname" name="fullname" value="${staff.fullname}" required>
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" value="${staff.email}" required>
                                </div>
                                <div class="mb-3">
                                    <label for="phone" class="form-label">SĐT</label>
                                    <input type="text" class="form-control" id="phone" name="phone" value="${staff.phone}">
                                </div>
                                <div class="mb-3">
                                    <label for="gender" class="form-label">Giới tính</label>
                                    <select class="form-select" id="gender" name="gender" required>
                                        <option value="Nam" ${staff.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                        <option value="Nữ" ${staff.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                        <option value="Khác" ${staff.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="dateOfBirth" class="form-label">Ngày sinh</label>
                                    <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth"
                                        value="<fmt:formatDate value='${staff.dateOfBirth}' pattern='yyyy-MM-dd'/>" required>
                                </div>
                                <div class="mb-3">
                                    <label for="address" class="form-label">Địa chỉ</label>
                                    <input type="text" class="form-control" id="address" name="address" value="${staff.address}">
                                </div>
                                <div class="mb-4 form-check">
                                    <input class="form-check-input" type="checkbox" id="status" name="status" ${staff.status ? 'checked' : ''}>
                                    <label class="form-check-label" for="status">
                                        Đang hoạt động
                                    </label>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <button type="submit" class="btn btn-warning px-4">
                                        <i class="fa-solid fa-floppy-disk"></i> Lưu lại
                                    </button>
                                    <a href="StaffList" class="btn btn-secondary px-4">
                                        <i class="fa-solid fa-ban"></i> Huỷ
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:if>
                <c:if test="${empty staff}">
                    <div class="alert alert-danger mt-5 text-center">
                        <i class="fa-solid fa-triangle-exclamation"></i> Không tìm thấy nhân viên.
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>
