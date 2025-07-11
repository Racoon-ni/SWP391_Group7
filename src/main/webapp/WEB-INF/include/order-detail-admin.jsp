<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Order, model.OrderDetail, model.ShippingInfo" %>
<%
    Order order = (Order) request.getAttribute("order");
    List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("orderDetails");
    ShippingInfo shipping = (ShippingInfo) request.getAttribute("shipping");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết đơn hàng</title>
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f5f6fa;
        color: #2f3640;
    }

    .container {
        background-color: #ffffff;
        border-radius: 8px;
        padding: 30px;
        margin-top: 40px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    }

    h2, h4, h5 {
        color: #2d3436;
        margin-bottom: 20px;
    }

    .mb-3, .mb-4 {
        margin-bottom: 20px;
        font-size: 16px;
    }

    .mb-3 strong,
    .mb-4 strong {
        display: inline-block;
        min-width: 150px;
        color: #2c3e50;
    }

    .table {
        background-color: #ffffff;
        border-radius: 6px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
    }

    .table thead {
        background-color: #f1f2f6;
        font-weight: 600;
        text-align: center;
    }

    .table td, .table th {
        vertical-align: middle;
        text-align: center;
        padding: 12px;
    }

    .table img {
        width: 60px;
        border-radius: 6px;
    }

    .form-select {
        width: 300px;
        padding: 8px 12px;
        border-radius: 6px;
        border: 1px solid #ced4da;
    }

    .btn-edit {
        background-color: #00b894;
        color: white;
        border: none;
        padding: 8px 20px;
        border-radius: 6px;
        font-weight: bold;
        transition: all 0.3s ease;
        margin-top: 10px;
    }

    .btn-edit:hover {
        background-color: #019875;
    }

    .btn-secondary {
        background-color: #636e72;
        color: white;
        padding: 8px 16px;
        border-radius: 6px;
        border: none;
        text-decoration: none;
        transition: background-color 0.3s;
    }

    .btn-secondary:hover {
        background-color: #4b5254;
    }

    .flash-success {
        padding: 12px 16px;
        background-color: #dff9fb;
        color: #0984e3;
        border-left: 4px solid #74b9ff;
        border-radius: 5px;
        margin-bottom: 20px;
    }
</style>


    </head>
    <body>
        <%
            String flashMessage = null;
            if (session.getAttribute("flashMessage") != null) {
                flashMessage = (String) session.getAttribute("flashMessage");
                session.removeAttribute("flashMessage"); // ⚠️ Xóa sau khi hiển thị 1 lần
            }
        %>

    <c:if test="${not empty flashMessage}">
        <div style="padding: 10px; margin-bottom: 20px; background-color: #d4edda; color: #155724;
             border: 1px solid #c3e6cb; border-radius: 4px;">
            ${flashMessage}
        </div>
    </c:if>

    <div class="container mt-5">
        <h2>Chi tiết đơn hàng #<%= order.getOrderId()%></h2>

        <div class="mb-3">
            <strong>Người đặt (User ID):</strong> <%= order.getUserId()%><br>
            <strong>Ngày tạo:</strong> <%= order.getCreatedAt()%><br>
            <strong>Trạng thái:</strong> <%= order.getStatus()%><br>
            <strong>Tổng tiền:</strong> <%= String.format("%,.0f", order.getTotalPrice())%> VNĐ
        </div>

        <div class="mb-4">
            <h5>Thông tin giao hàng & thanh toán</h5>
            <strong>Người nhận:</strong> <%= shipping.getReceiverName()%><br>
            <strong>SĐT:</strong> <%= shipping.getPhone()%><br>
            <strong>Địa chỉ:</strong> <%= shipping.getShippingAddress()%><br>
            <strong>Phương thức thanh toán:</strong> <%= shipping.getPaymentMethod()%><br>
            <strong>Trạng thái thanh toán:</strong> <%= shipping.getPaymentStatus()%>
        </div>

        <h4>Danh sách sản phẩm:</h4>
        <table class="table table-bordered">
            <thead class="table-secondary">
                <tr>
                    <th>Ảnh</th>
                    <th>Tên sản phẩm</th>
                    <th>Số lượng</th>
                    <th>Đơn giá (VNĐ)</th>
                    <th>Thành tiền (VNĐ)</th>
                </tr>
            </thead>
            <h4>Cập nhật trạng thái đơn hàng</h4>
            <form action="manage-orders" method="post" style="margin-top: 20px;">
                <input type="hidden" name="orderId" value="${order.orderId}" />

                <label for="status">Trạng thái mới:</label>
                <select name="status" id="status" class="form-select" style="margin: 10px 0; padding: 6px;">
                    <option value="Pending" ${order.status == 'Pending' ? 'selected' : ''}>Chờ xử lý</option>
                    <option value="Processing" ${order.status == 'Processing' ? 'selected' : ''}>Đang xử lý</option>
                    <option value="Completed" ${order.status == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                    <option value="Cancelled" ${order.status == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                </select>

                <button type="submit" class="btn btn-edit">Cập nhật</button>
            </form>

            <tbody>
                <% for (OrderDetail item : details) {%>
                <tr>
                    <td><img src="<%= item.getImageUrl()%>" alt="Ảnh" width="60"/></td>
                    <td><%= item.getProductName()%></td>
                    <td><%= item.getQuantity()%></td>
                    <td><%= String.format("%,.0f", item.getUnitPrice())%></td>
                    <td><%= String.format("%,.0f", item.getUnitPrice() * item.getQuantity())%></td>
                </tr>
                <% }%>
            </tbody>
        </table>

        <a href="manage-orders" class="btn btn-secondary mt-3">← Quay lại</a>
    </div>
</body>
</html>
