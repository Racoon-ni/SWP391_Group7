<%-- 
    File: carousel.jsp
    Created on : Jun 17, 2025
    Author     : Huynh Trong Nguyen - CE190356
--%>

<style>
    .carousel-control-prev,
    .carousel-control-next {
        opacity: 0;
        pointer-events: auto;
    }

    .carousel-control-prev-icon,
    .carousel-control-next-icon {
        opacity: 0;
    }
</style>

<div id="carousel" class="carousel slide" data-bs-ride="carousel"> 
    <div class="carousel-inner">
        <div class="carousel-item active">
            <img src="${pageContext.request.contextPath}/assets/images/pc-gaming.png" 
                 alt="Banner1" class="d-block w-100">
        </div>
        <div class="carousel-item">
            <img src="${pageContext.request.contextPath}/assets/images/pc-3.jpg" 
                 alt="Banner2" class="d-block w-100">
        </div>
    </div>

    <button class="carousel-control-prev" type="button" data-bs-target="#carousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#carousel" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
    </button>
</div>
