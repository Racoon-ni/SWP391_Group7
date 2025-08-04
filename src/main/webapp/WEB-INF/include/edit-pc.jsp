<%-- 
    Document   : edit-pc
    Created on : Jun 20, 2025, 12:50:00 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<title>Sửa PC</title>

<div class="container">
    <br/>
    <h1>Sửa PC</h1>

    <c:if test="${not empty errors}">
        <div class="alert alert-danger">
            <ul>
                <c:forEach var="err" items="${errors}">
                    <li>${err}</li>
                    </c:forEach>
            </ul>
        </div>
    </c:if>

    <form method="POST" action="${pageContext.request.contextPath}/manage-pc" enctype="multipart/form-data" class="needs-validation" novalidate id="UCForm">
        <input type="hidden" name="action" value="edit" />        
        <input type="hidden" name="id" value="${pc.id}" />        

        <div class="form-group">
            <label>Tên:</label>
            <input type="text" name="name" 
                   value="${not empty name ? name : pc.name}" 
                   class="form-control" required>
            <div class="invalid-feedback">Vui lòng nhập tên.</div>
        </div>

        <br/>
        <div class="form-group">
            <label>Mô tả:</label>
            <textarea name="description" 
                      class="form-control" required>${not empty description ? description : pc.description}</textarea>
            <div class="invalid-feedback">Vui lòng nhập mô tả.</div>
        </div>

        <br/>
        <div class="form-group">
            <label>Giá (VND):</label>

            <!-- Formatted visible input -->
            <input type="text" id="priceFormatted"
                   value=""
                   class="form-control" required
                   oninput="formatVietnamCurrency(this)" autocomplete="off">

            <!-- Hidden input that actually gets submitted -->
            <input type="hidden" name="price" id="price"
                   value="${not empty price ? price : pc.price}" />

            <div class="invalid-feedback">Giá phải lớn hơn 0.</div>
        </div>

        <br/>
        <div class="form-group">
            <label>Tồn kho:</label>
            <input type="number" name="stock" min="0" 
                   id="stock"
                   value="${not empty stock ? stock : pc.stock}" 
                   class="form-control" required>
            <div class="invalid-feedback">Tồn kho phải lớn hơn hoặc bằng 0.</div>
        </div>

        <br/>
        <div class="form-group">
            <label>Chọn hình ảnh:</label>
            <input type="file" name="image" class="form-control" accept="image/*" onchange="previewImage(event)">

            <input type="hidden" name="oldImageUrl" value="${pc != null ? pc.imageUrl : ''}" />

            <br/>
            <img id="imagePreview"
                 src="${pc != null && pc.imageUrl != null ? pc.imageUrl : '#'}"
                 alt="Ảnh xem trước"
                 style="${pc != null && pc.imageUrl != null ? 'display:block;' : 'display:none;'} max-width: 200px; max-height: 200px; border: 1px solid #ccc; padding: 5px;" />
            <div class="invalid-feedback">Vui lòng chọn ảnh.</div>
        </div>

        <c:forEach var="att" items="${pAttList}">
            <div class="form-group">
                <br/>
                <label>${att.attribute.name}</label>
                <select name="attr_${att.attribute.attributeId}" class="form-control">
                    <c:set var="combinedKey" value="attr_${att.attribute.attributeId}" />
                    <c:set var="currentVal" value="${requestScope[combinedKey]}" />
                    <c:forEach var="val" items="${attrValueOptions[att.attribute.name]}">
                        <option value="${val}" 
                                <c:if test="${val == currentVal}">selected</c:if>>
                            ${val} ${att.attribute.unit}
                        </option>
                    </c:forEach>
                </select>
                <div class="invalid-feedback">Vui lòng chọn thuộc tính.</div>
            </div>
        </c:forEach>

        <br/>
        <div class="form-group">
            <label>Trạng thái:</label>
            <select name="status" class="form-control" id="statusSelect" require>
                <c:set var="selectedStatus" value="${not empty status ? status : pc.status}" />
                <option value="true" ${selectedStatus == 'true' ? 'selected' : ''}>Còn bán</option>
                <option value="false" ${selectedStatus == 'false' ? 'selected' : ''}>Hết hàng</option>
            </select>
            <div class="invalid-feedback">Vui lòng chọn trạng thái.</div>
        </div>

        <br/>
        <a href="#" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#confirmModalClose">
            Hủy sửa
        </a>
        <button type="submit" class="btn btn-success">Sửa PC</button>
    </form>
</div>

<script>
   
</script>


<%String returnPage = "manage-pc";%>
<%@include file="confirm-modal.jsp" %>

