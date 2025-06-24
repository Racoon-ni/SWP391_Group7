<%@ page pageEncoding="UTF-8" %>

<title>Quản lý Voucher</title>

<style>
    /* Cải thiện chung cho toàn bộ trang */
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f6f9;
        margin: 0;
        padding: 0;
    }

    /* Container chính */
    .container {
        background-color: white;
        border-radius: 10px;
        padding: 30px;
        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        margin-top: 80px;  /* Đảm bảo cách đều với sidebar */
        max-width: 1200px;
        margin-left: auto;
        margin-right: auto;
    }

    /* Tiêu đề trang */
    h2 {
        color: #333;
        text-align: center;
        font-size: 28px;
        margin-bottom: 20px;
    }

    /* Bảng hiển thị voucher */
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }

    table th, table td {
        padding: 15px 20px;
        text-align: center;
        border: 1px solid #ddd;
        font-size: 16px;
    }

    table th {
        background-color: #007bff;
        color: white;
        font-weight: bold;
    }

    table tr:hover {
        background-color: #f1f1f1;
    }

    button.btn {
        padding: 10px;
        background-color: #28a745;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
        transition: background-color 0.3s ease;
    }

    button.btn:hover {
        background-color: #218838;
    }

    /* Modal chỉnh sửa và thêm voucher */
    .modal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }

    .modal-content {
        background-color: white;
        padding: 30px;
        border-radius: 10px;
        width: 600px;
        max-width: 90%;
        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.2);
    }

    .modal-content h3 {
        text-align: center;
        font-size: 24px;
        color: #333;
        margin-bottom: 20px;
    }

    .form-field {
        margin-bottom: 20px;
    }

    .form-field label {
        font-weight: bold;
        color: #333;
        display: block;
        margin-bottom: 5px;
        font-size: 16px;
    }

    .form-field input {
        width: 100%;
        padding: 12px;
        border-radius: 5px;
        border: 1px solid #ccc;
        background-color: #f9f9f9;
        font-size: 14px;
        color: #555;
        margin-bottom: 10px;
    }

    .form-field input[type="number"] {
        -moz-appearance: textfield;
    }

    /* Nút Lưu và Đóng trong Modal */
    .modal .btn {
        width: 48%;
        margin-right: 4%;
        background-color: #007bff;
    }

    .modal .close-btn {
        background-color: #dc3545;
    }

    .modal .btn, .modal .close-btn {
        padding: 12px;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
    }

    .modal .btn:hover {
        background-color: #0056b3;
    }

    .modal .close-btn:hover {
        background-color: #c82333;
    }

    /* Nút "Thêm Voucher" */
    #addVoucherBtn {
        padding: 12px 20px;
        background-color: #28a745;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
        margin-top: 20px;
        margin-bottom: 20px;
    }

    #addVoucherBtn:hover {
        background-color: #218838;
    }

    /* Thông báo thành công */
    #successMessage {
        color: green;
        text-align: center;
        font-weight: bold;
        margin-top: 10px;
    }

    /* Nút Quay lại Dashboard */
    .back-btn {
        padding: 12px 20px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
        margin-top: 20px;
    }

    .back-btn:hover {
        background-color: #0056b3;
    }
</style>

