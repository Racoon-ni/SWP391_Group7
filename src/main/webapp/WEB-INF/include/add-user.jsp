<%-- 
    Document   : add-user
    Created on : Jun 24, 2025, 10:30:21 PM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<div class="container">
    <h1>Thêm PC</h1>

    <form method="POST" action="${pageContext.request.contextPath}/manage-pc">
        <input type="hidden" name="action" value="create" />        

        <div class="form-group">
            <label>Tên tài khoản:</label>
            <input type="text" name="name" class="form-control" required>
        </div>
        <br/>
        <div class="form-group">
            <label>Email:</label>
            <textarea name="description" class="form-control" required></textarea>
        </div>
        <br/>
        <div class="form-group">
            <label>Mật :</label>
            <input type="number" step="0.01" name="price" class="form-control" required>
        </div>
        <br/>
        <div class="form-group">
            <label>Tồn kho:</label>
            <input type="number" name="stock" class="form-control" required>
        </div>

        <br/>
        <div class="form-group">
            <label>Thể loại</label>
            <select name="cateId" class="form-control">
                <c:if test="${not empty cateList}">
                    <c:forEach items="${cateList}" var="cate">
                        <c:if test="${cate.categoryType == 'PC'}">
                            <option value="${cate.categoryId}">
                                ${cate.name}
                            </option>
                        </c:if>
                    </c:forEach>
                </c:if>
            </select>   
        </div>

        <br/>
        <button type="submit" class="btn btn-primary">Thêm PC</button>
    </form>
</div>