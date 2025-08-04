<%-- 
    Document   : add-component
    Created on : Jun 24, 2025, 7:15:16 PM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
    select.form-select {
        font-size: 14px;
    }
</style>

<div class="container">
    <h1 id="pageTitle">Thêm Linh Kiện</h1>

    <!-- FIRST FORM: Category selection -->
    <form method="GET" action="${pageContext.request.contextPath}/manage-component">
        <input type="hidden" name="view" value="add" />  
        <br/>
        <div class="form-group">
            <label>Thể Loại:</label>
            <select name="cateId" class="form-select" onchange="this.form.submit()">
                <option value="">-- Chọn thể loại --</option>
                <c:if test="${not empty cateList}">
                    <c:forEach items="${cateList}" var="cate">
                        <c:if test="${cate.categoryType == 'Component'}">
                            <option value="${cate.categoryId}" 
                                    <c:if test="${param.cateId == cate.categoryId}">selected</c:if>>
                                ${cate.name}
                            </option>
                        </c:if>
                    </c:forEach>
                </c:if>
            </select>   
        </div>
    </form>

    <c:if test="${not empty param.cateId}">
        <form method="POST" action="${pageContext.request.contextPath}/manage-component" enctype="multipart/form-data" class="needs-validation" novalidate id="UCForm">
            <input type="hidden" name="action" value="create" />
            <input type="hidden" name="cateId" value="${param.cateId}" />

            <br/>
            <div class="form-group">
                <label>Tên:</label>
                <input type="text" name="name" class="form-control" required>
                <div class="invalid-feedback">Vui lòng nhập tên.</div>
            </div>

            <br/>
            <div class="form-group">
                <label>Mô tả:</label>
                <textarea name="description" class="form-control" required></textarea>
                <div class="invalid-feedback">Vui lòng nhập mô tả.</div>
            </div>

            <br/>
            <div class="form-group">
                <label>Giá (VND):</label>

                <!-- Formatted visible input -->
                <input type="text" id="priceFormatted"
                       class="form-control" required
                       oninput="formatVietnamCurrency(this)" autocomplete="off">

                <!-- Hidden input to hold raw numeric value -->
                <input type="hidden" name="price" id="price"
                       value="${price != null ? price : ''}" />

                <div class="invalid-feedback">Giá phải lớn hơn 0.</div>
            </div>

            <br/>
            <div class="form-group">
                <label>Tồn kho:</label>
                <input type="number" name="stock" class="form-control" required>
                <div class="invalid-feedback">Tồn kho phải lớn hơn hoặc bằng 0.</div>
            </div>

            <br/>
            <div class="form-group">
                <label>Chọn hình ảnh:</label>
                <input type="file" name="image" class="form-control" accept="image/*"  onchange="previewImage(event)" required>
                <br/>
                <img id="imagePreview" src="#" alt="Ảnh xem trước" 
                     style="display:none; max-width: 200px; max-height: 200px; border: 1px solid #ccc; padding: 5px;" />
                <div class="invalid-feedback">Vui lòng chọn ảnh.</div>
            </div>

            <c:forEach var="att" items="${pAttList}">
                <div class="form-group">
                    <br/>
                    <label>${att.attribute.name}</label>
                    <select name="attr_${att.attribute.id}" class="form-control">
                        <c:forEach var="val" items="${attrValueOptions[att.attribute.name]}">
                            <option value="${val}">${val} ${att.attribute.unit}</option>
                        </c:forEach>
                    </select>
                    <div class="invalid-feedback">Vui lòng chọn thuộc tính.</div>
                </div>
            </c:forEach>

            <br/>
            <a href="#" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#confirmModalClose">
                Hủy thêm
            </a>
            <button type="submit" class="btn btn-primary">Thêm Linh Kiện</button>
        </form>
    </c:if>
</div>
<%String returnPage = "manage-component";%>
<%@include file="confirm-modal.jsp" %>