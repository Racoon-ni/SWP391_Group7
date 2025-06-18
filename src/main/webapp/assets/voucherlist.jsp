<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Voucher" %>
<%@ page import="java.util.ArrayList" %>
<%
    ArrayList<Voucher> list = (ArrayList<Voucher>) request.getAttribute("voucherList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Danh sách voucher</title>
</head>
<body>
    <h2>Danh sách mã giảm giá</h2>
    <table border="1" cellpadding="10">
        <tr>
            <th>Mã</th>
            <th>Mô tả</th>
            <th>Ngày hết hạn</th>
            <th>Giảm (%)</th>
        </tr>
        <%
            if (list != null) {
                for (Voucher v : list) {
        %>
        <tr>
            <td><%= v.getCode() %></td>
            <td><%= v.getDescription() %></td>
            <td><%= v.getExpiryDate() %></td>
            <td><%= v.getDiscountPercent() %></td>
        </tr>
        <%
                }
            }
        %>
    </table>
</body>
</html>
