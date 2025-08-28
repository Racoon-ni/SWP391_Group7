<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Order, model.OrderDetail, model.ShippingInfo" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    Order order = (Order) request.getAttribute("order");
    List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("orderDetails");
    ShippingInfo shipping = (ShippingInfo) request.getAttribute("shipping");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết đơn hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            body {
                background: #eef1f7;
                font-family: 'Segoe UI', sans-serif;
            }

            .card {
                border-radius: 18px;
                border: none;
                overflow: hidden;
                box-shadow: 0 8px 28px rgba(0,0,0,0.08);
            }

            .card-header {
                background: linear-gradient(135deg, #6a11cb, #2575fc);
                color: white;
                font-size: 1.5rem;
                font-weight: 700;
                padding: 24px;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .info-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 12px 24px;
            }
            .info-item i {
                color: #2575fc;
                margin-right: 6px;
            }
            .info-label {
                font-weight: 600;
                color: #555;
            }

            /* Badge gradient */
            .badge-status {
                padding: 8px 16px;
                font-size: 0.9rem;
                border-radius: 20px;
                font-weight: 600;
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }
            .badge-pending {
                background: linear-gradient(135deg,#a1c4fd,#c2e9fb);
                color:#1a3d7c;
            }
            .badge-processing {
                background: linear-gradient(135deg,#f6d365,#fda085);
                color:#6d3100;
            }
            .badge-completed {
                background: linear-gradient(135deg,#84fab0,#8fd3f4);
                color:#084c2f;
            }
            .badge-cancelled {
                background: linear-gradient(135deg,#f5576c,#f093fb);
                color:#fff;
            }

            /* Flash */
            .flash {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 12px 16px;
                border-radius: 6px;
                font-weight: 500;
                margin-bottom: 20px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }

            .flash-success {
                background-color: #dff9fb;
                color: #0984e3;
                border-left: 4px solid #74b9ff;
            }

            .flash-error {
                background-color: #fab1a0;
                color: #d63031;
                border-left: 4px solid #e17055;
            }

            .flash i {
                font-size: 20px;
            }


            /* Table */
            .table thead {
                background: linear-gradient(135deg,#dfe9f3,#ffffff);
                font-weight: 600;
            }
            .table-hover tbody tr:hover {
                background-color: #f7fbff;
            }
            .table img {
                width: 60px;
                border-radius: 12px;
            }

            /* Buttons */
            .btn-edit {
                background: linear-gradient(45deg, #007bff, #00c6ff);
                border: none;
                font-weight: 600;
                color: white;
                padding: 10px 22px;
                border-radius: 12px;
                transition: transform 0.2s;
            }
            .btn-edit:hover {
                transform: translateY(-2px);
                background: linear-gradient(45deg,#0056d2,#00a3cc);
            }
            .btn-back {
                border-radius: 12px;
                font-weight: 500;
            }

            /* Progress tracker */
            .progress-tracker {
                display: flex;
                justify-content: space-between;
                margin: 20px 0;
                position: relative;
            }
            .progress-tracker::before {
                content: "";
                position: absolute;
                top: 50%;
                left: 0;
                right: 0;
                height: 4px;
                background: #dee2e6;
                z-index: 1;
            }
            .progress-step {
                position: relative;
                z-index: 2;
                text-align: center;
                flex: 1;
            }
            .progress-step i {
                font-size: 22px;
                background: #fff;
                border: 3px solid #dee2e6;
                border-radius: 50%;
                padding: 10px;
                z-index: 2;
                position: relative;
            }
            .progress-step.active i {
                border-color: #2575fc;
                color: #2575fc;
            }
            .progress-step.completed i {
                border-color: #28a745;
                color: #28a745;
            }
            .progress-label {
                font-size: 0.85rem;
                margin-top: 6px;
                font-weight: 500;
                color: #495057;
            }
        </style>
    </head>
    <body>

        <div class="container my-5">

            <!-- Flash messages -->
            <c:choose>
                <c:when test="${not empty error}">
                    <div class="flash flash-error" id="flashMsg">
                        <i class="bi bi-x-circle-fill"></i>
                        <div><strong>Lỗi:</strong> ${error}</div>
                    </div>
                </c:when>
                <c:when test="${not empty message}">
                    <div class="flash flash-success" id="flashMsg">
                        <i class="bi bi-check-circle-fill"></i>
                        <div>${message}</div>
                    </div>
                </c:when>
            </c:choose>

            <script>
                // Tự động biến mất sau 5 giây
                setTimeout(() => {
                    const flash = document.getElementById("flashMsg");
                    if (flash) {
                        flash.style.transition = "opacity 0.8s ease";
                        flash.style.opacity = "0";
                        setTimeout(() => flash.remove(), 800);
                    }
                }, 5000);
            </script>


            <div class="card">
                <div class="card-header">
                    <i class="bi bi-receipt-cutoff fs-3"></i>
                    Chi tiết đơn hàng #<%= order.getOrderId()%>
                </div>
                <div class="card-body p-4">

                    <!-- Thông tin chung -->
                    <div class="info-grid mb-4">
                        <div class="info-item"><i class="bi bi-person-circle"></i> <span class="info-label">Người đặt:</span> <%= order.getUserId()%></div>
                        <div class="info-item"><i class="bi bi-calendar-event"></i> <span class="info-label">Ngày tạo:</span> <%= order.getCreatedAt()%></div>
                        <div class="info-item"><i class="bi bi-flag"></i> <span class="info-label">Trạng thái:</span>
                            <% if ("Pending".equals(order.getStatus())) { %>
                            <span class="badge badge-status badge-pending"><i class="bi bi-hourglass-split"></i>Chờ xử lý</span>
                            <% } else if ("Processing".equals(order.getStatus())) { %>
                            <span class="badge badge-status badge-processing"><i class="bi bi-gear-fill"></i>Đang xử lý</span>
                            <% } else if ("Completed".equals(order.getStatus())) { %>
                            <span class="badge badge-status badge-completed"><i class="bi bi-check-circle-fill"></i>Hoàn thành</span>
                            <% } else if ("Cancelled".equals(order.getStatus())) { %>
                            <span class="badge badge-status badge-cancelled"><i class="bi bi-x-circle-fill"></i>Đã hủy</span>
                            <% }%>
                        </div>
                        <div class="info-item"><i class="bi bi-cash-stack"></i> <span class="info-label">Tổng tiền:</span> 
                            <strong class="text-danger fs-5"><%= String.format("%,.0f", order.getTotalPrice())%> VNĐ</strong>
                        </div>
                    </div>

                    <!-- Progress tracker -->
                    <div class="progress-tracker">
                        <div class="progress-step <%= "Pending".equals(order.getStatus()) || "Processing".equals(order.getStatus()) || "Completed".equals(order.getStatus()) ? "completed" : ""%>">
                            <i class="bi bi-hourglass-split"></i>
                            <div class="progress-label">Chờ xử lý</div>
                        </div>
                        <div class="progress-step <%= "Processing".equals(order.getStatus()) || "Completed".equals(order.getStatus()) ? "active" : ""%>">
                            <i class="bi bi-gear-fill"></i>
                            <div class="progress-label">Đang xử lý</div>
                        </div>
                        <div class="progress-step <%= "Completed".equals(order.getStatus()) ? "active completed" : ""%>">
                            <i class="bi bi-check-circle-fill"></i>
                            <div class="progress-label">Hoàn thành</div>
                        </div>
                    </div>

                    <!-- Cập nhật trạng thái -->
                    <h5 class="mb-3 text-primary"><i class="bi bi-arrow-repeat"></i> Cập nhật trạng thái đơn hàng</h5>
                    <% if (!"Cancelled".equalsIgnoreCase(order.getStatus())) {%>
                    <form action="manage-orders" method="post" class="row g-3 mb-4">
                        <input type="hidden" name="orderId" value="<%= order.getOrderId()%>" />
                        <div class="col-md-6 col-lg-4">
                            <select name="status" id="status" class="form-select">
                                <option value="Pending" <%= "Pending".equals(order.getStatus()) ? "selected" : ""%>>Chờ xử lý</option>
                                <option value="Processing" <%= "Processing".equals(order.getStatus()) ? "selected" : ""%>>Đang xử lý</option>
                                <option value="Completed" <%= "Completed".equals(order.getStatus()) ? "selected" : ""%>>Hoàn thành</option>
                                <option value="Cancelled" <%= "Cancelled".equals(order.getStatus()) ? "selected" : ""%>>Đã hủy</option>
                            </select>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <button type="submit" class="btn btn-edit w-100">
                                <i class="bi bi-save"></i> Cập nhật
                            </button>
                        </div>
                    </form>
                    <% } else { %>
                    <div class="flash flash-warning">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        Đơn hàng đã bị huỷ, không thể cập nhật trạng thái.
                    </div>
                    <% }%>

                    <!-- Thông tin giao hàng -->
                    <h5 class="mb-3 text-primary"><i class="bi bi-truck"></i> Thông tin giao hàng & thanh toán</h5>
                    <div class="info-grid mb-4">
                        <div><i class="bi bi-person"></i> <span class="info-label">Người nhận:</span> <%= shipping.getReceiverName()%></div>
                        <div><i class="bi bi-telephone"></i> <span class="info-label">SĐT:</span> <%= shipping.getPhone()%></div>
                        <div><i class="bi bi-geo-alt"></i> <span class="info-label">Địa chỉ:</span> <%= shipping.getShippingAddress()%></div>
                        <div><i class="bi bi-wallet2"></i> <span class="info-label">Thanh toán:</span> <%= shipping.getPaymentMethod()%> - <%= shipping.getPaymentStatus()%></div>
                    </div>



                    <!-- Danh sách sản phẩm -->
                    <h5 class="mb-3 text-primary"><i class="bi bi-bag"></i> Danh sách sản phẩm</h5>
                    <div class="table-responsive">
                        <table class="table align-middle table-hover">
                            <thead>
                                <tr>
                                    <th><i class="bi bi-image"></i> Ảnh</th>
                                    <th><i class="bi bi-box-seam"></i> Sản phẩm</th>
                                    <th><i class="bi bi-hash"></i> SL</th>
                                    <th><i class="bi bi-currency-exchange"></i> Đơn giá</th>
                                    <th><i class="bi bi-cash"></i> Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (OrderDetail item : details) {%>
                                <tr>
                                    <td><img src="<%= item.getImageUrl()%>" alt="Ảnh" /></td>
                                    <td><%= item.getProductName()%></td>
                                    <td><%= item.getQuantity()%></td>
                                    <td><%= String.format("%,.0f", item.getUnitPrice())%></td>
                                    <td class="text-danger fw-bold"><%= String.format("%,.0f", item.getUnitPrice() * item.getQuantity())%></td>
                                </tr>
                                <% }%>
                            </tbody>
                        </table>
                    </div>

                    <a href="manage-orders" class="btn btn-outline-secondary btn-back mt-3">
                        <i class="bi bi-arrow-left-circle"></i> Quay lại
                    </a>
                </div>
            </div>
        </div>

    </body>
</html>
