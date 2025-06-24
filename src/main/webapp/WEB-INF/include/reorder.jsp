<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đặt lại đơn hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-5">
            <h2 class="mb-4" style="font-weight:700"><i class="fas fa-redo"></i> Đặt lại đơn hàng</h2>

            <form action="${pageContext.request.contextPath}/reorder" method="post">
                <input type="hidden" name="orderId" value="${order.orderId}" />

                <!-- Thông tin giao hàng -->
                <div class="mb-3">
                    <label for="phone" class="form-label">Số điện thoại:</label>
                    <input type="text" class="form-control" name="phone" value="${shippingInfo.phone}" required />
                </div>

                <div class="mb-3">
                    <label for="address" class="form-label">Địa chỉ giao hàng:</label>
                    <input type="text" class="form-control" name="address" value="${shippingInfo.shippingAddress}" required />
                </div>

                <div class="mb-3">
                    <label for="paymentMethod" class="form-label">Phương thức thanh toán:</label>
                    <select class="form-select" name="paymentMethod" required>
                        <option value="COD" ${shippingInfo.paymentMethod == 'COD' ? 'selected' : ''}>COD (Thanh toán khi nhận)</option>
                        <option value="Card" ${shippingInfo.paymentMethod == 'Card' ? 'selected' : ''}>Card</option>
                        <option value="E-Wallet" ${shippingInfo.paymentMethod == 'E-Wallet' ? 'selected' : ''}>Ví điện tử</option>
                    </select>
                </div>

                <h4>Sản phẩm:</h4>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Tên sản phẩm</th>
                            <th>Đơn giá</th>
                            <th>Số lượng</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${orderDetails}">
                            <tr>
                                <td>${item.productName}</td>
                                <td data-price="${item.unitPrice}">
                                    <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫"/>
                                </td>
                                <td>
                                    <input type="number" class="form-control qty-input" name="quantities" value="${item.quantity}" min="1" required />
                                    <input type="hidden" name="productIds" value="${item.productId}" /> <!-- ✅ THÊM DÒNG NÀY -->
                                </td>
                                <td>
                                    <span class="item-total">
                                        <fmt:formatNumber value="${item.unitPrice * item.quantity}" type="currency" currencySymbol="₫"/>
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- Tổng tiền -->
                <div class="mb-3">
                    <label for="totalPrice" class="form-label">Tổng tiền:</label>
                    <input type="text" class="form-control" name="totalPrice" value="${order.totalPrice}" id="reorderTotal" readonly />
                </div>

                <button type="submit" class="btn btn-primary">Đặt lại</button>
            </form>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.querySelectorAll('.qty-input').forEach(function (input) {
                input.addEventListener('input', function () {
                    const row = input.closest('tr');
                    const unitPrice = parseFloat(row.querySelector('td[data-price]').dataset.price);
                    let quantity = parseInt(input.value);
                    if (isNaN(quantity) || quantity <= 0) {
                        quantity = 1;
                        input.value = 1;
                    }

                    // Tính thành tiền
                    const itemTotal = unitPrice * quantity;

                    // Cập nhật thành tiền
                    row.querySelector('.item-total').textContent = itemTotal.toLocaleString('vi-VN', {
                        minimumFractionDigits: 2,
                        maximumFractionDigits: 2
                    }) + ' ₫';

                    // Tính tổng tiền
                    let totalPrice = 0;
                    document.querySelectorAll('.item-total').forEach(function (el) {
                        const value = parseFloat(el.textContent.replace(/[₫\s]/g, '').replace(/\./g, '').replace(',', '.'));
                        if (!isNaN(value)) {
                            totalPrice += value;
                        }
                    });

                    // Cập nhật tổng tiền
                    document.getElementById('reorderTotal').value = totalPrice.toLocaleString('vi-VN', {
                        minimumFractionDigits: 2,
                        maximumFractionDigits: 2
                    }) + ' ₫';
                });
            });
        </script>
    </body>
</html>
