<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<%
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
                            <a href="products.jsp" class="btn btn-primary"><i class="fas fa-arrow-left"></i> Tiếp tục mua sắm</a>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <h2 class="cart-title mb-4"><i class="fas fa-shopping-cart"></i> Giỏ hàng của bạn</h2>

                    <form action="checkout.jsp" method="post">
                        <div class="row">
                            <div class="col-lg-8">
                                <table class="table table-hover cart-table">
                                    <thead class="table-dark">
                                        <tr>
                                            <th></th>
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
                                                    <input type="checkbox" name="selectedItems" value="${item.cartItemId}" />
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
                                                <td>
                                                    <button type="button"
                                                            class="btn btn-sm btn-outline-danger"
                                                            onclick="confirmDelete('${pageContext.request.contextPath}/DeleteCartItem?id=${item.cartItemId}')">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </td>

                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <div class="col-lg-4">
                                <div class="summary-box">
                                    <h5>Tóm tắt đơn hàng</h5>
                                    <hr>
                                    <p>Tổng cộng: <strong>${totalAmount} đ</strong></p>
                                    <div class="d-grid gap-2">
                                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-secondary">Tiến hành thanh toán</a>
                                        <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Tiếp tục mua sắm</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- SweetAlert2 Confirm Delete + Success Toast -->
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
                                    // Thông báo sau khi bấm xác nhận
                                    Swal.fire({
                                        icon: 'success',
                                        title: 'Đã xóa sản phẩm!',
                                        showConfirmButton: false,
                                        timer: 1200
                                    });

                                    // Sau khi hiển thị xong thì chuyển trang
                                    setTimeout(() => {
                                        window.location.href = deleteUrl;
                                    }, 1300);
                                }
                            });
                        }
        </script>


        <%@ include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
