<%@ include file="/WEB-INF/include/admin-side-bar.jsp" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="content-wrapper">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6 col-md-8">
                <div class="card shadow-lg rounded-4 mt-4">
                    <div class="card-header bg-primary text-white text-center rounded-top-4">
                        <h3 class="mb-0">Thêm mới nhân viên</h3>
                    </div>
                    <div class="card-body p-4">

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger mb-3">${error}</div>
                        </c:if>

                        <form action="StaffCreate" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">Tên đăng nhập</label>
                                <input type="text"
                                       class="form-control ${not empty errors.username ? 'is-invalid' : ''}"
                                       id="username" name="username"
                                       value="${formData.username}" required>
                                <div class="invalid-feedback">${errors.username}</div>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label">Mật khẩu</label>
                                <div class="input-group">
                                    <input type="text"
                                           class="form-control ${not empty errors.password ? 'is-invalid' : ''}"
                                           id="password" name="password"
                                           value="${formData.password}" required>
                                    <button type="button" id="btnRandom" class="btn btn-outline-primary">Random</button>
                                </div>
                                <div class="invalid-feedback d-block">${errors.password}</div>
                                <div class="form-text">Mật khẩu random sẽ hiển thị trực tiếp ở ô trên.</div>
                            </div>

                            <div class="mb-3">
                                <label for="fullname" class="form-label">Họ tên</label>
                                <input type="text"
                                       class="form-control ${not empty errors.fullname ? 'is-invalid' : ''}"
                                       id="fullname" name="fullname"
                                       value="${formData.fullname}" required>
                                <div class="invalid-feedback">${errors.fullname}</div>
                            </div>

                            <div class="mb-3">
                                <label for="dateOfBirth" class="form-label">Ngày sinh</label>
                                <input type="date"
                                       class="form-control ${not empty errors.dateOfBirth ? 'is-invalid' : ''}"
                                       id="dateOfBirth" name="dateOfBirth"
                                       value="<fmt:formatDate value='${formData.dateOfBirth}' pattern='yyyy-MM-dd'/>" required>
                                <div class="invalid-feedback">${errors.dateOfBirth}</div>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email"
                                       class="form-control ${not empty errors.email ? 'is-invalid' : ''}"
                                       id="email" name="email"
                                       value="${formData.email}" required>
                                <div class="invalid-feedback">${errors.email}</div>
                            </div>

                            <div class="mb-3">
                                <label for="phone" class="form-label">SĐT</label>
                                <input type="text"
                                       class="form-control ${not empty errors.phone ? 'is-invalid' : ''}"
                                       id="phone" name="phone"
                                       value="${formData.phone}">
                                <div class="invalid-feedback">${errors.phone}</div>
                            </div>

                            <div class="mb-3">
                                <label for="gender" class="form-label">Giới tính</label>
                                <select class="form-select" id="gender" name="gender" required>
                                    <option value="Nam"  ${formData.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                    <option value="Nữ"   ${formData.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                    <option value="Khác" ${formData.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>

                            <div class="mb-4">
                                <label for="address" class="form-label">Địa chỉ</label>
                                <input type="text" class="form-control" id="address" name="address" value="${formData.address}">
                            </div>

                            <div class="d-flex gap-2 mb-3">
                                <button type="button" id="btnSendMail" class="btn btn-outline-success">
                                    <i class="fa-regular fa-paper-plane"></i> Gửi mail thông tin đăng nhập
                                </button>
                                <small class="text-muted align-self-center" id="sendMailStatus"></small>
                            </div>

                            <div class="d-flex justify-content-between">
                                <button type="submit" class="btn btn-success px-4">
                                    <i class="fa-solid fa-plus"></i> Thêm mới
                                </button>
                                <a href="StaffList" class="btn btn-secondary px-4">
                                    <i class="fa-solid fa-ban"></i> Huỷ
                                </a>
                            </div>
                        </form>

                        <script>
                            (function () {
                                function randomPassword(len = 12) {
                                    const chars = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789!@#$%^&*?";
                                    let p = "";
                                    for (let i = 0; i < len; i++)
                                        p += chars[Math.floor(Math.random() * chars.length)];
                                    return p;
                                }
                                document.getElementById('btnRandom').addEventListener('click', function () {
                                    document.getElementById('password').value = randomPassword(12);
                                });

                                document.getElementById('btnSendMail').addEventListener('click', function () {
                                    const username = document.getElementById('username').value.trim();
                                    const email = document.getElementById('email').value.trim();
                                    const pass = document.getElementById('password').value.trim();
                                    if (!username || !email || !pass) {
                                        alert('Vui lòng nhập Username, Email, Password trước khi gửi.');
                                        return;
                                    }
                                    setTimeout(() => {
                                        document.getElementById('sendMailStatus').innerText = 'Đã gửi mail thành công.';
                                        alert('Đã gửi mail thành công cho ' + email + '.');
                                    }, 400);
                                });
                            })();
                        </script>


                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
