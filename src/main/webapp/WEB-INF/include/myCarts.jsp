
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
    // Block and redirect if not logged in, stop JSP execution
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<%@ include file="/WEB-INF/include/header.jsp" %>

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
            .sum-line{
                display:flex;
                justify-content:space-between;
                gap:12px
            }
            .sum-line + .sum-line{
                margin-top:.4rem
            }
            .sum-total{
                display:flex;
                justify-content:space-between;
                align-items:center;
                border-top:1px solid #ddd;
                margin-top:.75rem;
                padding-top:.75rem
            }
            .sum-total strong:last-child{
                color:#c1121f;
                font-size:1.1rem
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
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                                <i class="fas fa-arrow-left"></i> Tiếp tục mua sắm
                            </a>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <h2 class="cart-title mb-4"><i class="fas fa-shopping-cart"></i> Giỏ hàng của bạn</h2>

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
                                                <!-- data-name must be escaped for safety -->
                                                <input type="checkbox"
                                                       name="selectedItems"
                                                       value="${item.cartItemId}"
                                                       class="cart-checkbox"
                                                       data-name="${fn:escapeXml(item.productName)}"
                                                       data-price="${item.price}"
                                                       data-quantity="${item.quantity}" />
                                                <img src="${item.imageUrl}" alt="${fn:escapeXml(item.productName)}" />
                                            </td>
                                            <td>
                                                <a href="product-detail?id=${item.productId}" class="text-decoration-none text-dark">
                                                    ${item.productName}
                                                </a>
                                            </td>
                                            <td><span class="price-format">${item.price}</span></td>
                                            <td>
                                                <!-- Move form outside the checkout form -->
                                                <form method="post" action="${pageContext.request.contextPath}/update-cart" class="quantity-form">
                                                    <input type="hidden" name="cartItemId" value="${item.cartItemId}" />
                                                    <input type="number"
                                                           name="quantity"
                                                           value="${item.quantity}"
                                                           min="1"
                                                           max="${item.stock}"
                                                           class="form-control form-control-sm quantity-input"
                                                           style="width: 80px;"
                                                           data-max="${item.stock}" 
                                                           data-product="${fn:escapeXml(item.productName)}"
                                                           onchange="validateQuantity(this)" />
                                                </form>
                                            </td>
                                            <td><span class="price-format">${item.price * item.quantity}</span></td>
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

                        <div class="col-lg-4">
                            <div class="summary-box">
                                <h5>Tóm tắt đơn hàng</h5>

                                <!-- Summary lines will be rendered here -->
                                <div id="summaryList" class="mt-2"></div>

                                <hr class="my-2">
                                <p class="text-muted mb-1">Chỉ tính sản phẩm đã chọn</p>
                                <div class="sum-total">
                                    <strong>Tổng cộng:</strong>
                                    <strong id="totalAmount">0 VND</strong>
                                </div>
                                <div class="d-grid gap-2 mt-3">
                                    <!-- Put checkout form here for selected items -->
                                    <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
                                        <div id="selectedItemsContainer"></div>
                                        <!-- Make the button full width -->
                                        <button id="checkoutBtn" type="submit" class="btn btn-secondary w-100" disabled>
                                            Tiến hành thanh toán
                                        </button>
                                    </form>

                                    <button type="button" class="btn btn-danger" onclick="clearCart()">Xóa tất cả sản phẩm</button>
                                    <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Tiếp tục mua sắm</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <a href="img/qrtest.jsp">Test</a>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <script>
            // Fixed function for validating quantity
            function validateQuantity(input) {
                const maxQuantity = parseInt(input.dataset.max, 10);
                const productName = input.dataset.product;
                let currentValue = parseInt(input.value, 10);

                // Handle negative or NaN values
                if (isNaN(currentValue) || currentValue < 1) {
                    input.value = 1;
                    currentValue = 1;
                    Swal.fire({
                        icon: 'warning',
                        title: 'Số lượng không hợp lệ!',
                        text: 'Đã đặt về 1.',
                        timer: 1500,
                        showConfirmButton: false
                    });
                    return;
                }

                // Check if value exceeds max
                if (currentValue > maxQuantity) {
                    // Set to max value
                    input.value = maxQuantity;

                    // Show notification with better formatting
                    Swal.fire({
                        icon: 'info',
                        title: 'Số lượng tối đa!',
                        text: 'Sản phẩm "' + productName + '" chỉ còn ' + maxQuantity + ' trong kho.\nSố lượng đã được điều chỉnh tự động.',
                        timer: 2000,
                        showConfirmButton: false
                    });
                }

                // Submit the form after validation
                setTimeout(() => {
                    input.form.submit();
                }, 300);
            }

            function confirmDelete(deleteUrl) {
                Swal.fire({
                    title: 'Bạn có chắc muốn xóa?',
                    text: 'Sản phẩm sẽ bị xóa khỏi giỏ hàng!',
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

            // Fixed function to properly format numbers with Vietnamese style (dot separator)
            function vnd(n) {
                const num = Number(n || 0);
                // Format with Vietnamese locale, using dot as thousand separator
                return num.toLocaleString('vi-VN', {
                    minimumFractionDigits: 0,
                    maximumFractionDigits: 0,
                    useGrouping: true
                }).replace(/,/g, '.') + ' VND';
            }

            // Format price elements on page load
            document.querySelectorAll('.price-format').forEach(element => {
                element.textContent = vnd(element.textContent);
            });

            function renderSummary() {
                const list = document.getElementById('summaryList');
                const totalEl = document.getElementById('totalAmount');
                const checkoutBtn = document.getElementById('checkoutBtn');
                const selectedItemsContainer = document.getElementById('selectedItemsContainer');

                list.innerHTML = '';
                selectedItemsContainer.innerHTML = '';
                let total = 0, count = 0;

                document.querySelectorAll('.cart-checkbox').forEach(function (cb) {
                    if (!cb.checked) return;
                    const name = cb.dataset.name || 'Sản phẩm';
                    const price = parseFloat(cb.dataset.price || '0');
                    const qty = parseInt(cb.dataset.quantity || '0', 10);
                    const line = price * qty;
                    const id = cb.value;

                    const row = document.createElement('div');
                    row.className = 'sum-line';
                    row.innerHTML = '<div>' + name + ' x ' + qty + '</div><div>' + vnd(line) + '</div>';
                    list.appendChild(row);

                    // Add hidden inputs for selected items to the checkout form
                    const hiddenInput = document.createElement('input');
                    hiddenInput.type = 'hidden';
                    hiddenInput.name = 'selectedItems';
                    hiddenInput.value = id;
                    selectedItemsContainer.appendChild(hiddenInput);

                    total += line;
                    count++;
                });

                totalEl.textContent = vnd(total);
                checkoutBtn.disabled = (count === 0);
            }

            function toggleAllCheckboxes(source) {
                document.querySelectorAll('.cart-checkbox').forEach(function (cb) {
                    cb.checked = source.checked;
                });
                renderSummary();
            }

            function clearCart() {
                Swal.fire({
                    title: 'Bạn có chắc muốn xóa tất cả sản phẩm?',
                    text: 'Tất cả các sản phẩm sẽ bị xóa khỏi giỏ hàng!',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Xóa tất cả',
                    cancelButtonText: 'Hủy'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = '${pageContext.request.contextPath}/clearCart';
                    }
                });
            }

            document.querySelectorAll('.cart-checkbox').forEach(function (cb) {
                cb.addEventListener('change', renderSummary);
            });
            renderSummary();
        </script>

        <%@ include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
