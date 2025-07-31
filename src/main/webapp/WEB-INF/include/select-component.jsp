<%-- 
    Document   : select-component
    Created on : 22-07-2025, 18:59:28
    Author     : Long
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<div class="container" style="max-width:900px; margin:30px auto">
    <h3>Chọn sản phẩm cho: <span style="color:#1976d2">${type}</span></h3>
    <table class="table table-hover">
        <thead>
            <tr>
                <th>Ảnh</th>
                <th>Tên</th>
                <th>Giá</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="p" items="${list}">
                <tr>
                    <td><img src="${p.imageUrl}" width="60"></td>
                    <td>${p.name}</td>
                    <td>${p.price} đ</td>
                    <td>
                        <form action="BuildPC" method="post" style="display:inline">
                            <input type="hidden" name="type" value="${type}">
                            <input type="hidden" name="productId" value="${p.productId}">
                            <button type="submit" class="btn btn-success btn-sm">Chọn</button>
                        </form>
                        <a href="ViewComponentDetail?productId=${p.productId}" class="btn btn-outline-info btn-sm ms-1">Xem chi tiết</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <a href="BuildPC" class="btn btn-secondary">Quay lại Build PC</a>
</div>
<%@ include file="/WEB-INF/include/footer.jsp" %>