<!-- Main Content -->
<div class="container">
    <h2>Quản lý Voucher</h2>

    <!-- Button to Add Voucher -->
    <button class="btn" id="addVoucherBtn">Thêm Voucher</button>

    <!-- List of Vouchers -->
    <table id="voucherTable" border="1" cellpadding="10">
        <thead>
            <tr>
                <th>Mã Voucher</th>
                <th>Giảm giá (%)</th>
                <th>Giá trị đơn hàng tối thiểu</th>
                <th>Ngày hết hạn</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <!-- Voucher List Populated from Database -->
            <c:forEach var="voucher" items="${voucherList}">
                <tr>
                    <td>${voucher.code}</td>
                    <td>${voucher.discountPercent}</td>
                    <td>${voucher.minOrderValue}</td>
                    <td>${voucher.expiredAt}</td>
                    <td>
                        <button class="btn" onclick="openEditModal(${voucher.voucherId})">Chỉnh sửa</button>
                        <button class="btn" onclick="deleteVoucher(${voucher.voucherId})">Xóa</button>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- Modal for Adding/Editing Voucher -->
    <div class="modal" id="voucherModal">
        <div class="modal-content">
            <h3 id="modalTitle">Thêm Voucher</h3>
            <form id="voucherForm">
                <input type="hidden" id="voucherId">
                <div class="form-field">
                    <label>Mã Voucher</label>
                    <input type="text" id="voucherCode" name="voucherCode" required />
                </div>
                <div class="form-field">
                    <label>Giảm giá (%)</label>
                    <input type="number" id="discountPercent" name="discountPercent" required />
                </div>
                <div class="form-field">
                    <label>Giá trị đơn hàng tối thiểu</label>
                    <input type="number" id="minOrderValue" name="minOrderValue" required />
                </div>
                <div class="form-field">
                    <label>Ngày hết hạn</label>
                    <input type="date" id="expiredAt" name="expiredAt" required />
                </div>
                <button type="submit" class="btn">Lưu</button>
                <button type="button" class="close-btn" id="closeModalBtn">Đóng</button>
            </form>
        </div>
    </div>

    <!-- Quay lại Dashboard Button -->
    <a href="dash-board.jsp" class="back-btn">Quay lại trang chủ</a>
</div>

<script>
    // Hiển thị modal khi nhấn "Thêm Voucher"
    document.getElementById('addVoucherBtn').onclick = function() {
        clearForm();
        document.getElementById('modalTitle').textContent = 'Thêm Voucher';
        document.getElementById('voucherModal').style.display = 'flex';
    };

    // Đóng modal
    document.getElementById('closeModalBtn').onclick = function() {
        document.getElementById('voucherModal').style.display = 'none';
    };

    // Hiển thị modal khi nhấn "Chỉnh sửa Voucher"
    function openEditModal(voucherId) {
        // Dữ liệu voucher ví dụ (cần phải thay thế với dữ liệu thực tế từ server)
        document.getElementById('voucherId').value = voucherId;
        document.getElementById('voucherCode').value = 'EXAMPLE123';
        document.getElementById('discountPercent').value = 20;
        document.getElementById('minOrderValue').value = 100;
        document.getElementById('expiredAt').value = '2025-12-31';
        document.getElementById('modalTitle').textContent = 'Chỉnh sửa Voucher';
        document.getElementById('voucherModal').style.display = 'flex';
    }

    // Xóa voucher (cần thêm logic xóa thực tế với AJAX)
    function deleteVoucher(voucherId) {
        if (confirm('Bạn có chắc chắn muốn xóa voucher này?')) {
            // Gọi API hoặc gửi yêu cầu xóa voucher (dùng AJAX hoặc redirect)
            alert('Voucher ' + voucherId + ' đã bị xóa!');
        }
    }

    // Làm sạch form
    function clearForm() {
        document.getElementById('voucherForm').reset();
        document.getElementById('voucherId').value = '';
    }

    // Gửi dữ liệu (Thêm hoặc Sửa)
    document.getElementById('voucherForm').onsubmit = function(event) {
        event.preventDefault();

        const voucherId = document.getElementById('voucherId').value;
        const voucherCode = document.getElementById('voucherCode').value;
        const discountPercent = document.getElementById('discountPercent').value;
        const minOrderValue = document.getElementById('minOrderValue').value;
        const expiredAt = document.getElementById('expiredAt').value;

        // Gửi dữ liệu lên server hoặc cập nhật cơ sở dữ liệu (sử dụng AJAX hoặc POST)
        console.log('Voucher Data:', { voucherId, voucherCode, discountPercent, minOrderValue, expiredAt });

        document.getElementById('voucherModal').style.display = 'none';
        alert('Cập nhật thành công!');
    };
</script>

<%@ include file="../include/footer.jsp" %>
