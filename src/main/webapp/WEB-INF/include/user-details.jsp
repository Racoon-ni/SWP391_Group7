
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Order, model.OrderDetail, model.ShippingInfo" %>

<%
    List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("orderDetails");

    List<Order> orders = (List<Order>) request.getAttribute("orders");
%><!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết tài khoản</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            body {
                background-color: #f8f9fa;
                color: #212529;
            }
            .card {
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                margin-bottom: 20px;
                border: none;
            }
            .card-header {
                background-color: #0dcaf0;
                color: white;
                border-radius: 10px 10px 0 0 !important;
                font-weight: 600;
            }
            .profile-header {
                background: #0dcaf0;
                color: white;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 20px;
            }
            .badge-status {
                font-size: 0.9rem;
                padding: 5px 10px;
                border-radius: 20px;
            }
            .table img {
                border-radius: 5px;
                object-fit: cover;
                border: 1px solid #dee2e6;
            }
            .info-item {
                padding: 8px 0;
                border-bottom: 1px solid #eee;
            }
            .info-item:last-child {
                border-bottom: none;
            }
            .info-label {
                color: #6c757d;
                font-weight: 600;
                width: 160px;
                display: inline-block;
            }
            .back-btn {
                transition: all 0.3s;
            }
            .back-btn:hover {
                transform: translateX(-5px);
            }
            .table-responsive {
                border-radius: 10px;
                overflow: hidden;
            }
            .table {
                margin-bottom: 0;
            }
            .table thead th {
                border-bottom: none;
                background-color: cornflowerblue;
                color: white;
                font-weight: 500;
            }
            .empty-state {
                text-align: center;
                padding: 30px;
                color: #6c757d;
            }
            /* Orders section styles */
            .order-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 12px;
                flex-wrap: wrap;
            }
            .order-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 12px 20px;
                align-items: center;
            }
            .meta-item {
                color: #6c757d;
            }
            .meta-strong {
                color: #212529;
                font-weight: 600;
            }
            .toggle-btn {
                transition: transform 0.2s ease;
            }
            .toggle-btn[aria-expanded="true"] .chev {
                transform: rotate(180deg);
            }
            .order-total {
                font-weight: 700;
                color: #0d6efd;
            }
            .btn-outline {
                border: 1px solid #0dcaf0;
                color: #0dcaf0;
                background: transparent;
            }
            .btn-outline:hover {
                background: #0dcaf0;
                color: #fff;
            }
            .section-title {
                font-size: 1.05rem;
                font-weight: 600;
                margin-bottom: 8px;
            }
            .info-line {
                color: #6c757d;
            }
            @media (max-width: 576px) {
                .order-header {
                    flex-direction: column;
                    align-items: flex-start;
                }
            }
            .back-btn {
                background: linear-gradient(45deg, #6c757d, #495057);
                border: none;
                color: white;
                padding: 0.75rem 2rem;
                border-radius: 25px;
                transition: all 0.3s ease;
            }

            .back-btn:hover {
                background: linear-gradient(45deg, #495057, #343a40);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            }
        </style>
    </head>
    <body>
        <div class="container py-5">
            <div class="profile-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h2 class="mb-0"><i class="fas fa-user-circle me-2"></i>Chi tiết tài khoản</h2>
                    <span class="badge ${user.status ? 'bg-success' : 'bg-danger'} badge-status">
                        ${user.status ? '<i class="fas fa-check-circle me-1"></i> Đang hoạt động' : '<i class="fas fa-times-circle me-1"></i> Dừng hoạt động'}
                    </span>
                </div>
            </div>

            <div class="row">
                <div class="col-md-5">
                    <div class="card">
                        <div class="card-header">
                            <i class="fas fa-id-card me-2"></i>Thông tin tài khoản
                        </div>
                        <div class="card-body">
                            <div class="info-item">
                                <span class="info-label"><i class="fas fa-user me-2"></i>Tên đăng nhập:</span>
                                <span class="fw-bold">${user.username}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label"><i class="fas fa-envelope me-2"></i>Email:</span>
                                <span>${user.email}</span>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <i class="fas fa-address-card me-2"></i>Thông tin cá nhân
                        </div>
                        <div class="card-body">
                            <div class="info-item">
                                <span class="info-label"><i class="fas fa-user me-2"></i>Họ Tên:</span>
                                <span class="fw-bold">${empty user.fullname ? 'Chưa cập nhật' : user.fullname}</span>
                            </div>

                            <div class="info-item">
                                <span class="info-label"><i class="fa-solid fa-calendar-days me-2"></i>Ngày Sinh:</span>
                                <span class="fw-bold">${empty user.dateOfBirth ? 'Chưa cập nhật' : user.dateOfBirth}</span>
                            </div>

                            <div class="info-item">
                                <span class="info-label"><i class="fa-solid fa-location-dot me-2"></i>Địa chỉ:</span>
                                <span class="fw-bold">${empty user.address ? 'Chưa cập nhật' : user.address}</span>
                            </div>

                            <div class="info-item">
                                <span class="info-label"><i class="fa-solid fa-phone me-1"></i>Số Điện Thoại:</span>
                                <span class="fw-bold">${empty user.phone ? 'Chưa cập nhật' : user.phone}</span>
                            </div>

                            <div class="info-item">
                                <span class="info-label"><i class="fas fa-venus-mars me-1"></i>Giới Tính:</span>
                                <span class="fw-bold">${empty user.gender ? 'Chưa cập nhật' : user.gender}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Back Button -->
                    <div class="mb-4">
                        <button class="btn back-btn" onclick="window.history.back()">
                            ← Quay lại danh sách tài khoản
                        </button>
                    </div>
                </div>

                <div class="col-md-7">
                    <!-- New: Purchase History by Order -->
                    <div class="card">
                        <div class="card-header">
                            <i class="fas fa-receipt me-2"></i>Lịch sử mua hàng
                        </div>
                        <div class="card-body">

                            <!-- Tabs -->
                            <ul class="nav nav-tabs" id="historyTabs" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="orders-tab" data-bs-toggle="tab"
                                            data-bs-target="#orders" type="button" role="tab" aria-controls="orders"
                                            aria-selected="true">
                                        Theo đơn hàng
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="items-tab" data-bs-toggle="tab"
                                            data-bs-target="#items" type="button" role="tab" aria-controls="items"
                                            aria-selected="false">
                                        Theo sản phẩm
                                    </button>
                                </li>
                            </ul>

                            <!-- Tab Contents -->
                            <div class="tab-content pt-3" id="historyTabsContent">

                                <!-- Purchase History by Orders -->
                                <div class="tab-pane fade show active" id="orders" role="tabpanel" aria-labelledby="orders-tab">
                                    <%
                                        if (orders == null || orders.isEmpty()) {
                                    %>
                                    <div class="empty-state">
                                        <i class="fas fa-box-open fa-2x mb-2"></i>
                                        <div>Chưa có đơn hàng nào.</div>
                                    </div>
                                    <%
                                    } else {
                                        int idx = 0;
                                        for (Order o : orders) {
                                            String collapseId = "order_" + idx++;
                                            String status = String.valueOf(o.getStatus());
                                            String paymentSt = String.valueOf(o.getShippingInfo().getPaymentStatus());
                                            String statusClass = "bg-secondary";
                                            if ("Processing".equalsIgnoreCase(status) || "Pending".equalsIgnoreCase(status))
                                                statusClass = "bg-warning";
                                            else if ("Shipped".equalsIgnoreCase(status))
                                                statusClass = "bg-info";
                                            else if ("Completed".equalsIgnoreCase(status) || "Delivered".equalsIgnoreCase(status))
                                                statusClass = "bg-success";
                                            else if ("Cancelled".equalsIgnoreCase(status) || "Failed".equalsIgnoreCase(status))
                                                statusClass = "bg-danger";
                                    %>

                                    <div class="border rounded p-3 mb-3 bg-white">
                                        <div class="order-header">
                                            <div class="order-meta">
                                                <div class="meta-item">
                                                    <span class="text-muted">Mã đơn:</span>
                                                    <span class="meta-strong">#<%= o.getOrderId()%></span>
                                                </div>
                                                <div class="meta-item">
                                                    <span class="text-muted">Ngày:</span>
                                                    <span class="meta-strong"><%= o.getCreatedAt()%></span>
                                                </div>
                                                <div class="meta-item">
                                                    <span class="text-muted">Thanh toán:</span>
                                                    <span class="meta-strong"><%= o.getShippingInfo().getPaymentMethod() != null ? o.getShippingInfo().getPaymentMethod() : "—"%></span>
                                                </div>
                                                <div class="meta-item">
                                                    <span class="text-muted">Trạng thái:</span>
                                                    <span class="badge badge-status <%= statusClass%>"><%= status%></span>
                                                </div>
                                                <div class="meta-item">
                                                    <span class="text-muted">TT thanh toán:</span>
                                                    <span class="badge badge-status <%= "Paid".equalsIgnoreCase(paymentSt) ? "bg-success" : ("Refunded".equalsIgnoreCase(paymentSt) ? "bg-info" : "bg-secondary")%>"><%= paymentSt%></span>
                                                </div>
                                            </div>
                                            <div class="d-flex align-items-center gap-3">
                                                <div class="order-total">Tổng: <%= String.format("%,.0f", o.getTotalPrice())%> VND</div>
                                                <button class="btn btn-outline toggle-btn"
                                                        type="button"
                                                        data-bs-toggle="collapse"
                                                        data-bs-target="#<%= collapseId%>"
                                                        aria-expanded="false"
                                                        aria-controls="<%= collapseId%>">
                                                    <span class="me-2">Xem chi tiết</span>
                                                    <i class="fa-solid fa-chevron-down chev"></i>
                                                </button>
                                            </div>
                                        </div>

                                        <div class="collapse mt-3" id="<%= collapseId%>">
                                            <div class="table-responsive">
                                                <table class="table align-middle">
                                                    <thead>
                                                        <tr>
                                                            <th>Sản phẩm</th>
                                                            <th class="text-center" style="width:120px;">Số lượng</th>
                                                            <th class="text-end" style="width:140px;">Đơn giá (VND)</th>
                                                            <th class="text-end" style="width:160px;">Thành tiền (VND)</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <%

                                                            for (OrderDetail d : details) {
                                                                if (d.getOrderId() == o.getOrderId()) {

                                                                    double lineTotal = d.getUnitPrice() * d.getQuantity();
                                                        %>
                                                        <tr>
                                                            <td>
                                                                <div class="d-flex align-items-start">
                                                                    <div class="me-3" style="width:56px;height:56px;border:1px solid #dee2e6;border-radius:8px;overflow:hidden;background:#fff;">
                                                                        <div class="w-100 h-100 d-flex align-items-center justify-content-center text-muted">
                                                                            <img src="<%= d.getImageUrl()%>" width="50" alt="PC Image"/>
                                                                        </div>
                                                                    </div>
                                                                    <div>
                                                                        <div class="fw-semibold"><%= d.getProductName()%></div>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <td class="text-center"><%= d.getQuantity()%></td>
                                                            <td class="text-end"><%= String.format("%,.0f", d.getUnitPrice())%></td>
                                                            <td class="text-end fw-semibold"><%= String.format("%,.0f", lineTotal)%></td>
                                                        </tr>
                                                        <%
                                                                }
                                                            }
                                                        %>
                                                    </tbody>
                                                    <tfoot>
                                                        <tr>
                                                            <td colspan="3" class="text-end fw-semibold">Tổng đơn</td>
                                                            <td class="text-end fw-bold text-primary"><%= String.format("%,.0f", o.getTotalPrice())%></td>
                                                        </tr>
                                                    </tfoot>
                                                </table>
                                            </div>

                                            <!-- Optional: Shipping / Payment panel if available -->
                                            <%
                                                ShippingInfo ship = o.getShippingInfo();
                                                if (ship != null) {
                                            %>
                                            <div class="row g-3 mt-2">
                                                <div class="col-lg-6">
                                                    <div class="card" style="box-shadow:none;border:1px solid #e9ecef;">
                                                        <div class="card-body">
                                                            <div class="section-title"><i class="fa-solid fa-truck-fast me-2"></i>Giao hàng</div>
                                                            <div class="info-line"><span class="text-muted">Người nhận:</span> <strong><%= ship.getReceiverName()%></strong></div>
                                                            <div class="info-line"><span class="text-muted">Điện thoại:</span> <%= ship.getPhone()%></div>
                                                            <div class="info-line"><span class="text-muted">Địa chỉ:</span> <%= ship.getShippingAddress()%></div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6">
                                                    <div class="card" style="box-shadow:none;border:1px solid #e9ecef;">
                                                        <div class="card-body">
                                                            <div class="section-title"><i class="fa-solid fa-file-invoice-dollar me-2"></i>Thanh toán</div>
                                                            <div class="info-line"><span class="text-muted">Phương thức:</span> <%= o.getShippingInfo().getPaymentMethod() != null ? o.getShippingInfo().getPaymentMethod() : "—"%></div>
                                                            <div class="info-line"><span class="text-muted">Trạng thái thanh toán:</span> <%= paymentSt%></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <% } %>
                                        </div>
                                    </div>
                                    <div class="border rounded p-3 mb-3 bg-white">
                                        <!-- Order header, collapse, details… -->
                                    </div>
                                    <%      } // end for
                                        } // end else %>
                                </div>

                                <!-- Purchase History by Items -->
                                <div class="tab-pane fade" id="items" role="tabpanel" aria-labelledby="items-tab">
                                    <%
                                        if (details == null || details.isEmpty()) {
                                    %>
                                    <div class="empty-state">
                                        <i class="fas fa-box-open fa-2x mb-2"></i>
                                        <div>Chưa có sản phẩm nào.</div>
                                    </div>
                                    <%
                                    } else {
                                    %>
                                    <div class="table-responsive">
                                        <table class="table align-middle">
                                            <thead>
                                                <tr>
                                                    <th class="text-center">Mã đơn</th>
                                                    <th>Sản phẩm</th>
                                                    <th class="text-center" style="width:120px;">Số lượng</th>
                                                    <th class="text-end" style="width:140px;">Đơn giá (VND)</th>
                                                    <th class="text-end" style="width:160px;">Thành tiền (VND)</th>

                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    for (OrderDetail d : details) {
                                                        double lineTotal = d.getUnitPrice() * d.getQuantity();
                                                %>
                                                <tr>
                                                    <td class="text-center">#<%= d.getOrderId()%></td>
                                                    <td>
                                                        <div class="d-flex align-items-start">
                                                            <div class="me-3" style="width:56px;height:56px;border:1px solid #dee2e6;border-radius:8px;overflow:hidden;background:#fff;">
                                                                <div class="w-100 h-100 d-flex align-items-center justify-content-center text-muted">
                                                                    <img src="<%= d.getImageUrl()%>" width="50" alt="PC Image"/>
                                                                </div>
                                                            </div>
                                                            <div>
                                                                <div class="fw-semibold"><%= d.getProductName()%></div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="text-center"><%= d.getQuantity()%></td>
                                                    <td class="text-end"><%= String.format("%,.0f", d.getUnitPrice())%></td>
                                                    <td class="text-end fw-semibold"><%= String.format("%,.0f", lineTotal)%></td>

                                                </tr>
                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                    <% }%>
                                </div>
                            </div>
                        </div>
                    </div>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                            // Smoothly bring an opened order into view
                            document.addEventListener('shown.bs.collapse', function (e) {
                                var el = e.target.closest('.border.rounded');
                                if (el) {
                                    el.scrollIntoView({behavior: 'smooth', block: 'start'});
                                }
                            });
                    </script>
                    </html>
