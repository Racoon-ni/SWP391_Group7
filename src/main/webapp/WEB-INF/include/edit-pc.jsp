<%-- 
    Document   : edit-pc
    Created on : Jun 20, 2025, 12:50:00 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<title>Edit PC</title>
<div class="container">
    <h1>Edit PC</h1>

    <form method="POST" action="${pageContext.request.contextPath}/manage-pc">
        <input type="hidden" name="action" value="edit" />        
        <input type="hidden" name="id" value="${requestScope.pc.id}" />        

        <div class="form-group">
            <label>Name:</label>
            <input type="text" name="name" value="${requestScope.pc.name}" class="form-control" required>
        </div>
        <br/>
        <div class="form-group">
            <label>Description:</label>
            <textarea name="description"  class="form-control" required>${requestScope.pc.description}</textarea>
        </div>

        <br/>
        <div class="form-group">
            <label>Price:</label>
            <input type="number" step="0.01" name="price" value="${requestScope.pc.price}" class="form-control" required>
        </div>

        <br/>
        <div class="form-group">
            <label>Stock:</label>
            <input type="number" name="stock" value="${requestScope.pc.stock}" class="form-control" required>
        </div>

        <br/>
        <div class="form-group">
            <label>Category name</label>
            <select name="cateId" class="form-control">
                <c:if test="${not empty cateList}">
                    <c:forEach items="${cateList}" var="cate">
                        <c:if test="${cate.categoryType == 'PC'}">
                            <option value="${cate.categoryId}"
                                    <c:if test="${not empty pc && pc.category.categoryId == cate.categoryId}">selected</c:if>>
                                ${cate.name}
                            </option>
                        </c:if>
                    </c:forEach>
                </c:if>
            </select>   
        </div>

        <br/>
        <div class="form-group">
            <label>Status</label>
            <select name="status" class="form-control">
                <option value ="true" <c:if test="${not empty pc && pc.status == true}">selected</c:if>>
                    Còn bán
                </option>
                <option value ="false" <c:if test="${not empty pc && pc.status == false}">selected</c:if>>
                    Hết hàng
                </option>
            </select>   
        </div>

        <br/>
        <button type="submit" class="btn btn-primary">Cập Nhật</button>
    </form>
</div>