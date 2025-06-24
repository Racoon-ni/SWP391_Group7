<%-- 
    Document   : header
    Created on : Jun 17, 2025, 7:59:35 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@include file="WEB-INF/include/header.jsp" %>
<!-- Main Content -->
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <%@include file="/WEB-INF/include/side-bar.jsp" %>

        <!-- Main Panel -->
        <div class="col-md-9 mt-5">
            <!-- Carousel -->
            <%@include file="/WEB-INF/include/carousel.jsp" %>

            <!-- PC Best Seller -->
            <%@include file="/WEB-INF/include/pc-best-seller.jsp" %>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/include/footer.jsp" %>
