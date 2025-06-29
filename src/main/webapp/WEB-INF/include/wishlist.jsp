<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Wishlist" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Voucher" %>
<%@ include file="header.jsp" %>

<%
    List<Wishlist> wishlist = (List<Wishlist>) request.getAttribute("wishlist");
    List<Voucher> voucherList = (List<Voucher>) request.getAttribute("voucherList");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Danh sách yêu thích</title>
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: #f4f6f9;
                margin: 0;
                padding: 0;
            }

            .sidebar {
                position: fixed;
                top: 80px;
                left: 0;
                width: 220px;
                height: calc(100% - 80px);
                background-color: #ffffff;
                border-right: 1px solid #ddd;
                padding-top: 20px;
            }

            .sidebar a {
                display: block;
                padding: 14px 20px;
                color: #333;
                font-size: 16px;
                text-decoration: none;
            }

            .sidebar a:hover {
                background-color: #007bff;
                color: white;
            }

            .main-content {
                margin-left: 240px;
                padding: 100px 30px 30px;
            }

            .wishlist-container {
                background-color: #ffffff;
                border-radius: 10px;
                padding: 30px;
                box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
                max-width: 1000px;
                margin: 0 auto;
            }

            .wishlist-container h2 {
                text-align: center;
                margin-bottom: 30px;
                color: #333;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }

            th, td {
                border: 1px solid #e0e0e0;
                padding: 12px;
                text-align: center;
            }

            th {
                background-color: #f0f0f0;
                font-weight: 600;
            }

            td img {
                width: 90px;
                border-radius: 8px;
            }

            .no-wishlist {
                text-align: center;
                color: #888;
                margin-top: 40px;
                font-size: 18px;
            }

            @media (max-width: 768px) {
                .sidebar {
                    display: none;
                }
                .main-content {
                    margin-left: 0;
                    padding: 20px;
                }
            }
        </style>
        <style>
            .delete-btn {
                background-color: #dc3545;
                color: white;
                padding: 6px 12px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
            }

            .delete-btn:hover {
                background-color: #c82333;
            }

        </style>
        <style>
            .success-msg {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
                padding: 10px;
                border-radius: 5px;
                text-align: center;
                font-weight: 500;
                margin-bottom: 20px;
            }
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0,0,0,0.4);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 2000;
            }

            .modal-box {
                background: white;
                padding: 20px 30px;
                border-radius: 10px;
                text-align: center;
                max-width: 400px;
                width: 100%;
                box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            }

            .modal-actions {
                margin-top: 20px;
                display: flex;
                justify-content: center;
                gap: 15px;
            }

            .confirm-btn {
                background-color: #dc3545;
                color: white;
                border: none;
                padding: 10px 20px;
                font-weight: bold;
                border-radius: 5px;
                cursor: pointer;
            }

            .confirm-btn:hover {
                background-color: #c82333;
            }

            .cancel-btn {
                background-color: #6c757d;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
            }

            .cancel-btn:hover {
                background-color: #5a6268;
            }

        </style>
    </head>
    <body>

        <!-- Sidebar Section -->
        <div class="sidebar">
            <a href="view-profile">Thông tin tài khoản</a>
            <a href="#">Quản lý đơn hàng</a>
            <a href="#">Sở địa chỉ</a>
            <a href="#">Thông báo</a>
            <a href="#">Điểm thành viên</a>
            <!-- Thêm mục Kho voucher -->
            <a href="ViewMyVoucher">Kho voucher</a>
            <a href="ViewWishlist">Danh sách yêu thích</a>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="wishlist-container">
                <h2>Sản phẩm yêu thích của bạn</h2>
                <%
                    String successMessage = (String) session.getAttribute("successMessage");
                    if (successMessage != null) {
                %>
                <div style="text-align:center; color: green; margin-bottom: 15px; font-weight: bold;">
                    <div class="success-msg"><%= successMessage%></div>

                </div>
                <%
                        session.removeAttribute("successMessage"); // Xóa sau khi hiển thị
                    }
                %>

                <style>
                    table {
                        border-collapse: collapse;
                        width: 80%;
                        margin: 20px 0;
                    }
                    th, td {
                        border: 1px solid #888;
                        padding: 8px 12px;
                        text-align: center;
                    }
                    th {
                        background: #eee;
                    }
                    .expired {
                        color: red;
                        font-weight: bold;
                    }
                </style>
                <%
                    if (wishlist != null && !wishlist.isEmpty()) {
                %>
                <table>
                    <tr>
                        <th>Hình ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Giá</th>
                        <th>Ngày thêm</th>
                        <th>Thao tác</th>
                    </tr>

                    <%
                        for (Wishlist item : wishlist) {
                    %>
                    <tr>
                        <td><img src="<%= item.getImageUrl()%>" alt="Ảnh sản phẩm" /></td>
                        <td><%= item.getProductName()%></td>
                        <td><%= String.format("%,.0f", item.getPrice())%> đ</td>
                        <td><%= new java.text.SimpleDateFormat("dd-MM-yyyy").format(item.getAddedAt())%></td>
                        <td>
                            <!-- Nút mở modal -->
                            <button class="delete-btn" onclick="openModal(<%= item.getProductId()%>)">Xóa</button>

                        </td>
                    </tr>

                    <% } %>
                </table>
                <%
                } else {
                %>
                <p class="no-wishlist">Bạn chưa có sản phẩm yêu thích nào.</p>
                <%
                    }
                %>
            </div>
        </div>
        <!-- Modal Xác nhận -->
        <div id="confirmModal" class="modal-overlay" style="display:none;">
            <div class="modal-box">
                <p>Bạn có chắc muốn xóa sản phẩm này?</p>
                <form id="deleteForm" method="post" action="RemoveFromWishlist">
                    <input type="hidden" name="productId" id="modalProductId">
                    <div class="modal-actions">
                        <button type="submit" class="confirm-btn">Xác nhận</button>
                        <button type="button" class="cancel-btn" onclick="closeModal()">Hủy</button>
                    </div>
                </form>
            </div>
        </div>

    </body>
</html>
<script>
    function openModal(productId) {
        document.getElementById('modalProductId').value = productId;
        document.getElementById('confirmModal').style.display = 'flex';
    }

    function closeModal() {
        document.getElementById('confirmModal').style.display = 'none';
    }
</script>

<%@ include file="footer.jsp" %>
