<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.User" %>
<%@ page import="model.Cart" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<%
    DecimalFormat df = new DecimalFormat("#,###");
    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
    double totalAmount = (double) request.getAttribute("totalAmount");
    User user = (User) request.getAttribute("userInfo");

    String dobFormatted = "";
    if (user != null && user.getDate_of_birth() != null) {
        dobFormatted = new java.text.SimpleDateFormat("yyyy-MM-dd").format(user.getDate_of_birth());
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body {
            background-color: #f8f9fa;
            font-family: Arial, sans-serif;
        }
        .checkout-container {
            max-width: 1000px;
            margin: 30px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
        }
        .section-title {
            font-size: 24px;
            font-weight: bold;
        }
        .total-box {
            border: 1px solid #ccc;
            padding: 20px;
            border-radius: 8px;
            background: #f1f1f1;
        }
    </style>
</head>
<body>

<div class="container checkout-container">
    <div class="row">
        <!-- Thông tin khách hàng -->
        <div class="col-md-6">
            <h4 class="section-title mb-4">Thông tin khách hàng</h4>
            <form method="post" action="place-order" id="orderForm">
                <div class="mb-3">
                    <label>Họ tên</label>
                    <input type="text" class="form-control" name="fullname" value="<%= user != null ? user.getUsername() : "" %>" required>
                </div>
                <div class="mb-3">
                    <label>Giới tính</label>
                    <select class="form-select" name="gender">
                        <option <%= user != null && "Nam".equals(user.getGender()) ? "selected" : "" %>>Nam</option>
                        <option <%= user != null && "Nữ".equals(user.getGender()) ? "selected" : "" %>>Nữ</option>
                        <option <%= user != null && "Khác".equals(user.getGender()) ? "selected" : "" %>>Khác</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label>Địa chỉ</label>
                    <input type="text" class="form-control" name="address" value="<%= user != null ? user.getAddress() : "" %>">
                </div>
                <div class="mb-3">
                    <label>Điện thoại</label>
                    <input type="text" class="form-control" name="phone" value="<%= user != null ? user.getPhone() : "" %>">
                </div>
                <div class="mb-3">
                    <label>Email</label>
                    <input type="email" class="form-control" name="email" value="<%= user != null ? user.getEmail() : "" %>">
                </div>
                <div class="mb-3">
                    <label>Ngày sinh</label>
                    <input type="date" class="form-control" name="dob" value="<%= dobFormatted %>">
                </div>
                <div class="mb-3">
                    <label>CMND/CCCD</label>
                    <input type="text" class="form-control" name="idCard" value="<%= user != null ? user.getIdCard() : "" %>">
                </div>
                <div class="mb-3">
                    <label>Hình thức thanh toán</label><br>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="paymentMethod" value="COD" checked>
                        <label class="form-check-label">Tiền mặt</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="paymentMethod" value="BANK">
                        <label class="form-check-label">Chuyển khoản</label>
                    </div>
                    
                </div>
                

                <!-- ✅ Nút đặt hàng xác nhận bằng SweetAlert2 -->
                <button type="button" class="btn btn-primary w-100 mt-3" style="font-size: 1.2rem;" onclick="confirmOrder()">
                    Đặt hàng
                </button>
            </form>
        </div>

        <!-- Thông tin giỏ hàng -->
        <div class="col-md-6">
            <h4 class="section-title mb-4">Giỏ hàng</h4>
            <div class="total-box">
                <c:forEach var="item" items="${cartItems}">
                    <div class="d-flex justify-content-between mb-2">
                        <div>${item.productName} x ${item.quantity}</div>
                        <div>${item.price * item.quantity} đ</div>
                    </div>
                </c:forEach>
                <hr>
                <div class="d-flex justify-content-between">
                    <strong>Tổng thành tiền:</strong>
                    <strong style="color: #dc3545; font-size: 1.2rem;"><%= df.format(totalAmount) %> đ</strong>
                </div>
                <div class="mt-3">
                    <input type="text" class="form-control" placeholder="Mã khuyến mãi">
                    <button class="btn btn-outline-primary w-100 mt-2">Xác nhận</button>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>

<!-- ✅ SCRIPT xác nhận đặt hàng -->
<script>
    function confirmOrder() {
        Swal.fire({
            title: 'Bạn có chắc muốn đặt hàng?',
            text: 'Đơn hàng sẽ được gửi đến địa chỉ bạn đã chọn!',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Đặt hàng',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                document.getElementById("orderForm").submit();
            }
        });
    }
</script>

</body>
</html>
