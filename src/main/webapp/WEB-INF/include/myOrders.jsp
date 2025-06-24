<<<<<<< HEAD
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
=======
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
    }
%>
>>>>>>> a34aa2aa0a008f7a437c09b28940238d4f6657ea
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đơn hàng của tôi</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            .btn-cancel {
                border-radius: 18px;
                background: #ffe5e9;
                color: #d90429;
                border: none;
                font-weight: 500;
                transition: 0.2s;
            }
            .btn-cancel:hover {
                background: #d90429;
                color: #fff;
                box-shadow: 0 2px 8px #d9042940;
            }
            .badge-pending {
                background: #fff3cd !important;
                color: #664d03 !important;
                font-weight: 600;
            }
            .badge-success, .badge-danger {
                font-weight: 600;
            }
            .btn-view {
                border-radius: 18px;
                font-weight: 500;
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <h2 class="mb-4" style="font-weight:700"><i class="fas fa-receipt"></i> Đơn hàng của tôi</h2>
            <c:if test="${param.msg == 'reorder_success'}">
                <div class="alert alert-success mb-3">Đặt lại đơn hàng thành công! Đơn hàng mới đã được tạo.</div>
            </c:if>
            <c:if test="${param.msg == 'reorder_fail'}">
                <div class="alert alert-danger mb-3">Không thể đặt lại đơn hàng. Vui lòng thử lại.</div>
            </c:if>

            <table class="table table-bordered text-center align-middle">
                <thead class="table-dark">
                    <tr>
                        <th style="width:8%;">Mã đơn</th>
                        <th style="width:14%;">Ngày đặt</th>
                        <th style="width:18%;">Tổng tiền</th>
                        <th style="width:14%;">Trạng thái</th>
                        <th style="width:12%;">Chi tiết</th>
                        <th style="width:10%;">Tác vụ</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="6">Không có đơn hàng nào!</td>
                        </tr>
                    </c:if>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td>#${order.orderId}</td>
                            <td><fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd"/></td>
                            <td><fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.status eq 'Completed'}">
                                        <span class="badge bg-success">Hoàn tất</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'Shipped'}">
                                        <span class="badge bg-warning text-dark">Đang giao</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'Canceled'}">
                                        <span class="badge bg-danger">Đã hủy</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'Pending'}">
                                        <span class="badge badge-pending">Chờ xử lý</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">${order.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/order-details?order_id=${order.orderId}" class="btn btn-outline-primary btn-view btn-sm">
                                    <i class="fas fa-eye"></i> Xem
                                </a>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.status eq 'Pending'}">
                                        <button type="button"
                                                class="btn btn-cancel btn-sm px-3"
                                                data-bs-toggle="modal"
                                                data-bs-target="#cancelOrderModal"
                                                data-order-id="${order.orderId}">
                                            <i class="fas fa-times"></i> Hủy
                                        </button>
                                    </c:when>
                                    <c:when test="${order.status ne 'Pending'}">
                                        <form action="${pageContext.request.contextPath}/reorder" method="get" style="display:inline;">
                                            <input type="hidden" name="orderId" value="${order.orderId}" />
                                            <button type="submit" class="btn btn-success btn-sm">
                                                <i class="fas fa-redo"></i> Mua lại
                                            </button>
                                        </form>
                                    </c:when>


                                    <c:otherwise>
                                        <span class="text-muted" style="font-size:0.95em;">—</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <a href="home.jsp" class="btn btn-secondary mt-3"><i class="fas fa-arrow-left"></i> Quay về Trang chủ</a>
        </div>

        <!-- Modal xác nhận hủy đơn -->
        <div class="modal fade" id="cancelOrderModal" tabindex="-1" aria-labelledby="cancelOrderModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="cancelOrderModalLabel"><i class="fas fa-times-circle text-danger"></i> Xác nhận hủy đơn</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        Bạn có chắc chắn muốn hủy đơn hàng này không?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <form id="cancelOrderForm" method="post" action="CancelOrderSevlet" style="display:inline;">
                            <input type="hidden" name="orderId" id="modalOrderId" value="">
                            <button type="submit" class="btn btn-danger"><i class="fas fa-times"></i> Xác nhận hủy</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Mua lại: Chỉnh sửa số điện thoại, địa chỉ, thanh toán -->
        <div class="modal fade" id="reorderEditModal" tabindex="-1" aria-labelledby="reorderEditModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <form id="reorderForm" action="ReorderServlet" method="post" class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="reorderEditModalLabel"><i class="fas fa-redo text-success"></i> Đặt lại đơn hàng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="orderId" id="modalReorderOrderId">
                        <div class="mb-3">
                            <label for="modalReorderPhone" class="form-label">Số điện thoại:</label>
                            <input type="text" class="form-control" name="phone" id="modalReorderPhone" required>
                        </div>
                        <div class="mb-3">
                            <label for="modalReorderAddress" class="form-label">Địa chỉ giao hàng:</label>
                            <input type="text" class="form-control" name="address" id="modalReorderAddress" required>
                        </div>
                        <div class="mb-3">
                            <label for="modalReorderPayment" class="form-label">Phương thức thanh toán:</label>
                            <select class="form-select" name="paymentMethod" id="modalReorderPayment" required>
                                <option value="COD">COD (Thanh toán khi nhận)</option>
                                <option value="Card">Card</option>
                                <option value="E-Wallet">Ví điện tử</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>

                    </div>
                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Cho nút Hủy
            var cancelOrderModal = document.getElementById('cancelOrderModal');
            cancelOrderModal.addEventListener('show.bs.modal', function (event) {
                var button = event.relatedTarget;
                var orderId = button.getAttribute('data-order-id');
                document.getElementById('modalOrderId').value = orderId;
            });

        </script>
    </body>
</html>
