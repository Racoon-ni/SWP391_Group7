<%@ include file="/WEB-INF/include/admin-side-bar.jsp" %>
<%@page import="model.AdminStaffVoucher"%>
<%@page import="java.util.ArrayList"%>
<%@ page pageEncoding="UTF-8" %>

<title>Quản lý Voucher</title>

<!-- Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Font Awesome Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>
    /* Custom CSS với thiết kế hiện đại */
    :root {
        --primary-color: #4f46e5;
        --primary-hover: #4338ca;
        --success-color: #10b981;
        --success-hover: #059669;
        --danger-color: #ef4444;
        --danger-hover: #dc2626;
        --warning-color: #f59e0b;
        --warning-hover: #d97706;
        --info-color: #3b82f6;
        --info-hover: #2563eb;
        --dark-color: #1f2937;
        --light-color: #f9fafb;
        --border-color: #e5e7eb;
        --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
        --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
        --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
        --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
    }

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        background: linear-gradient(#f9faff);
        min-height: 100vh;
        color: var(--dark-color);
        line-height: 1.6;
    }

    /* Container chính */
    .container {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(20px);
        border-radius: 24px;
        padding: 40px;
        box-shadow: var(--shadow-xl);
        margin-top: 100px;
        max-width: 1400px;
        margin-left: auto;
        margin-right: auto;
        border: 1px solid rgba(255, 255, 255, 0.2);
    }

    /* Tiêu đề trang */
    .page-header {
        text-align: center;
        margin-bottom: 40px;
        position: relative;
    }

    .page-header h2 {
        font-size: 2.5rem;
        font-weight: 700;
        background: linear-gradient(135deg, var(--primary-color), var(--info-color));
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        margin-bottom: 10px;
    }

    .page-header .subtitle {
        color: #6b7280;
        font-size: 1.1rem;
        font-weight: 400;
    }

    /* Thông báo với animation và timeout */
    .message {
        text-align: center;
        font-weight: 600;
        margin: 25px 0;
        padding: 20px 25px;
        border-radius: 16px;
        font-size: 1rem;
        box-shadow: var(--shadow-lg);
        animation: slideInDown 0.6s ease-out;
        position: relative;
        overflow: hidden;
        border: none;
        backdrop-filter: blur(10px);
    }

    .message::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 4px;
        background: linear-gradient(90deg, transparent, currentColor, transparent);
        animation: shimmer 2s infinite;
    }

    .success-message {
        color: var(--success-color);
        background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(5, 150, 105, 0.05));
        border: 1px solid rgba(16, 185, 129, 0.2);
    }

    .error-message {
        color: var(--danger-color);
        background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(220, 38, 38, 0.05));
        border: 1px solid rgba(239, 68, 68, 0.2);
    }

    .warning-message {
        color: var(--warning-color);
        background: linear-gradient(135deg, rgba(245, 158, 11, 0.1), rgba(217, 119, 6, 0.05));
        border: 1px solid rgba(245, 158, 11, 0.2);
    }

    .info-message {
        color: var(--info-color);
        background: linear-gradient(135deg, rgba(59, 130, 246, 0.1), rgba(37, 99, 235, 0.05));
        border: 1px solid rgba(59, 130, 246, 0.2);
    }

    /* Animation cho thông báo */
    @keyframes slideInDown {
        from {
            opacity: 0;
            transform: translateY(-30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    @keyframes slideOutUp {
        from {
            opacity: 1;
            transform: translateY(0);
        }
        to {
            opacity: 0;
            transform: translateY(-30px);
        }
    }

    @keyframes shimmer {
        0% { transform: translateX(-100%); }
        100% { transform: translateX(100%); }
    }

    /* Nút thêm voucher */
    .btn-add-voucher {
        background: linear-gradient(135deg, var(--success-color), var(--success-hover));
        color: white;
        border: none;
        padding: 15px 30px;
        border-radius: 12px;
        font-size: 1.1rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: var(--shadow-md);
        margin: 20px 0 30px 0;
        display: inline-flex;
        align-items: center;
        gap: 10px;
    }

    .btn-add-voucher:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-lg);
        background: linear-gradient(135deg, var(--success-hover), var(--success-color));
    }

    /* Bảng hiển thị voucher */
    .table-container {
        background: white;
        border-radius: 16px;
        overflow: hidden;
        box-shadow: var(--shadow-lg);
        border: 1px solid var(--border-color);
    }

    .table {
        margin: 0;
        border: none;
    }

    .table thead th {
        background: linear-gradient(135deg, var(--primary-color), var(--info-color));
        color: white;
        font-weight: 600;
        padding: 20px;
        border: none;
        font-size: 0.95rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .table tbody td {
        padding: 18px 20px;
        border: none;
        border-bottom: 1px solid var(--border-color);
        vertical-align: middle;
        font-size: 0.95rem;
    }

    .table tbody tr:hover {
        background: linear-gradient(135deg, rgba(79, 70, 229, 0.05), rgba(59, 130, 246, 0.05));
        transform: scale(1.01);
        transition: all 0.2s ease;
    }

    .table tbody tr:last-child td {
        border-bottom: none;
    }

    /* Nút trong bảng */
    .btn-action {
        padding: 8px 16px;
        border: none;
        border-radius: 8px;
        font-size: 0.85rem;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
        margin: 0 5px;
        display: inline-flex;
        align-items: center;
        gap: 6px;
    }

    .btn-edit {
        background: linear-gradient(135deg, var(--info-color), var(--info-hover));
        color: white;
    }

    .btn-edit:hover {
        transform: translateY(-1px);
        box-shadow: var(--shadow-md);
    }

    .btn-delete {
        background: linear-gradient(135deg, var(--danger-color), var(--danger-hover));
        color: white;
    }

    .btn-delete:hover {
        transform: translateY(-1px);
        box-shadow: var(--shadow-md);
    }

    /* Modal */
    .modal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.6);
        backdrop-filter: blur(10px);
        justify-content: center;
        align-items: center;
        z-index: 1050;
        animation: fadeIn 0.3s ease-out;
    }

    .modal.show {
        display: flex;
    }

    .modal-content {
        background: white;
        padding: 40px;
        border-radius: 20px;
        width: 600px;
        max-width: 90%;
        box-shadow: var(--shadow-xl);
        border: 1px solid var(--border-color);
        animation: slideInUp 0.4s ease-out;
        position: relative;
    }

    .modal-header {
        text-align: center;
        margin-bottom: 30px;
    }

    .modal-header h3 {
        font-size: 1.8rem;
        font-weight: 700;
        color: var(--dark-color);
        margin: 0;
    }

    .form-field {
        margin-bottom: 25px;
    }

    .form-field label {
        font-weight: 600;
        color: var(--dark-color);
        display: block;
        margin-bottom: 8px;
        font-size: 0.95rem;
    }

    .form-field input {
        width: 100%;
        padding: 15px 18px;
        border-radius: 12px;
        border: 2px solid var(--border-color);
        background: var(--light-color);
        font-size: 1rem;
        color: var(--dark-color);
        transition: all 0.3s ease;
    }

    .form-field input:focus {
        outline: none;
        border-color: var(--primary-color);
        background: white;
        box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
    }

    .form-field input[type="number"] {
        -moz-appearance: textfield;
    }

    .form-field input[type="number"]::-webkit-outer-spin-button,
    .form-field input[type="number"]::-webkit-inner-spin-button {
        -webkit-appearance: none;
        margin: 0;
    }

    /* Nút trong modal */
    .modal-actions {
        display: flex;
        gap: 15px;
        margin-top: 30px;
    }

    .btn-save {
        flex: 1;
        background: linear-gradient(135deg, var(--success-color), var(--success-hover));
        color: white;
        border: none;
        padding: 15px;
        border-radius: 12px;
        font-size: 1rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .btn-save:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
    }

    .btn-close {
        flex: 1;
        background: linear-gradient(135deg, var(--danger-color), var(--danger-hover));
        color: white;
        border: none;
        padding: 15px;
        border-radius: 12px;
        font-size: 1rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .btn-close:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
    }

    /* Responsive */
    @media (max-width: 768px) {
        .container {
            margin: 80px 15px 20px 15px;
            padding: 25px;
        }

        .page-header h2 {
            font-size: 2rem;
        }

        .table-responsive {
            overflow-x: auto;
        }

        .modal-content {
            width: 95%;
            padding: 25px;
        }

        .modal-actions {
            flex-direction: column;
        }
    }

    /* Loading spinner */
    .spinner {
        display: inline-block;
        width: 20px;
        height: 20px;
        border: 3px solid rgba(255, 255, 255, 0.3);
        border-radius: 50%;
        border-top-color: white;
        animation: spin 1s ease-in-out infinite;
    }

    @keyframes spin {
        to { transform: rotate(360deg); }
    }

    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    @keyframes slideInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
