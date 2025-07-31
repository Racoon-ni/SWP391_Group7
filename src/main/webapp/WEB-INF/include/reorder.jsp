<%@ page pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.OrderDetail, model.ShippingInfo, model.Order" %>
<%@ include file="/WEB-INF/include/header.jsp" %>


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
    <style>
        body {
            background-color: #f0f2f5;
        }
        .card-header {
            background-color: #0d6efd;
            color: #fff;
            font-weight: 600;
            font-size: 1.2rem;
        }
        .form-label {
            font-weight: 500;
            color: #0d6efd;
        }
        .form-control, .form-select {
            border-color: #0d6efd;
        }
        .form-control:focus, .form-select:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13,110,253,.25);
        }
        .table thead {
            background-color: #0d6efd;
            color: white;
        }
        .btn-primary {
            background-color: #0d6efd;
            border-color: #0d6efd;
        }
        .btn-primary:hover {
            background-color: #0b5ed7;
            border-color: #0a58ca;
        }
    </style>
</head>
<body>
<div class="container my-5">
    <div class="card shadow">
        <div class="card-header">
            <i class="fas fa-redo"></i> Đặt lại đơn hàng
        </div>
        <div class="card-body">
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

                <h5 class="text-primary mt-4 mb-2">Sản phẩm</h5>
                <div class="table-responsive">
                    <table class="table table-bordered">
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
                </div>

                <div class="mb-3">
                    <label class="form-label">Tổng tiền:</label>
                    <input type="text" class="form-control" name="totalPrice"
                           value="<%= String.format("%,.2f ₫", order.getTotalPrice())%>" id="reorderTotal" readonly />
                </div>

                <div class="d-flex justify-content-between mt-4">
                    <a href="my-orders" class="btn btn-outline-primary">Quay về</a>
                    <button type="submit" class="btn btn-primary">Đặt lại đơn hàng</button>
                </div>
            </form>
        </div>
    </div>
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
    <%@ include file="/WEB-INF/include/footer.jsp" %>

</html>
