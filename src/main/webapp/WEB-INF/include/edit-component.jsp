<%-- 
    Document   : edit-component
    Created on : Jun 24, 2025, 8:24:00 PM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<title>Edit PC</title>
<div class="container">
    <h1>Sửa linh kiện</h1>

    <form method="POST" action="${pageContext.request.contextPath}/manage-component">
        <input type="hidden" name="action" value="edit" />        
        <input type="hidden" name="id" value="${requestScope.comp.id}" />        

        <div class="form-group">
            <label>Tên:</label>
            <input type="text" name="name" value="${requestScope.comp.name}" class="form-control" required>
        </div>
        <br/>
        <div class="form-group">
            <label>Mô tả:</label>
            <textarea name="description"  class="form-control" required>${requestScope.comp.description}</textarea>
        </div>

        <br/>
        <div class="form-group">
            <label>Giá:</label>
            <input type="number" step="0.01" name="price" value="${requestScope.comp.price}" class="form-control" required>
        </div>

        <br/>
        <div class="form-group">
            <label>Tồn kho:</label>
            <input type="number" name="stock" value="${requestScope.comp.stock}" class="form-control" required>
        </div>

        <br/>
        <div class="form-group">
            <label>Thể loại:</label>
            <select name="cateId" class="form-control">
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
        </div>

        <br/>
        <div class="form-group">
            <label>Trạng thái:</label>
            <select name="status" class="form-control">
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
        </div>

        <br/>
        <button type="submit" class="btn btn-primary">Cập Nhật</button>
    </form>
</div>