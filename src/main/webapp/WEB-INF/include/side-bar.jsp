<%-- 
    Document   : side-bar
    Created on : Jun 17, 2025, 7:44:28 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>
<%@ page pageEncoding="UTF-8" %>

<style>
    .sidebar {
        max-width: 300px;
        padding: 8px;
        border: 2px solid #333;
        border-radius: 20px;
        height: fit-content;           
        margin-left: 15px;
        background-color: white;
    }
</style>

<!-- Sidebar Filters -->
<div class="col-md-3 sidebar">
    <h6>Khoảng giá</h6>
    <form action="${pageContext.request.contextPath}/filter" method="POST">
    <%@include file="/WEB-INF/include/price-slider.jsp" %>

    <div>
        <%@include file="/WEB-INF/include/drop-down.jsp" %>
    </div>
        <hr>
        <button type="submit" class="btn btn-primary">Lọc</button>
</form>
</div>