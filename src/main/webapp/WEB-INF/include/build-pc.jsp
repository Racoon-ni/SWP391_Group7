<%-- 
    Document   : build-pc
    Created on : 22-07-2025, 18:58:45
    Author     : Long
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:if test="${param.msg != null}">
    <div class="alert alert-success">${param.msg}</div>
</c:if>

<div class="container" style="max-width: 1100px; margin: 30px auto;">
    <h2 class="mb-4" style="color: #2196F3; font-size: 2.2rem;">Hãy bắt đầu tạo ra 1 chiếc PC cho riêng bạn</h2>
    <form>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Linh kiện</th>
                    <th>Sản phẩm đã chọn</th>
                    <th>Chọn sản phẩm</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="type" items="${components}">
                    <tr>
                        <td style="font-weight: bold; color: #4285f4">${type}</td>
                        <td>
                            <c:choose>
                                <c:when test="${build[type] != null}">
                                    <img src="${build[type].imageUrl}" alt="" width="64" style="vertical-align:middle">
                                    <span style="margin-left:10px">${build[type].name}</span>
                                    <span class="badge bg-info ms-2">${build[type].price} đ</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color:#bbb">Chưa chọn</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${type == 'Mainboard'}">
                                    <a href="SelectComponent?type=Mainboard" class="btn btn-primary">Chọn sản phẩm</a>
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${mainboardSelected}">
                                            <a href="SelectComponent?type=${type}" class="btn btn-success">Chọn sản phẩm</a>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-secondary" disabled>Chọn sản phẩm</button>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </form>
    <div class="row mt-4">
        <div class="col-md-6">
            <h4>Tổng: <span style="color: #e53935; font-size: 1.5rem;"><c:out value="${total}" /> đ</span></h4>
        </div>
        <div class="col-md-6 text-end">
            <!-- Nút thanh toán  -->
            <c:choose>
                <c:when test="${fn:length(build) == fn:length(components)}">
                    <a href="checkout" class="btn btn-primary ms-2">Thanh toán</a>
                </c:when>
                <c:otherwise>
                    <button class="btn btn-secondary ms-2" disabled>Thanh toán</button>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>


<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
<%@ include file="/WEB-INF/include/footer.jsp" %>
