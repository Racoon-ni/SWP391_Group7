<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.OrderDetail, model.ShippingInfo, model.Order" %>

<%
    Order order = (Order) request.getAttribute("order");
    ShippingInfo shippingInfo = (ShippingInfo) request.getAttribute("shippingInfo");
    List<OrderDetail> orderDetails = (List<OrderDetail>) request.getAttribute("orderDetails");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đặt lại đơn hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-5">
            <h2 class="mb-4" style="font-weight:700"><i class="fas fa-redo"></i> Đặt lại đơn hàng</h2>

            <form action="reorder" method="post">
                <input type="hidden" name="orderId" value="<%= order.getOrderId()%>" />

                <!-- Thông tin giao hàng -->
                <div class="mb-3">
                    <label class="form-label">Tên người nhận:</label>
                    <input type="text" class="form-control" name="receiverName" value="<%= shippingInfo.getReceiverName()%>" required />
                </div>

                <div class="mb-3">
                    <label class="form-label">Số điện thoại:</label>
                    <input type="text" class="form-control" name="phone" value="<%= shippingInfo.getPhone()%>" required />
                </div>

                <div class="mb-3">
                    <label class="form-label">Địa chỉ giao hàng:</label>
                    <input type="text" class="form-control" name="address" value="<%= shippingInfo.getShippingAddress()%>" required />
                </div>

                <div class="mb-3">
                    <label class="form-label">Phương thức thanh toán:</label>
                    <select class="form-select" name="paymentMethod" required>
                        <option value="COD" <%= "COD".equals(shippingInfo.getPaymentMethod()) ? "selected" : ""%>>COD (Thanh toán khi nhận)</option>
                        <option value="Card" <%= "Card".equals(shippingInfo.getPaymentMethod()) ? "selected" : ""%>>Card</option>
                        <option value="E-Wallet" <%= "E-Wallet".equals(shippingInfo.getPaymentMethod()) ? "selected" : ""%>>Ví điện tử</option>
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
                        <%
                            for (OrderDetail item : orderDetails) {
                                double unitPrice = item.getUnitPrice();
                                int quantity = item.getQuantity();
                                double total = unitPrice * quantity;
                        %>
                        <tr>
                            <td><%= item.getProductName()%></td>
                            <td data-price="<%= unitPrice%>">
                                <%= String.format("%,.2f ₫", unitPrice)%>
                            </td>
                            <td>
                                <input type="number" class="form-control qty-input" name="quantities" value="<%= quantity%>" min="1" required />
                                <input type="hidden" name="productIds" value="<%= item.getProductId()%>" />
                            </td>
                            <td>
                                <span class="item-total">
                                    <%= String.format("%,.2f ₫", total)%>
                                </span>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>

                <div class="mb-3">
                    <label class="form-label">Tổng tiền:</label>
                    <input type="text" class="form-control" name="totalPrice"
                           value="<%= String.format("%,.2f ₫", order.getTotalPrice())%>" id="reorderTotal" readonly />
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

                        if (!priceEl || !qtyInput)
                            return;

                        const price = parseFloat(priceEl.dataset.price);
                        let qty = parseInt(qtyInput.value);

                        if (isNaN(qty) || qty <= 0) {
                            qty = 1;
                            qtyInput.value = 1;
                        }

                        const itemTotal = price * qty;

                        // Update per-item total
                        const itemTotalEl = row.querySelector('.item-total');
                        if (itemTotalEl) {
                            itemTotalEl.textContent = itemTotal.toLocaleString('vi-VN', {
                                minimumFractionDigits: 2,
                                maximumFractionDigits: 2
                            }) + ' ₫';
                        }

                        totalPrice += itemTotal;
                    });

                    const totalField = document.getElementById('reorderTotal');
                    if (totalField) {
                        totalField.value = totalPrice.toLocaleString('vi-VN', {
                            minimumFractionDigits: 2,
                            maximumFractionDigits: 2
                        }) + ' ₫';
                    }
                }

                document.querySelectorAll('.qty-input').forEach(function (input) {
                    ['input', 'change'].forEach(function (eventType) {
                        input.addEventListener(eventType, updateTotal);
                    });
                });

                updateTotal();
            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
