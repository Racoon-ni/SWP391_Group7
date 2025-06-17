<%-- 
    Document   : carousel
    Created on : Jun 17, 2025, 7:28:19 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<div id="carousel" class="carousel slide" data-bs-ride="carousel"> 

    <!-- The slideshow/carousel -->
    <div class="carousel-inner">
     
        <div class="carousel-item active">
            <img src="${pageContext.request.contextPath}/assets/images/banner2.webp" 
                                    alt="Banner2" class="d-block" style="width:100%">
        </div>
        <div class="carousel-item">
            <img src="${pageContext.request.contextPath}/assets/images/banner2.webp" 
                                 alt="Banner3" class="d-block" style="width:100%;">
        </div>
    </div>

    <!-- Left and right controls/icons -->
    <button class="carousel-control-prev" type="button" data-bs-target="#carousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#carousel" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
    </button>
</div>
