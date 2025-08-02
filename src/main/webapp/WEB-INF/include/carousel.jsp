<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="carousel" class="carousel slide" data-bs-ride="carousel"> 
    <div class="carousel-inner">
        <c:choose>
            <c:when test="${not empty banners}">
                <c:forEach var="banner" items="${banners}" varStatus="status">
                    <div class="carousel-item ${status.index == 0 ? 'active' : ''}">
                        <img src="${pageContext.request.contextPath}${banner.imageUrl}" 
                             alt="Banner ${banner.bannerId}" class="d-block w-100">
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p>Cannot get Banner Images</p>
            </c:otherwise>
        </c:choose>
    </div>

    <button class="carousel-control-prev" type="button" data-bs-target="#carousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#carousel" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
    </button>
</div>


