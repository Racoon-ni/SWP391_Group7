<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="../include/header.jsp" %>

<html>
<head>
    <title>Quản lý địa chỉ</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
    <style>
        /* CSS cho các phần tử của trang */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
        }

        .sidebar {
            position: fixed;
            top: 80px;
            left: 0;
            width: 250px;
            height: calc(100% - 80px);
            background-color: #f8f9fa;
            padding-top: 20px;
            border-right: 1px solid #ddd;
            z-index: 500;
        }

        .sidebar a {
            display: block;
            padding: 15px;
            color: #333;
            text-decoration: none;
            font-size: 18px;
        }

        .sidebar a:hover {
            background-color: #007bff;
            color: white;
        }

        .container {
            background-color: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            margin-left: 250px;
            margin-top: 80px;
            max-width: 800px;
            margin: auto;
        }

        .container h1 {
            color: #333;
            text-align: center;
            margin-bottom: 20px;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            justify-content: center;
            align-items: center;
            z-index: 1000;
            padding: 20px 0;
        }

        .modal-content {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            width: 90%;
            max-width: 400px;
            max-height: 80vh;
            overflow-y: auto;
        }

        .form-check-label {
            font-size: 14px;
        }

        .edit-btn {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            margin-bottom: 10px;
        }

        .edit-btn:hover {
            background-color: #218838;
        }

        .close-btn {
            background-color: #dc3545;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
        }

        .close-btn:hover {
            background-color: #c82333;
        }

    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <a href="view-profile">Thông tin tài khoản</a>
        <a href="#">Quản lý đơn hàng</a>
        <a href="ViewAddress">Sở địa chỉ</a>
        <a href="#">Thông báo</a>
        <a href="#">Điểm thành viên</a>
        <a href="ViewMyVoucher">Kho voucher</a>
        <a href="ViewWishlist">Danh sách yêu thích</a>
    </div>

    <!-- Main Content -->
    <div class="container mt-5">
        <h1 class="mb-4 text-primary">Đây là trang xem địa chỉ</h1>
        <button class="btn btn-success mb-4" onclick="openModal()">➕ Thêm địa chỉ mới</button>

        <c:if test="${not empty message}">
            <div class="alert alert-success">${message}</div>
        </c:if>

        <p class="text-muted">Tổng: ${fn:length(addressList)} địa chỉ</p>

        <c:choose>
            <c:when test="${empty addressList}">
                <div class="alert alert-warning">Không có địa chỉ nào!</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="addr" items="${addressList}">
                    <div class="card mb-3 ${addr.defaultAddress ? 'border-primary' : ''}">
                        <div class="card-body">
                            <h5 class="card-title">${addr.fullName}</h5>
                            <p class="card-text">
                                <strong>SDT:</strong> ${addr.phone}<br/>
                                <strong>Địa chỉ:</strong> ${addr.specificAddress}<br/>
                                <c:if test="${addr.defaultAddress}">
                                    <span class="badge bg-primary">Địa chỉ mặc định</span>
                                </c:if>
                            </p>
                            <div class="d-flex gap-2">
                                <form method="post" action="ViewAddress">
                                    <input type="hidden" name="action" value="setDefault" />
                                    <input type="hidden" name="addressId" value="${addr.id}" />
                                    <button type="submit" class="btn btn-primary btn-sm"
                                            <c:if test="${addr.defaultAddress}">disabled</c:if>>
                                                Đặt làm mặc định
                                    </button>
                                </form>
                                <form method="post" action="ViewAddress"
                                      onsubmit="return confirm('Bạn có chắc chắn muốn xóa địa chỉ này?');">
                                    <input type="hidden" name="action" value="delete" />
                                    <input type="hidden" name="addressId" value="${addr.id}" />
                                    <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Modal -->
    <div class="modal" id="addAddressModal">
        <div class="modal-content">
            <h4 class="mb-3">Thêm địa chỉ mới</h4>
            <form method="post" action="ViewAddress">
                <input type="hidden" name="action" value="add" />
                <input type="text" name="fullName" placeholder="Họ tên người nhận" required />
                <input type="text" name="phone" placeholder="Số điện thoại" required />
                <input type="text" name="specificAddress" placeholder="Địa chỉ cụ thể" required />
                <div class="form-check mb-3">
                    <input class="form-check-input" type="checkbox" name="defaultAddress" id="defaultAddress">
                    <label class="form-check-label" for="defaultAddress">Đặt làm địa chỉ mặc định</label>
                </div>
                <button type="submit" class="edit-btn">Lưu địa chỉ</button>
                <button type="button" class="close-btn" onclick="closeModal()">Hủy</button>
            </form>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        function openModal() {
            document.getElementById("addAddressModal").style.display = "flex"; // Mở modal
        }

        function closeModal() {
            document.getElementById("addAddressModal").style.display = "none"; // Đóng modal
        }

        window.onclick = function(event) {
            const modal = document.getElementById("addAddressModal");
            if (event.target === modal) {
                modal.style.display = "none"; // Đóng modal khi nhấn ra ngoài
            }
        }
    </script>

</body>
</html>
