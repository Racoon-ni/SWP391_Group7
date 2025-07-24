<%@ page pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.Order, java.text.*" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Order> orders = (List<Order>) request.getAttribute("orders");
%>

<!DOCTYPE html>

<html>
    

    <head>
        
        <meta charset="UTF-8">

        <title>Đơn hàng của tôi</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            body {
                background-color: #f8f9fa;
            }

            .order-header {
                background-color: #0d6efd;
                color: white;
                padding: 16px;
                border-radius: 8px;
                margin-bottom: 24px;
                display: flex;
                align-items: center;
                font-weight: 700;
                font-size: 1.5rem;
            }
            

            .order-header i {
                margin-right: 12px;
            }

            .table thead {
                background-color: #0d6efd;
                color: white;
            }

            .btn-action {
                border-radius: 20px;
                font-weight: 500;
            }

            .badge-pending {
                background: #fff3cd !important;
                color: #664d03 !important;
                font-weight: 600;
            }

            .alert {
                border-radius: 8px;
            }

            a.btn-back-home {
                margin-top: 24px;
                border-radius: 20px;
                padding: 8px 20px;
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <div class="order-header">
                <i class="fas fa-receipt"></i> Đơn hàng của tôi
            </div>

            <% String msg = request.getParameter("msg"); %>
            <% if (msg != null) { %>
            <% if ("reorder_success".equals(msg)) { %>
            <div class="alert alert-success auto-dismiss">Đặt lại đơn hàng thành công! Đơn hàng mới đã được tạo.</div>
            <% } else if ("reorder_fail".equals(msg)) { %>
            <div class="alert alert-danger auto-dismiss">Không thể đặt lại đơn hàng. Vui lòng thử lại.</div>
            <% } else if ("cancel_success".equals(msg)) { %>
            <div class="alert alert-warning auto-dismiss">Đơn hàng đã được hủy thành công.</div>
            <% } else if ("cancel_fail".equals(msg)) { %>
            <div class="alert alert-danger auto-dismiss">Không thể hủy đơn hàng. Vui lòng thử lại.</div>
            <% } else if ("rating_success".equals(msg)) { %>
            <div class="alert alert-success auto-dismiss">Đánh giá thành công!</div>
            <% } else if ("already_rated".equals(msg)) { %>
            <div class="alert alert-warning auto-dismiss">Bạn đã đánh giá sản phẩm này trong đơn này rồi.</div>
            <% } else if ("rating_fail".equals(msg)) { %>
            <div class="alert alert-danger auto-dismiss">Đánh giá thất bại!</div>
            <% } else if ("error".equals(msg)) { %>
            <div class="alert alert-danger auto-dismiss">Có lỗi xảy ra!</div>
            <% } %>
            <% } %>

            <table class="table table-bordered text-center align-middle shadow-sm bg-white rounded">
                <thead>
                    <tr>
                        <th style="width:8%;">Mã đơn</th>
                        <th style="width:14%;">Ngày đặt</th>
                        <th style="width:18%;">Tổng tiền</th>
                        <th style="width:14%;">Trạng thái</th>
                        <th style="width:12%;">Chi tiết</th>
                        <th style="width:20%;">Tác vụ</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (orders == null || orders.isEmpty()) { %>
                    <tr><td colspan="6">Không có đơn hàng nào!</td></tr>
                    <% } else {
                        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                        NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                        for (Order order : orders) {
                            String fullOrderId = String.format("DH%06d", order.getOrderId());
                    %>
                    <tr>
                        <td><%= fullOrderId%></td>
                        <td><%= df.format(order.getCreatedAt())%></td>
                        <td><%= nf.format(order.getTotalPrice())%></td>
                        <td>
                            <% if ("Completed".equals(order.getStatus())) { %>
                            <span class="badge bg-success">Hoàn tất</span>
                            <% } else if ("Shipped".equals(order.getStatus())) { %>
                            <span class="badge bg-warning text-dark">Đang giao</span>
                            <% } else if ("Canceled".equals(order.getStatus())) { %>
                            <span class="badge bg-danger">Đã hủy</span>
                            <% } else if ("Pending".equals(order.getStatus())) { %>
                            <span class="badge badge-pending">Chờ xử lý</span>
                            <% } else {%>
                            <span class="badge bg-secondary"><%= order.getStatus()%></span>
                            <% }%>
                        </td>
                        <td>
                            <a href="order-details?order_id=<%= order.getOrderId()%>"
                               class="btn btn-outline-primary btn-action btn-sm">
                                <i class="fas fa-eye"></i> Xem
                            </a>
                        </td>
                        <td>
                            <div class="d-flex flex-wrap justify-content-center gap-2">
                                <% if ("Pending".equals(order.getStatus())) {%>
                                <button type="button" class="btn btn-outline-danger btn-action btn-sm"
                                        data-bs-toggle="modal" data-bs-target="#cancelOrderModal"
                                        data-order-id="<%= order.getOrderId()%>">
                                    <i class="fas fa-times"></i> Hủy
                                </button>
                                <% } %>

                                <% if ("Completed".equals(order.getStatus())) {%>
                                <form action="rateProduct" method="get">
                                    <input type="hidden" name="orderId" value="<%= order.getOrderId()%>" />
                                    <button type="submit" class="btn btn-outline-success btn-action btn-sm">
                                        <i class="fas fa-star"></i> Đánh giá
                                    </button>
                                </form>
                                <% } %>

                                <% if (!"Pending".equals(order.getStatus())) {%>
                                <form action="reorder" method="get">
                                    <input type="hidden" name="orderId" value="<%= order.getOrderId()%>" />
                                    <button type="submit" class="btn btn-outline-secondary btn-action btn-sm">
                                        <i class="fas fa-redo"></i> Mua lại
                                    </button>
                                </form>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% }
        }%>
                </tbody>

            </table>

            <a href="home.jsp" class="btn btn-secondary btn-back-home">
                <i class="fas fa-arrow-left"></i> Quay về Trang chủ
            </a>
        </div>

        <!-- Modal hủy đơn -->
        <div class="modal fade" id="cancelOrderModal" tabindex="-1" aria-labelledby="cancelOrderModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content rounded-4">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title" id="cancelOrderModalLabel">
                            <i class="fas fa-times-circle"></i> Xác nhận hủy đơn
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        Bạn có chắc chắn muốn hủy đơn hàng này không?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <form id="cancelOrderForm" method="post" action="CancelOrderSevlet" style="display:inline;">
                            <input type="hidden" name="orderId" id="modalOrderId" />
                            <button type="submit" class="btn btn-danger"><i class="fas fa-times"></i> Xác nhận hủy</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Set order ID vào form khi mở modal
            var cancelOrderModal = document.getElementById('cancelOrderModal');
            cancelOrderModal.addEventListener('show.bs.modal', function (event) {
                var button = event.relatedTarget;
                var orderId = button.getAttribute('data-order-id');
                document.getElementById('modalOrderId').value = orderId;
            });

            // Tự động ẩn thông báo
            setTimeout(() => {
                document.querySelectorAll('.auto-dismiss').forEach(alert => {
                    alert.style.transition = "opacity 0.5s ease";
                    alert.style.opacity = 0;
                    setTimeout(() => alert.remove(), 500);
                });
            }, 5000);
        </script>
        <%@ include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
