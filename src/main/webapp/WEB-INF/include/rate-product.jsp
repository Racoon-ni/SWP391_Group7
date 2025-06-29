<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.OrderDetail" %>
<%@ page import="java.util.List" %>

<%
    List<OrderDetail> orderDetails = (List<OrderDetail>) request.getAttribute("orderDetails");
    int orderId = (Integer) request.getAttribute("orderId");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Đánh giá sản phẩm trong đơn hàng</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
    </head>
    <body>
        <div class="container mt-5">
            <h3>Đánh giá các sản phẩm trong đơn hàng #<%= orderId%></h3>
            <form action="rateProduct" method="post">
                <input type="hidden" name="orderId" value="<%= orderId%>"/>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Đánh giá (1-5 sao)</th>
                            <th>Nhận xét</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (orderDetails != null && !orderDetails.isEmpty()) {
                                for (OrderDetail item : orderDetails) {
                        %>
                        <tr>
                            <td><%= item.getProductName()%></td>
                            <td>
                                <%
                                    if (item.isRated()) {
                                %>
                                <span class="text-success">Đã đánh giá</span>
                                <input type="hidden" name="productIds[]" value="<%= item.getProductId()%>" />
                                <input type="hidden" name="stars[]" value="" />
                                <%
                                } else {
                                %>
                                <input type="hidden" name="productIds[]" value="<%= item.getProductId()%>" />
                                <input type="number" name="stars[]" min="1" max="5" class="form-control" style="width:80px;display:inline-block;" value="5" required>
                                <%
                                    }
                                %>
                            </td>
                            <td>
                                <%
                                    if (item.isRated()) {
                                %>
                                <span class="text-muted">Đã gửi đánh giá</span>
                                <input type="hidden" name="comments[]" value="" />
                                <%
                                } else {
                                %>
                                <input type="text" name="comments[]" class="form-control" required>
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
                            <td colspan="3" class="text-center">Không có sản phẩm nào trong đơn hàng.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
                <button type="submit" class="btn btn-success">Gửi đánh giá</button>
                <a href="my-orders" class="btn btn-secondary">Quay lại</a>
            </form>
        </div>
    </body>
</html>
