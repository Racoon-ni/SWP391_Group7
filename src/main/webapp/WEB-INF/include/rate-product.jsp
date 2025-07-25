<%@ page pageEncoding="UTF-8" %>
<%@ page import="model.OrderDetail" %>
<%@ page import="java.util.List" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<%
    List<OrderDetail> orderDetails = (List<OrderDetail>) request.getAttribute("orderDetails");
    int orderId = (Integer) request.getAttribute("orderId");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Đánh giá sản phẩm trong đơn hàng</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .page-header {
                background-color: #0d6efd;
                color: #fff;
                padding: 16px;
                border-radius: 8px;
                margin-bottom: 24px;
                display: flex;
                align-items: center;
            }
            .page-header i {
                margin-right: 10px;
            }
            .btn-custom {
                border-radius: 18px;
                font-weight: 500;
            }
            .table thead th {
                vertical-align: middle;
            }
        </style>
    </head>
    <body>
        <div class="container py-5">
            <div class="page-header">
                <i class="fas fa-star"></i>
                <h3 class="mb-0">Đánh giá các sản phẩm trong đơn hàng #<%= orderId%></h3>
            </div>

            <form action="rateProduct" method="post" enctype="multipart/form-data">
                <input type="hidden" name="orderId" value="<%= orderId%>"/>
                <div class="table-responsive shadow-sm mb-4">
                    <table class="table table-bordered align-middle text-center">
                        <thead class="table-primary">
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Đánh giá (1-5 sao)</th>
                                <th>Nhận xét</th>
                                <th>Ảnh kèm theo</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (orderDetails != null && !orderDetails.isEmpty()) {
                                    for (OrderDetail item : orderDetails) {
                            %>
                            <tr>
                                <td class="text-start px-3"><%= item.getProductName()%></td>
                                <td>
                                    <%
                                        if (item.isRated()) {
                                    %>
                                    <span class="badge bg-success">Đã đánh giá</span>
                                    <%-- Không đưa vào form --%>
                                    <%
                                    } else {
                                    %>
                                    <input type="hidden" name="productIds[]" value="<%= item.getProductId()%>" />
                                    <input type="number" name="stars[]" min="1" max="5" class="form-control mx-auto" style="max-width:80px;" value="5">
                                    <%
                                        }
                                    %>
                                </td>
                                <td>
                                    <%
                                        if (item.isRated()) {
                                    %>
                                    <span class="text-muted">Đã gửi đánh giá</span>
                                    <%
                                    } else {
                                    %>
                                    <input type="text" name="comments[]" class="form-control" placeholder="Viết nhận xét...">
                                    <%
                                        }
                                    %>
                                </td>
                                <td>
                                    <%
                                        if (item.isRated()) {
                                    %>
                                    <span class="text-muted">-</span>
                                    <%
                                    } else {
                                    %>
                                    <input type="file" name="images_<%= item.getProductId()%>" accept="image/*" multiple class="form-control">
                                    <div class="form-text">Tùy chọn, chọn nhiều ảnh</div>
                                    <%
                                        }
                                    %>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="4" class="text-center text-muted py-4">Không có sản phẩm nào trong đơn hàng.</td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <button type="submit" class="btn btn-primary btn-custom">
                    <i class="fas fa-paper-plane"></i> Gửi đánh giá
                </button>
                <a href="my-orders" class="btn btn-outline-primary btn-custom ms-2">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </form>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/js/all.min.js"></script>
    </body>
        <%@ include file="/WEB-INF/include/footer.jsp" %>

</html>
