<%-- 
    Document   : header
    Created on : Jun 17, 2025, 7:59:35 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@include file="WEB-INF/include/header.jsp" %>
<%@ include file="/WEB-INF/include/filter.jsp" %>

<!-- Main Content -->
<div class="container-fluid">
    <div class="row">

        <!-- Main Panel -->
        <div class="">
            <!-- Carousel -->
            <%@include file="/WEB-INF/include/carousel.jsp" %>
            <!-- Block PC -->
            <jsp:include page="/WEB-INF/include/pc-best-seller.jsp">
                <jsp:param name="categoryName" value="PC"/>
                <jsp:param name="productList" value="${pcList}"/>
                <jsp:param name="currentPage" value="${pcCurrentPage}"/>
                <jsp:param name="totalPages" value="${pcTotalPages}"/>
            </jsp:include>

        </div>
    </div>
</div>
<%@include file="/WEB-INF/include/footer.jsp" %>
