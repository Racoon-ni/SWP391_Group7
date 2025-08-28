<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>  

<div id="carousel" class="carousel slide" data-bs-ride="carousel">
  <div class="carousel-inner">
    <c:choose>
      <c:when test="${not empty banners}">
        <c:forEach var="banner" items="${banners}" varStatus="status">
          <div class="carousel-item ${status.index == 0 ? 'active' : ''}">
            <c:choose>
              <%-- Nếu có targetUrl thì bọc <a> --%>
              <c:when test="${not empty banner.targetUrl}">
                <c:choose>
                  <%-- Link ngoài: http/https --%>
                  <c:when test="${fn:startsWith(banner.targetUrl, 'http')}">
                    <a class="d-block" href="${banner.targetUrl}" target="_blank" rel="noopener">
                      <img src="${pageContext.request.contextPath}${banner.imageUrl}"
                           alt="Banner ${banner.bannerId}" class="d-block w-100">
                    </a>
                  </c:when>
                  <%-- Link nội bộ: bắt đầu bằng "/" --%>
                  <c:otherwise>
                    <a class="d-block" href="${pageContext.request.contextPath}${banner.targetUrl}">
                      <img src="${pageContext.request.contextPath}${banner.imageUrl}"
                           alt="Banner ${banner.bannerId}" class="d-block w-100">
                    </a>
                  </c:otherwise>
                </c:choose>
              </c:when>

              <%-- Không có link thì chỉ hiện ảnh --%>
              <c:otherwise>
                <img src="${pageContext.request.contextPath}${banner.imageUrl}"
                     alt="Banner ${banner.bannerId}" class="d-block w-100">
              </c:otherwise>
            </c:choose>
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
