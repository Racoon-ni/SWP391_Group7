<%@page import="model.Voucher"%>
<%@ include file="/WEB-INF/include/header.jsp" %>
<c:set var="isLoggedIn" value="${not empty sessionScope.user}" />

<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
<% List<Voucher> vouchers = (List<Voucher>) request.getAttribute("vouchers");
    Integer userId = (Integer) session.getAttribute("userId"); // từ session sau khi login
%>

<h3 class="text-xl font-semibold mt-8 mb-4 text-gray-800">Voucher đang có</h3>
<% if (vouchers != null && !vouchers.isEmpty()) { %>
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
    <% for (Voucher v : vouchers) {%>
    <div
        class="bg-white p-4 shadow-md rounded-lg flex flex-col justify-between border border-gray-200">
        <div>
            <h4 class="text-lg font-bold text-red-600 mb-1">
                <%= v.getCode()%>
            </h4>
            <p class="text-sm text-gray-700 mb-1">
                Giảm <%= v.getDiscountPercent()%>% cho đơn từ <span
                    class="font-medium">
                    <%= String.format("%,.0f", v.getMinOrderValue())%> VND
                </span>
            </p>
            <p class="text-xs text-gray-500">Hạn: <%= new java.text.SimpleDateFormat("dd-MM-yyyy").format(v.getExpiredAt())%>
            </p>
        </div>
        <form action="GetVoucher" method="post" class="mt-4 text-right">
            <input type="hidden" name="voucherId"
                   value="<%= v.getVoucherId()%>">
            <button type="submit"
                    class="px-4 py-1 bg-red-500 hover:bg-red-600 text-white text-sm rounded transition">
                Nhận ngay
            </button>
        </form>
    </div>
    <% } %>
</div>
<% } else { %>
<p class="text-gray-500">Hiện chưa có voucher nào khả dụng.</p>
<% }%>



<%@ include file="/WEB-INF/include/footer.jsp" %>
</body>
</html>