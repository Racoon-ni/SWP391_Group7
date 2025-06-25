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


        <script>
    document.addEventListener('DOMContentLoaded', function () {
        function updateTotal() {
            let totalPrice = 0;
            document.querySelectorAll('tr').forEach(function (row) {
                const priceEl = row.querySelector('td[data-price]');
                const qtyInput = row.querySelector('.qty-input');

                if (!priceEl || !qtyInput) return;

                const price = parseFloat(priceEl.dataset.price);
                let qty = parseInt(qtyInput.value);

                if (isNaN(qty) || qty <= 0) {
                    qty = 1;
                    qtyInput.value = 1;
                }

                const itemTotal = price * qty;

                // Cập nhật thành tiền cho từng dòng
                const itemTotalEl = row.querySelector('.item-total');
                if (itemTotalEl) {
                    itemTotalEl.textContent = itemTotal.toLocaleString('vi-VN', {
                        minimumFractionDigits: 2,
                        maximumFractionDigits: 2
                    }) + ' ₫';
                }

                totalPrice += itemTotal;
            });

            // Cập nhật tổng tiền
            const totalField = document.getElementById('reorderTotal');
            if (totalField) {
                totalField.value = totalPrice.toLocaleString('vi-VN', {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                }) + ' ₫';
            }
        }

        // Gắn sự kiện sau khi DOM đã sẵn sàng
        document.querySelectorAll('.qty-input').forEach(function (input) {
            ['input', 'change'].forEach(function (eventType) {
                input.addEventListener(eventType, updateTotal);
            });
        });

        // Cập nhật lần đầu khi trang load
        updateTotal();
    });
</script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
