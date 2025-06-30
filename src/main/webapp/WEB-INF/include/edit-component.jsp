<%-- 
    Document   : edit-component
    Created on : Jun 24, 2025, 8:24:00 PM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<title>Edit Component</title>
<div class="container">
    <h1>Sửa linh kiện</h1>

    <form method="POST" action="${pageContext.request.contextPath}/manage-component" class="needs-validation" novalidate id="editCompForm">
        <input type="hidden" name="action" value="edit" />        
        <input type="hidden" name="id" value="${requestScope.comp.id}" />        

        <div class="form-group">
            <label>Tên:</label>
            <input type="text" name="name" value="${requestScope.comp.name}" class="form-control" required>
            <div class="invalid-feedback">Vui lòng nhập tên.</div>
        </div>

        <br/>
        <div class="form-group">
            <label>Mô tả:</label>
            <textarea name="description"  class="form-control" required>${requestScope.comp.description}</textarea>
            <div class="invalid-feedback">Vui lòng nhập mô tả.</div>
        </div>

        <br/>
        <div class="form-group">
            <label>Giá:</label>
            <input type="number" min="0.01" step="0.01" name="price" value="${requestScope.comp.price}" class="form-control" required>
            <div class="invalid-feedback">Giá phải lớn hơn 0.</div>
        </div>

        <br/>
        <div class="form-group">
            <label>Tồn kho:</label>
            <input type="number" id="stock" name="stock" min="0" value="${requestScope.comp.stock}" class="form-control" required>
            <div class="invalid-feedback">Tồn kho phải lớn hơn hoặc bằng 0.</div>
        </div>

        <br/>
        <div class="form-group">
            <label>Thể loại:</label>
            <select name="cateId" class="form-control" required>
                <c:if test="${not empty cateList}">
                    <c:forEach items="${cateList}" var="cate">
                        <c:if test="${cate.categoryType == 'Component'}">
                            <option value="${cate.categoryId}"
                                    <c:if test="${not empty comp && comp.category.categoryId == cate.categoryId}">selected</c:if>>
                                ${cate.name}
                            </option>
                        </c:if>
                    </c:forEach>
                </c:if>
            </select>   
            <div class="invalid-feedback">Vui lòng chọn thể loại.</div>
        </div>

        <br/>
        <div class="form-group">
            <label>Trạng thái:</label>
            <select name="status" class="form-control" id="statusSelect" required>
                <c:choose>
                    <c:when test="${not empty comp && comp.status == true}">
                        <option value ="true" selected> Còn bán </option>
                        <option value ="false">Hết hàng</option>
                    </c:when>
                    <c:otherwise>
                        <option value ="true"> Còn bán </option>
                        <option value ="false" selected>Hết hàng</option>
                    </c:otherwise>
                </c:choose>
            </select>   
            <div class="invalid-feedback">Vui lòng chọn trạng thái.</div>
        </div>

        <br/>
        <button type="submit" class="btn btn-primary">Cập Nhật</button>
    </form>

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

    <script>
        // Bootstrap validation
        (function () {
            'use strict';
            const form = document.getElementById('editCompForm');
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        })();

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

    </script>

</div>