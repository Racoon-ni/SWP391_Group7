<%-- 
    Document   : confirm-modal
    Created on : Jul 25, 2025, 9:43:29 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>
<%@ page pageEncoding="UTF-8" %>
<!-- Confirmation Modal -->
<div class="modal fade" id="confirmModal" tabindex="-1" aria-labelledby="confirmModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="margin-bottom: 300px">
            <div class="modal-header">
                <h5 class="modal-title" id="confirmModalLabel">Xác nhận thay đổi</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>

            <div class="modal-body">
                <span id="modalMessage"></span>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" id="cancelStock">Hủy</button>
                <button type="button" class="btn btn-danger" id="confirmStock">Xác nhận</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal for cancel confirmation -->
<div class="modal fade" id="confirmModalClose" tabindex="-1" aria-labelledby="confirmModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="confirmModalLabel">Xác nhận</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>
            <div class="modal-body">
                Bạn có chắc chắn muốn hủy những chỉnh sửa không?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <a href="${pageContext.request.contextPath}/<%= returnPage%>" class="btn btn-danger">Đồng ý</a>
            </div>
        </div>
    </div> 
</div>

<!-- Image preview -->
<script>
    // Bootstrap validation
    (function () {
        'use strict';
        const form = document.getElementById('UCForm');
        form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    })();

    function previewImage(event) {
        const input = event.target;
        const preview = document.getElementById('imagePreview');

        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.src = e.target.result;
                preview.style.display = 'block';
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        const title = document.getElementById("pageTitle").textContent.trim();
        const modalBody = document.querySelector("#confirmModalClose .modal-body");

        if (title.includes("Thêm")) {
            modalBody.textContent = "Bạn có chắc chắn muốn hủy việc thêm này không?";
        } else {
            modalBody.textContent = "Bạn có chắc chắn muốn hủy những chỉnh sửa này không?";
        }
    });

    const statusSelect = document.getElementById('statusSelect');
    const stockInput = document.getElementById('stock');
    let lastStatus = statusSelect.value;

    function showStockStatusModal(statusText, statusValue, onConfirm, onCancel, customMessage) {
        const modalMessage = document.getElementById('modalMessage');
        modalMessage.innerHTML = customMessage;

        const confirmBtn = document.getElementById('confirmStock');
        const cancelBtn = document.getElementById('cancelStock');

        // Remove previous handlers to avoid stacking
        const newConfirm = () => {
            onConfirm();
            bootstrap.Modal.getInstance(document.getElementById('confirmModal')).hide();
            confirmBtn.removeEventListener('click', newConfirm);
            cancelBtn.removeEventListener('click', newCancel);
        };

        const newCancel = () => {
            onCancel();
            bootstrap.Modal.getInstance(document.getElementById('confirmModal')).hide();
            confirmBtn.removeEventListener('click', newConfirm);
            cancelBtn.removeEventListener('click', newCancel);
        };

        confirmBtn.addEventListener('click', newConfirm);
        cancelBtn.addEventListener('click', newCancel);

        // Show modal
        const modal = new bootstrap.Modal(document.getElementById('confirmModal'));
        modal.show();
    }

    statusSelect.addEventListener('change', function () {
        const selectedText = statusSelect.options[statusSelect.selectedIndex].text;
        const selectedValue = statusSelect.value;
        const stockValue = parseInt(stockInput.value);
        console.log("Selected text:", selectedText);
        if (selectedValue === 'false' && stockValue > 0) {
            // Hết hàng: confirm + set stock = 0
            const message = `Bạn có chắc muốn đặt trạng thái là <strong>Hết hàng</strong>?<br />Tồn kho sẽ được đặt về <strong>0</strong>.`;
            showStockStatusModal(selectedText, selectedValue,
                    () => {
                stockInput.value = 0;
                lastStatus = 'false';
            },
                    () => {
                statusSelect.value = lastStatus;
            },
                    message
                    );
        } else if (selectedValue === 'true' && stockValue <= 0) {
            // Còn bán but stock = 0: warn + set stock = 1
            const message = `Bạn đang mở bán nhưng tồn kho hiện là <strong>0</strong>.<br />Tồn kho sẽ được đặt về <strong>1</strong>. Tiếp tục?`;
            showStockStatusModal(selectedText, selectedValue,
                    () => {
                stockInput.value = 1;
                lastStatus = 'true';
            },
                    () => {
                statusSelect.value = lastStatus;
            },
                    message
                    );
        } else {
            // Valid change without needing modal
            lastStatus = selectedValue;
        }
    });

    function formatVietnamCurrency(input) {
        const raw = input.value.replace(/[^\d]/g, '');

        if (!raw) {
            document.getElementById("price").value = '';
            input.value = '';
            return;
        }

        const number = parseInt(raw);
        document.getElementById("price").value = number.toFixed(2); // keep .00 format
        input.value = number.toLocaleString('vi-VN');
    }

    window.addEventListener('DOMContentLoaded', () => {
        const rawValue = document.getElementById("price").value;
        const formattedInput = document.getElementById("priceFormatted");

        if (rawValue) {
            const number = parseFloat(rawValue);
            formattedInput.value = number.toLocaleString('vi-VN');
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