</style>

<!-- Main Content -->
<div class="container">
    <div class="page-header">
        <h2><i class="fas fa-ticket-alt me-3"></i>Quản lý Voucher</h2>
        <p class="subtitle">Quản lý và cấu hình các voucher khuyến mãi</p>
    </div>

 

    <!-- Button to Add Voucher -->
    <button class="btn-add-voucher" id="addVoucherBtn">
        <i class="fas fa-plus"></i>
        Thêm Voucher Mới
    </button>



    <!-- List of Vouchers -->
    <div class="table-container">
        <div class="table-responsive">
            <table class="table" id="voucherTable">
                <thead>
                    <tr>
                        <th><i class="fas fa-tag me-2"></i>Mã Voucher</th>
                        <th><i class="fas fa-percentage me-2"></i>Giảm giá</th>
                        <th><i class="fas fa-dollar-sign me-2"></i>Giá trị tối thiểu</th>
                        <th><i class="fas fa-calendar-plus me-2"></i>Ngày bắt đầu</th>
                        <th><i class="fas fa-calendar-times me-2"></i>Ngày hết hạn</th>
                        <th><i class="fas fa-boxes me-2"></i>Số lượng</th>
                        <th><i class="fas fa-cogs me-2"></i>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Voucher List Populated from Database -->
                    <%
                        ArrayList<AdminStaffVoucher> voucherList = (ArrayList<AdminStaffVoucher>) request.getAttribute("voucherList");
                        for (AdminStaffVoucher voucher : voucherList) {
                    %>
                    <tr>
                        <td><strong><%= voucher.getCode()%></strong></td>
                        <td><span class="badge bg-success"><%= voucher.getDiscountPercent()%>%</span></td>
                        <td><%= String.format("%,.0f", voucher.getMinOrderValue())%> VNĐ</td>
                        <td><%= voucher.getStartDate() != null ? voucher.getStartDate() : "<span class='text-muted'>N/A</span>" %></td>
                        <td><%= voucher.getExpiredAt()%></td>
                        <td><span class="badge bg-info"><%= voucher.getQuantity() %></span></td>
                        <td>
                            <button class="btn-action btn-edit"
                                    onclick="openEditModal(this)"
                                    data-id="<%= voucher.getVoucherId()%>"
                                    data-code="<%= voucher.getCode()%>"
                                    data-discount="<%= voucher.getDiscountPercent()%>"
                                    data-minorder="<%= voucher.getMinOrderValue()%>"
                                    data-startdate="<%= voucher.getStartDate() != null ? voucher.getStartDate() : "" %>"
                                    data-expired="<%= voucher.getExpiredAt()%>"
                                    data-quantity="<%= voucher.getQuantity()%>">
                                <i class="fas fa-edit"></i>
                                Sửa
                            </button>

                            <button class="btn-action btn-delete" onclick="deleteVoucher(<%= voucher.getVoucherId()%>)">
                                <i class="fas fa-trash"></i>
                                Xóa
                            </button>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Modal for Adding/Editing Voucher -->
    <div class="modal" id="voucherModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle"><i class="fas fa-plus-circle me-2"></i>Thêm Voucher Mới</h3>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/manage-vouchers" id="voucherForm" onsubmit="return validateForm()">
                <input type="hidden" id="voucherId" name="voucherId">
                <input type="hidden" name="action" value="add">
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-field">
                            <label><i class="fas fa-tag me-2"></i>Mã Voucher</label>
                            <input type="text" id="voucherCode" name="voucherCode" required placeholder="Nhập mã voucher..." />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-field">
                            <label><i class="fas fa-percentage me-2"></i>Giảm giá (%)</label>
                            <input type="number" id="discountPercent" name="discountPercent" min="1" max="100" required placeholder="1-100" />
                        </div>
                    </div>
                </div>

                <div class="form-field">
                    <label><i class="fas fa-dollar-sign me-2"></i>Giá trị đơn hàng tối thiểu</label>
                    <input type="number" id="minOrderValue" name="minOrderValue" min="0" step="1000" required placeholder="Nhập giá trị tối thiểu..." />
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-field">
                            <label><i class="fas fa-calendar-plus me-2"></i>Ngày bắt đầu</label>
                            <input type="date" id="startDate" name="startDate" required />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-field">
                            <label><i class="fas fa-calendar-times me-2"></i>Ngày hết hạn</label>
                            <input type="date" id="expiredAt" name="expiredAt" required />
                        </div>
                    </div>
                </div>

                <div class="form-field">
                    <label><i class="fas fa-boxes me-2"></i>Số lượng</label>
                    <input type="number" id="quantity" name="quantity" min="1" required placeholder="Nhập số lượng..." />
                </div>

                <div class="modal-actions">
                    <button type="submit" class="btn-save">
                        <i class="fas fa-save me-2"></i>Lưu
                    </button>
                    <button type="button" class="btn-close" id="closeModalBtn">
                        <i class="fas fa-times me-2"></i>Đóng
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Hiển thị thông báo với timeout
    function showMessage(message, type = 'success', timeout = 5000) {
        const messageContainer = document.getElementById('messageContainer');
        
        // Xóa thông báo cũ nếu có
        messageContainer.innerHTML = '';
        
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${type}-message`;
        let iconClass = 'check-circle';
        if (type === 'error') iconClass = 'exclamation-circle';
        else if (type === 'warning') iconClass = 'exclamation-triangle';
        else if (type === 'info') iconClass = 'info-circle';
        
        messageDiv.innerHTML = `
            <i class="fas fa-${iconClass} me-2"></i>
            ${message}
        `;
        
        messageContainer.appendChild(messageDiv);
        
        // Tự động ẩn sau timeout
        setTimeout(() => {
            messageDiv.style.animation = 'slideOutUp 0.6s ease-out';
            setTimeout(() => {
                if (messageDiv.parentNode) {
                    messageDiv.parentNode.removeChild(messageDiv);
                }
            }, 600);
        }, timeout);
    }

    // Kiểm tra thông báo từ URL parameters
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        
        if (urlParams.get('success')) {
            const message = urlParams.get('message') || 'Thao tác thực hiện thành công!';
            showMessage(message, 'success', 4000);
        }
        
        if (urlParams.get('error')) {
            let message = urlParams.get('message');
            if (!message) {
                const errorType = urlParams.get('error');
                switch(errorType) {
                    case 'invalid_date_range':
                        message = 'Lỗi: Ngày bắt đầu không thể lớn hơn ngày hết hạn!';
                        break;
                    case 'invalid_input':
                        message = 'Lỗi: Thông tin nhập vào không hợp lệ!';
                        break;
                    default:
                        message = 'Có lỗi xảy ra, vui lòng thử lại!';
                }
            }
            showMessage(message, 'error', 6000);
        }
    };

    // Hiển thị modal khi nhấn "Thêm Voucher"
    document.getElementById('addVoucherBtn').onclick = function () {
        clearForm();
        document.getElementById('modalTitle').innerHTML = '<i class="fas fa-plus-circle me-2"></i>Thêm Voucher Mới';
        document.getElementById('voucherModal').classList.add('show');
    };

    // Đóng modal
    document.getElementById('closeModalBtn').onclick = function () {
        document.getElementById('voucherModal').classList.remove('show');
    };

    // Đóng modal khi click bên ngoài
    document.getElementById('voucherModal').onclick = function(e) {
        if (e.target === this) {
            this.classList.remove('show');
        }
    };

    // Hiển thị modal khi nhấn "Chỉnh sửa Voucher"
    function openEditModal(button) {
        const id = button.getAttribute('data-id');
        const code = button.getAttribute('data-code');
        const discount = button.getAttribute('data-discount');
        const minOrder = button.getAttribute('data-minorder');
        const startDate = button.getAttribute('data-startdate');
        const expiredAt = button.getAttribute('data-expired');
        const quantity = button.getAttribute('data-quantity');

        document.getElementById('voucherId').value = id;
        document.getElementById('voucherCode').value = code;
        document.getElementById('discountPercent').value = discount;
        document.getElementById('minOrderValue').value = minOrder;
        document.getElementById('startDate').value = startDate;
        document.getElementById('expiredAt').value = expiredAt;
        document.getElementById('quantity').value = quantity;

        document.getElementById('modalTitle').innerHTML = '<i class="fas fa-edit me-2"></i>Chỉnh sửa Voucher';
        document.querySelector('#voucherForm input[name="action"]').value = 'edit';
        document.getElementById('voucherModal').classList.add('show');
    }

    // Xóa voucher
    function deleteVoucher(voucherId) {
        if (confirm('🗑️ Bạn có chắc chắn muốn xóa voucher này? Hành động này không thể hoàn tác.')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/manage-vouchers';

            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'delete';

            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'voucherId';
            idInput.value = voucherId;

            form.appendChild(actionInput);
            form.appendChild(idInput);
            document.body.appendChild(form);
            form.submit();
        }
    }

    // Validation form trước khi submit
    function validateForm() {
        const startDate = document.getElementById('startDate').value;
        const expiredAt = document.getElementById('expiredAt').value;
        const discountPercent = document.getElementById('discountPercent').value;
        const minOrderValue = document.getElementById('minOrderValue').value;
        const quantity = document.getElementById('quantity').value;

        // Kiểm tra ngày bắt đầu không thể lớn hơn ngày hết hạn
        if (startDate && expiredAt && startDate > expiredAt) {
            showMessage('⚠️ Lỗi: Ngày bắt đầu không thể lớn hơn ngày hết hạn!', 'error', 5000);
            return false;
        }

        // Kiểm tra các giá trị số
        if (discountPercent <= 0 || discountPercent > 100) {
            showMessage('⚠️ Lỗi: Phần trăm giảm giá phải từ 1-100%!', 'error', 5000);
            return false;
        }

        if (minOrderValue <= 0) {
            showMessage('⚠️ Lỗi: Giá trị đơn hàng tối thiểu phải lớn hơn 0!', 'error', 5000);
            return false;
        }

        if (quantity <= 0) {
            showMessage('⚠️ Lỗi: Số lượng phải lớn hơn 0!', 'error', 5000);
            return false;
        }

        return true;
    }

    // Làm sạch form
    function clearForm() {
        document.getElementById('voucherForm').reset();
        document.getElementById('voucherId').value = '';
    }

    // Hàm để test thông báo
    function testMessage() {
        showMessage('Đây là thông báo kiểm tra!', 'info', 8000);
    }
</script>


