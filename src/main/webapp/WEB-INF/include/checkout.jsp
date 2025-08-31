<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.User" %>
<%@ page import="model.Cart" %>
<%@ page import="model.UserAddress" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<%
    DecimalFormat df = new DecimalFormat("#,###");
    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
    double totalAmount = (double) request.getAttribute("totalAmount");
    User user = (User) request.getAttribute("userInfo");
    List<UserAddress> addressList = (List<UserAddress>) new DAO.UserAddressDAO().getAddressesByUserId(user.getId());

    // Tổng phải thanh toán sau khi áp voucher (nếu có)
    Double fa = (Double) request.getAttribute("finalAmount");
    double payable = (fa != null ? fa : totalAmount);
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thanh toán</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <style>
            body {
                background-color: #f8f9fa;
                font-family: Arial, sans-serif;
            }
            .checkout-container {
                max-width: 1100px;
                margin: 30px auto;
                background: #fff;
                padding: 30px;
                border-radius: 10px;
            }
            .section-title {
                font-size: 24px;
                font-weight: bold;
            }
            .total-box {
                border: 1px solid #ccc;
                padding: 20px;
                border-radius: 8px;
                background: #f1f1f1;
            }
            .qr-box {
                border: 1px dashed #0d6efd;
                background: #f8fbff;
                border-radius: 10px;
                padding: 16px;
            }
            .qr-img {
                width: 180px;
                height: 180px;
                object-fit: contain;
                background: #fff;
                border: 1px solid #e5e5e5;
                border-radius: 8px;
            }
            .copy-btn {
                white-space: nowrap;
            }
            .info-row {
                display: grid;
                grid-template-columns: 140px 1fr auto;
                gap: 8px;
                align-items: center;
                margin-bottom: 10px;
            }
            .info-row label {
                font-weight: 600;
                color: #495057;
            }
        </style>
    </head>
    <body>

        <div class="container checkout-container">
            <div class="row g-4">
                <!-- Thông tin khách hàng -->
                <div class="col-lg-6">
                    <h4 class="section-title mb-4">Thông tin giao hàng</h4>
                    <form method="post" action="${pageContext.request.contextPath}/place-order" id="orderForm">
                        <!-- Cảnh báo khi không có địa chỉ -->
                        <% if (addressList == null || addressList.isEmpty()) { %>
                        <div class="alert alert-warning d-flex justify-content-between align-items-center">
                            <span>Bạn chưa có địa chỉ nhận hàng.</span>
                            <!-- Đi từ checkout, không có địa chỉ → lưu xong quay lại /checkout -->
                            <a class="btn btn-sm btn-primary"
                               href="${pageContext.request.contextPath}/ViewAddress?from=checkout&reason=no_address&return=/checkout">
                                Thêm địa chỉ
                            </a>
                        </div>
                        <% }%>

                        <!-- Danh sách địa chỉ -->
                        <div class="mb-3">
                            <label>Chọn địa chỉ nhận hàng</label>
                            <select class="form-select" id="addressSelect">
                                <c:forEach var="addr" items="<%= addressList%>">
                                    <option value="${addr.id}"
                                            data-name="${addr.fullName}"
                                            data-phone="${addr.phone}"
                                            data-address="${addr.specificAddress}"
                                            ${addr.defaultAddress ? "selected" : ""}>
                                        ${addr.fullName} - ${addr.phone} - ${addr.specificAddress}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <input
                            type="hidden"
                            name="finalAmount"
                            id="finalAmountHidden"
                            value="${finalAmount}" />
                        <input type="hidden" name="addressId" id="addressIdHidden">

                        <div class="mb-3">
                            <label>Họ tên</label>
                            <input type="text" class="form-control" name="fullname" id="receiverName" readonly required>
                        </div>
                        <div class="mb-3">
                            <label>Địa chỉ</label>
                            <input type="text" class="form-control" name="address" id="receiverAddress" readonly required>
                        </div>
                        <div class="mb-3">
                            <label>Điện thoại</label>
                            <input type="text" class="form-control" name="phone" id="receiverPhone" readonly required>
                        </div>

                        <!-- Hình thức thanh toán -->
                        <div class="mb-3">
                            <label>Hình thức thanh toán</label><br>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethod" value="COD" id="pmCOD" checked>
                                <label class="form-check-label" for="pmCOD">Tiền mặt (COD)</label>
                            </div>
                            <div class="form-check mt-1">
                                <input class="form-check-input" type="radio" name="paymentMethod" value="CARD" id="pmCARD">
                                <label class="form-check-label" for="pmCARD">Chuyển khoản</label>
                            </div>
                        </div>

                        <!-- BOX QR chuyển khoản (ẩn khi chọn COD) -->
                        <div id="qrSection" class="qr-box mb-3" style="display:none;">
                            <div class="d-flex gap-3 align-items-start">
                                <!-- Ảnh QR: đổi đường dẫn theo vị trí ảnh QR của bạn -->
                                <img class="qr-img"
                                     src="${pageContext.request.contextPath}/assets/images/myqr.jpg"
                                     alt="QR chuyển khoản">

                                <div class="flex-grow-1">
                                    <h6 class="mb-3 text-primary">Quét mã để thanh toán</h6>

                                    <div class="info-row">
                                        <label>Số tiền</label>
                                        <div id="amountText"><%= df.format(payable)%> VNĐ</div>
                                        <button class="btn btn-sm btn-outline-secondary copy-btn" type="button"
                                                onclick="copyText('<%= df.format(payable)%> VNĐ')">Copy</button>
                                    </div>

                                    <div class="info-row">
                                        <label>Nội dung</label>
                                        <!-- Nội dung chuyển khoản cập nhật theo tên người nhận của địa chỉ đang chọn -->
                                        <div id="noteText"></div>
                                        <button class="btn btn-sm btn-outline-secondary copy-btn" type="button"
                                                onclick="copyNodeText('noteText')">Copy</button>
                                    </div>

                                    <div class="small text-muted mt-2">
                                        * Vui lòng chuyển đúng <b>số tiền</b> và <b>nội dung</b> để hệ thống đối soát nhanh.
                                    </div>
                                </div>
                            </div>
                        </div>

                        <button type="button" class="btn btn-primary w-100 mt-2" style="font-size: 1.2rem;" onclick="confirmOrder()">
                            Đặt hàng
                        </button>
                    </form>
                </div>

                <!-- Thông tin giỏ hàng -->
                <div class="col-lg-6">
                    <h4 class="section-title mb-4">Giỏ hàng</h4>
                    <div class="total-box">
                        <c:forEach var="item" items="${cartItems}">
                            <div class="d-flex justify-content-between mb-2">
                                <div>${item.productName} x ${item.quantity}</div>
                                <div>${item.price * item.quantity} VNÐ</div>
                            </div>
                        </c:forEach>
                        <hr>
                        <div class="d-flex justify-content-between">
                            <strong>Tổng thành tiền:</strong>
                            <strong style="color: #dc3545; font-size: 1.2rem;"><%= df.format(totalAmount)%> VNĐ</strong>
                        </div>
                        <div class="mt-3">
                            <form method="post" action="${pageContext.request.contextPath}/checkout">
                                <div class="input-group">
                                    <input type="text" class="form-control" name="voucherCode" value="${param.voucherCode}" placeholder="Nhập mã khuyến mãi">
                                    <button class="btn btn-outline-primary" type="submit">Áp dụng</button>
                                </div>
                            </form>

                            <c:if test="${not empty voucherMessage}">
                                <div class="mt-2">
                                    <small style="color: ${discountAmount > 0 ? 'green' : 'red'};">${voucherMessage}</small>
                                </div>
                            </c:if>

                            <c:choose>
                                <c:when test="${discountAmount > 0}">
                                    <strong style="color: #dc3545; font-size: 1.2rem;">
                                        <%= df.format((Double) request.getAttribute("finalAmount"))%> VNĐ
                                    </strong>
                                </c:when>
                                <c:otherwise>
                                    <strong style="color: #dc3545; font-size: 1.2rem;"><%= df.format(totalAmount)%> đ</strong>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/include/footer.jsp" %>

        <!-- Popup lỗi hết hàng -->
        <c:if test="${param.error == 'out_of_stock'}">
            <script>
                Swal.fire({ icon: 'error', title: 'Không đủ hàng',
                        text: 'Một hoặc nhiều sản phẩm đã hết số lượng. Vui lòng kiểm tra lại giỏ hàng.' });
            </script>
        </c:if>

        <script>
            function hasAnyAddress() {
            const select = document.getElementById("addressSelect");
            return select && select.options && select.options.length > 0;
            }

            function goToAddressBook() {
            // chỉ dùng khi chưa có địa chỉ → lưu xong quay lại checkout
            window.location.href =
                    "${pageContext.request.contextPath}/ViewAddress?from=checkout&reason=no_address&return=/checkout";
            }

            function confirmOrder() {
            if (!hasAnyAddress()) {
            Swal.fire({
            icon: 'warning',
                    title: 'Chưa có địa chỉ nhận hàng',
                    text: 'Bạn cần thêm địa chỉ để có thể mua hàng.',
                    showCancelButton: true,
                    confirmButtonText: 'Thêm địa chỉ',
                    cancelButtonText: 'Hủy'
            }).then((r) => { if (r.isConfirmed) goToAddressBook(); });
            return;
            }
            Swal.fire({
            title: 'Bạn có chắc muốn đặt hàng?',
                    text: 'Đơn hàng sẽ được gửi đến địa chỉ bạn đã chọn!',
                    icon: 'warning', showCancelButton: true,
                    confirmButtonColor: '#d33', cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Đặt hàng', cancelButtonText: 'Hủy'
            }).then((r) => { if (r.isConfirmed)
                    document.getElementById("orderForm").submit();
            });
            }

            function updateReceiverFields() {
            const select = document.getElementById("addressSelect");
            const nameEl = document.getElementById("receiverName");
            const phoneEl = document.getElementById("receiverPhone");
            const addrEl = document.getElementById("receiverAddress");
            const hiddenId = document.getElementById("addressIdHidden");
            const noteEl = document.getElementById("noteText");
            if (!hasAnyAddress()) {
            nameEl.value = phoneEl.value = addrEl.value = hiddenId.value = "";
            if (noteEl) noteEl.innerText = "";
            return;
            }
            const opt = select.options[select.selectedIndex];
            nameEl.value = opt.getAttribute("data-name");
            phoneEl.value = opt.getAttribute("data-phone");
            addrEl.value = opt.getAttribute("data-address");
            hiddenId.value = opt.value;
            // Nội dung chuyển khoản theo tên người nhận hiện tại
            if (noteEl) noteEl.innerText = "ORDER-" + nameEl.value;
            }

            // Toggle QR theo paymentMethod
            function toggleQR() {
            const isCard = document.getElementById('pmCARD').checked;
            document.getElementById('qrSection').style.display = isCard ? 'block' : 'none';
            }

            // Copy helpers
            function copyText(text) {
            navigator.clipboard.writeText(text).then(() => {
            Swal.fire({toast:true, icon:'success', title:'Đã copy!', timer:1200, position:'top', showConfirmButton:false});
            });
            }
            function copyNodeText(id) {
            const t = document.getElementById(id)?.innerText || '';
            copyText(t);
            }

            document.getElementById("addressSelect")?.addEventListener("change", updateReceiverFields);
            window.addEventListener("load", () => { updateReceiverFields(); toggleQR(); });
            document.getElementById('pmCOD')?.addEventListener('change', toggleQR);
            document.getElementById('pmCARD')?.addEventListener('change', toggleQR);</script>

        <c:if test="${orderSuccess == true}">
            <script>
                Swal.fire({ icon: 'success', title: 'Đặt hàng thành công!',
                        text: 'Bạn sẽ được chuyển về trang chủ sau 5 giây...', timer: 5000,
                        timerProgressBar: true, showConfirmButton: false });
                setTimeout(() => { window.location.href = 'home.jsp'; }, 5000);
            </script>
        </c:if>

    </body>
</html>
