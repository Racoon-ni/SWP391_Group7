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
                    <form action="UpdateCartServlet" method="post">
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
                                                    <img src="${item.imageUrl}" alt="${item.productName}" />
                                                </td>

                                                <td>
                                                    <a href="productDetail.jsp?id=${item.productId}" class="text-decoration-none text-dark">
                                                        ${item.productName}
                                                    </a>
                                                </td>

                                                <td>${item.price} đ</td>

                                                <td>
                                                    <c:set var="qtyDisplay" value="${item.quantity}" />
                                                    <c:if test="${empty item.quantity || item.quantity <= 0}">
                                                        <c:set var="qtyDisplay" value="1" />
                                                    </c:if>

                                                    <c:set var="stockDisplay" value="${item.stock}" />
                                                    <c:if test="${empty item.stock || item.stock <= 0}">
                                                        <c:set var="stockDisplay" value="1" />
                                                    </c:if>

                                                    <input type="number"
                                                           name="quantity_${item.cartItemId}"
                                                           value="${qtyDisplay}"
                                                           min="1"
                                                           max="${stockDisplay}"
                                                           class="form-control form-control-sm"
                                                           style="width: 80px;" />

                                                    <c:if test="${qtyDisplay > stockDisplay}">
                                                        <div class="text-danger small">Vượt quá số lượng trong kho</div>
                                                    </c:if>

                                                </td>

                                                <td>${item.price * item.quantity} đ</td>

                                                <td>
                                                    <a href="DeleteCartItemServlet?id=${item.cartItemId}" class="btn btn-sm btn-outline-danger">
                                                        <i class="fas fa-trash"></i>
                                                    </a>
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
                                    <p>Ước tính giao hàng: <strong>2-4 ngày</strong></p>
                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-outline-primary">Cập nhật giỏ hàng</button>
                                        <a href="checkout.jsp" class="btn btn-success">Tiến hành thanh toán</a>
                                        <a href="products.jsp" class="btn btn-secondary">Tiếp tục mua sắm</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>

        <%@ include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
