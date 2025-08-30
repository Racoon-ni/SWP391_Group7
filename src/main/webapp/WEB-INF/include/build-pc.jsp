<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="/WEB-INF/include/header.jsp" %>

<div class="container" style="max-width:1100px; margin:30px auto;"> 
  <h2 style="color:#2196F3; font-size:2.2rem;">Hãy bắt đầu tạo ra 1 chiếc PC cho riêng bạn</h2>

  <table class="table table-bordered mt-4">
    <thead>
      <tr>
        <th>Linh kiện</th>
        <th>Sản phẩm đã chọn</th>
        <th>Chọn / Xóa linh kiện</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="type" items="${components}">
        <tr>
          <td style="font-weight:bold; color:#4285f4">${type}</td>

          <!-- Cột: Sản phẩm đã chọn (hỗ trợ RAM qty) -->
          <td>
            <c:choose>
              <c:when test="${build[type] != null}">
                <img src="${build[type].imageUrl}" width="64" style="vertical-align:middle"/>
                <span style="margin-left:10px">${build[type].name}</span>

                <c:set var="ramQtyVal" value="${qtyMap['RAM'] != null ? qtyMap['RAM'] : 1}" />
                <c:choose>
                  <c:when test="${type == 'RAM'}">
                    <form method="post" action="${pageContext.request.contextPath}/BuildPC"
                          style="display:inline-block; margin-left:12px">
                      <input type="hidden" name="type" value="RAM"/>
                      <input type="number" name="ramQty"
                             value="${ramQtyVal}" min="1"
                             class="form-control d-inline-block"
                             style="width:90px; display:inline-block"/>
                      <button type="submit" class="btn btn-outline-primary btn-sm">Cập nhật</button>
                    </form>
                    <span class="badge bg-info ms-2">
                      ${build[type].price} đ x ${ramQtyVal}
                    </span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge bg-info ms-2">${build[type].price} đ</span>
                  </c:otherwise>
                </c:choose>
              </c:when>

              <c:when test="${skipMap[type]}">
                <span class="text-success">Bạn đã có linh kiện này</span>
              </c:when>

              <c:otherwise>
                <span style="color:#bbb">Chưa chọn</span>
              </c:otherwise>
            </c:choose>
          </td>

          <!-- Cột: Nút chọn/xóa/skip -->
          <td>
            <c:choose>
              <c:when test="${type == 'Mainboard'}">
                <a href="${pageContext.request.contextPath}/SelectComponent?type=Mainboard"
                   class="btn btn-primary">Chọn sản phẩm</a>
              </c:when>
              <c:otherwise>
                <c:choose>
                  <c:when test="${mainboardSelected}">
                    <a href="${pageContext.request.contextPath}/SelectComponent?type=${type}"
                       class="btn btn-success">Chọn sản phẩm</a>
                  </c:when>
                  <c:otherwise>
                    <button class="btn btn-secondary" disabled>Chọn sản phẩm</button>
                  </c:otherwise>
                </c:choose>
              </c:otherwise>
            </c:choose>

            <form method="post" action="${pageContext.request.contextPath}/BuildPC" style="display:inline">
              <input type="hidden" name="type" value="${type}"/>
              <input type="hidden" name="skip" value="1"/>
              <button type="submit" class="btn btn-outline-dark ms-2">Tôi đã có linh kiện này</button>
            </form>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <!-- Tổng và nút hành động -->
  <div class="row mt-4">
    <div class="col-md-6">
      <h4>
        Tổng:&nbsp;
        <span style="color:#e53935; font-size:1.5rem;"><c:out value="${total}"/> đ</span>
      </h4>
    </div>

    <div class="col-md-6 text-end">
      <form method="post" action="${pageContext.request.contextPath}/BuildToCart" style="display:inline">
        <button type="submit" class="btn btn-outline-success me-2"
                <c:if test="${empty build}">disabled</c:if>>
          Chuyển sang giỏ hàng
        </button>
      </form>

      <c:choose>
        <c:when test="${completedCount == fn:length(components)}">
          <form method="post" action="${pageContext.request.contextPath}/checkout" style="display:inline">
            <c:forEach var="p" items="${build.values()}">
              <input type="hidden" name="buildProductIds" value="${p.productId}"/>
            </c:forEach>
            <button type="submit" class="btn btn-primary">Thanh toán</button>
          </form>
        </c:when>
        <c:otherwise>
          <button class="btn btn-secondary" disabled>Thanh toán</button>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>
