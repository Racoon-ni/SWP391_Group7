<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết đơn hàng</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .product-img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <div class="container mt-5 mb-5">
        <h2 class="mb-4"><i class="fas fa-box"></i> Chi tiết đơn hàng #1001</h2>

        <div class="mb-4">
            <p><strong>Ngày đặt:</strong> 2025-06-15</p>
            <p><strong>Người nhận:</strong> Nguyễn Văn A</p>
            <p><strong>Số điện thoại:</strong> 0909123456</p>
            <p><strong>Địa chỉ giao hàng:</strong> 123 Đường Lê Lợi, Quận 1, TP.HCM</p>
            <p><strong>Phương thức thanh toán:</strong> COD</p>
            <p><strong>Trạng thái thanh toán:</strong> <span class="badge bg-success">Đã thanh toán</span></p>
        </div>

        <table class="table table-bordered text-center align-middle">
            <thead class="table-dark">
                <tr>
                    <th>Ảnh</th>
                    <th>Sản phẩm</th>
                    <th>Số lượng</th>
                    <th>Đơn giá</th>
                    <th>Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <img class="product-img" src="https://product.hstatic.net/200000722513/product/pc_gaming_gvn_infinity_rtx4060_e4d91d5e69a14e0a9c4b7ffb1e1dd05e.jpg" alt="PC RTX 4060">
                    </td>
                    <td>PC Gaming Infinity RTX 4060</td>
                    <td>1</td>
                    <td>15.000.000đ</td>
                    <td>15.000.000đ</td>
                </tr>
                <!-- Thêm sản phẩm khác nếu cần -->
            </tbody>
        </table>

        <div class="text-end mt-3">
            <h5><strong>Tổng tiền đơn hàng:</strong> 15.000.000đ</h5>
        </div>

        <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-secondary mt-3">
            <i class="fas fa-arrow-left"></i> Quay về danh sách đơn hàng
        </a>
    </div>
</body>
</html>
