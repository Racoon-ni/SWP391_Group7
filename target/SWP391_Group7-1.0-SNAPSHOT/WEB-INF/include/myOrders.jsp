<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Đơn hàng của tôi</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="mb-4"><i class="fas fa-receipt"></i> Đơn hàng của tôi</h2>

        <table class="table table-bordered text-center align-middle">
            <thead class="table-dark">
                <tr>
                    <th>Ảnh</th>
                    <th>Tên sản phẩm</th>
                    <th>Mã đơn</th>
                    <th>Ngày đặt</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th>Chi tiết</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><img src="https://product.hstatic.net/200000722513/product/pc_gaming_gvn_infinity_rtx4060_e4d91d5e69a14e0a9c4b7ffb1e1dd05e.jpg" width="100" height="100"/></td>
                    <td>PC Gaming Infinity RTX 4060</td>
                    <td>#1001</td>
                    <td>2025-06-15</td>
                    <td>15.000.000đ</td>
                    <td><span class="badge bg-success">Hoàn tất</span></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/order-details?id=1001" class="btn btn-sm btn-outline-primary">Xem</a>
                    </td>
                </tr>
                <tr>
                    <td><img src="https://product.hstatic.net/200000722513/product/pc_gaming_omega_31dc17061efb4a4a86911f23cdbcb943.jpg" width="100" height="100"/></td>
                    <td>PC Omega Pro RTX 4070</td>
                    <td>#1002</td>
                    <td>2025-06-10</td>
                    <td>21.500.000đ</td>
                    <td><span class="badge bg-warning text-dark">Đang giao</span></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/order-details?id=1002" class="btn btn-sm btn-outline-primary">Xem</a>
                    </td>
                </tr>
                <tr>
                    <td><img src="https://product.hstatic.net/200000722513/product/pc_gaming_alpha_4060ti_260bef55cf67425dbd0ad8724f43d80c.jpg" width="100" height="100"/></td>
                    <td>PC Alpha RTX 4060 Ti</td>
                    <td>#1003</td>
                    <td>2025-06-01</td>
                    <td>18.300.000đ</td>
                    <td><span class="badge bg-danger">Đã hủy</span></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/order-details?id=1003" class="btn btn-sm btn-outline-primary">Xem</a>
                    </td>
                </tr>
            </tbody>
        </table>

        <a href="home.jsp" class="btn btn-secondary mt-3"><i class="fas fa-arrow-left"></i> Quay về Trang chủ</a>
    </div>
</body>
</html>
