<%@ include file="/WEB-INF/include/admin-side-bar.jsp" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="content-wrapper">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6 col-md-8">
                <c:if test="${not empty staff}">
                    <div class="card shadow-lg rounded-4 mt-5">
                        <div class="card-header bg-info text-white rounded-top-4 text-center">
                            <h3 class="mb-0"><i class="fa-solid fa-user"></i> Chi tiết nhân viên</h3>
                        </div>
                        <div class="card-body p-4">
                            <ul class="list-group list-group-flush mb-4">
                                <li class="list-group-item"><b>ID:</b> ${staff.id}</li>
                                <li class="list-group-item"><b>Họ tên:</b> ${staff.fullname}</li>
                                <li class="list-group-item"><b>Username:</b> ${staff.username}</li>
                                <li class="list-group-item"><b>Email:</b> ${staff.email}</li>
                                <li class="list-group-item"><b>SĐT:</b> ${staff.phone}</li>
                                <li class="list-group-item"><b>Địa chỉ:</b> ${staff.address}</li>
                                <li class="list-group-item">
                                    <b>Ngày sinh:</b> 
                                    <fmt:formatDate value="${staff.dateOfBirth}" pattern="dd/MM/yyyy" />
                                </li>
                                <li class="list-group-item"><b>Giới tính:</b> ${staff.gender}</li>
                                <li class="list-group-item">
                                    <b>Trạng thái:</b>
                                    <c:choose>
                                        <c:when test="${staff.status}">
                                            <span class="badge bg-success">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">Khoá</span>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                            </ul>
                            <div class="d-flex justify-content-between">
                                <a href="StaffUpdate?id=${staff.id}" class="btn btn-warning">
                                    <i class="fa-solid fa-pen-to-square"></i> Sửa thông tin
                                </a>
                                <a href="StaffList" class="btn btn-secondary">
                                    <i class="fa-solid fa-list"></i> Về danh sách
                                </a>
                            </div>
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
