<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<%
    // Kiểm tra session nếu người dùng đã đăng nhập
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
    }
%>

<html>
    <head>
        <title>Giỏ hàng của bạn</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <style>
            .cart-title {
                font-size: 2rem;
                font-weight: bold;
                color: #007bff;
            }
            .cart-table img {
                width: 60px;
                height: 60px;
                object-fit: cover;
            }
            .summary-box {
                border: 1px solid #ccc;
                padding: 20px;
                background: #f8f9fa;
                border-radius: 8px;
            }
            .cart-empty, .cart-login {
                text-align: center;
                padding: 60px 20px;
                color: #555;
                font-size: 1.5rem;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <c:choose>
                <c:when test="${empty sessionScope.user}">
                    <div class="cart-login">
                        <i class="fas fa-sign-in-alt fa-2x mb-3"></i><br>
                        Vui lòng <a href="login.jsp" class="text-primary">đăng nhập</a> để xem giỏ hàng.
                    </div>
                </c:when>

                <c:when test="${empty cartItems}">
                    <div class="cart-empty">
                        <i class="fas fa-shopping-cart fa-2x mb-3"></i><br>
                        Giỏ hàng của bạn đang trống.
                        <div class="mt-3">
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary"><i class="fas fa-arrow-left"></i> Tiếp tục mua sắm</a>
                        </div>
                        
                    </div>
                </c:when>

                <c:otherwise>
                    <h2 class="cart-title mb-4"><i class="fas fa-shopping-cart"></i> Giỏ hàng của bạn</h2>

                    <form action="${pageContext.request.contextPath}/checkout" method="post">
                        <div class="row">
                            <div class="col-lg-8">
                                <table class="table table-hover cart-table">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>
                                                <input type="checkbox" id="checkAll" onclick="toggleAllCheckboxes(this)" />
                                            </th>
                                            <th>Sản phẩm</th>
                                            <th>Đơn giá</th>
                                            <th>Số lượng</th>
                                            <th>Thành tiền</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${cartItems}">
                                            <tr>
                                                <td>
                                                    <input type="checkbox"
                                                           name="selectedItems"
                                                           value="${item.cartItemId}"
                                                           class="cart-checkbox"
                                                           data-price="${item.price}"
                                                           data-quantity="${item.quantity}" />
                                                    <img src="${item.imageUrl}" alt="${item.productName}" />
                                                </td>
                                                <td>
                                                    <a href="product-detail?id=${item.productId}" class="text-decoration-none text-dark">
                                                        ${item.productName}
                                                    </a>
                                                </td>
                                                <td>${item.price} đ</td>
                                                <td>
                                                    <form method="post" action="${pageContext.request.contextPath}/update-cart">
                                                        <input type="hidden" name="cartItemId" value="${item.cartItemId}" />
                                                        <input type="number"
                                                               name="quantity"
                                                               value="${item.quantity}"
                                                               min="1"
                                                               max="${item.stock}"
                                                               class="form-control form-control-sm"
                                                               style="width: 80px;"
                                                               onchange="this.form.submit();" />
                                                    </form>
                                                </td>
                                                <td>${item.price * item.quantity} đ</td>
                                                <td>
                                                    <button type="button"
                                                            class="btn btn-sm btn-outline-danger"
                                                            onclick="confirmDelete('${pageContext.request.contextPath}/DeleteCartItem?id=${item.cartItemId}')">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Nút xóa giỏ hàng -->
                            <div class="col-lg-4">
                                <div class="summary-box">
                                    <h5>Tóm tắt đơn hàng</h5>
                                    <hr>
                                    <p class="text-muted">Chỉ tính sản phẩm đã chọn</p>
                                    <p>Tổng cộng: <strong id="totalAmount"></strong></p>
                                    <div class="d-grid gap-2 mt-3">
                                        <button type="submit" class="btn btn-secondary">Tiến hành thanh toán</button>
                                        <!-- Nút xóa giỏ hàng -->
                                        <button type="button" class="btn btn-danger" onclick="clearCart()">Xóa tất cả sản phẩm</button>
                                        <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Tiếp tục mua sắm</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <script>
            function confirmDelete(deleteUrl) {
        Swal.fire({
            title: 'Bạn có chắc muốn xóa?',
            text: "Sản phẩm sẽ bị xóa khỏi giỏ hàng!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Xóa',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire({
                    icon: 'success',
                    title: 'Đã xóa sản phẩm!',
                    showConfirmButton: false,
                    timer: 1200
                });

                setTimeout(() => {
                    window.location.href = deleteUrl;
                }, 1300);
            }
        });
    }
            // Chọn tất cả checkbox khi click vào "Check All"
            function toggleAllCheckboxes(source) {
                const checkboxes = document.querySelectorAll('.cart-checkbox');
                checkboxes.forEach(cb => {
                    cb.checked = source.checked;
                });
                updateTotalAmount(); // Cập nhật lại tổng tiền khi chọn tất cả
            }

            // Xóa tất cả sản phẩm trong giỏ hàng
            function clearCart() {
                Swal.fire({
                    title: 'Bạn có chắc muốn xóa tất cả sản phẩm?',
                    text: "Tất cả các sản phẩm sẽ bị xóa khỏi giỏ hàng!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Xóa tất cả',
                    cancelButtonText: 'Hủy'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Gửi request xóa tất cả sản phẩm
                        window.location.href = '${pageContext.request.contextPath}/clearCart';
                    }
                });
            }

            // Cập nhật tổng tiền
            function updateTotalAmount() {
                const checkboxes = document.querySelectorAll('.cart-checkbox');
                let total = 0;

                checkboxes.forEach(cb => {
                    if (cb.checked) {
                        const price = parseFloat(cb.dataset.price);
                        const quantity = parseInt(cb.dataset.quantity);
                        total += price * quantity;
                    }
                });

                document.getElementById('totalAmount').innerText = total.toLocaleString('vi-VN') + ' đ';
            }

            // Lắng nghe sự kiện thay đổi checkbox
            document.querySelectorAll('.cart-checkbox').forEach(cb => {
                cb.addEventListener('change', updateTotalAmount);
            });

            // Tính tổng tiền lần đầu nếu có sẵn các checkbox được chọn
            updateTotalAmount();
        </script>

        <%@ include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
