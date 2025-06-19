<%-- 
    Document   : carousel
    Created on : Jun 17, 2025, 7:28:19 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>
<style>
    .carousel-control-prev,
    .carousel-control-next {
        opacity: 0;
        pointer-events: auto; /* ensure it's still clickable */
    }

    .carousel-control-prev-icon,
    .carousel-control-next-icon {
        opacity: 0;
    }

</style>
<div id="carousel" class="carousel slide" data-bs-ride="carousel"> 

    <!-- The slideshow/carousel -->
    <div class="carousel-inner">

        <div class="carousel-item active">
            <img src="${pageContext.request.contextPath}/assets/images/pc-gaming.png" 
                 alt="Banner2" class="d-block" style="width:100%">
        </div>
        <div class="carousel-item">
            <img src="${pageContext.request.contextPath}/assets/images/pc-3.jpg" 
                 alt="Banner3" class="d-block" style="width: 97.6%;">
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
