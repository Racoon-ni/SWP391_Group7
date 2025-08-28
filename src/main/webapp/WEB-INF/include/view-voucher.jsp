<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Voucher" %>
<%@ include file="header.jsp" %>
<%
    List<Voucher> voucherList = (List<Voucher>) request.getAttribute("voucherList");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Kho Voucher</title>
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: #f4f6f9;
                margin: 0;
                padding: 0;
            }


            .main-content {
                margin-left: 240px;
                padding: 100px 30px 30px;
            }

            .voucher-container {
                background-color: #ffffff;
                border-radius: 10px;
                padding: 30px;
                box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
                max-width: 1000px;
                margin: 0 auto;
            }

            .voucher-container h2 {
                text-align: center;
                margin-bottom: 30px;
                color: #333;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }

            th, td {
                border: 1px solid #e0e0e0;
                padding: 12px;
                text-align: center;
            }

            th {
                background-color: #f0f0f0;
                font-weight: 600;
            }

            .expired {
                color: red;
                font-weight: bold;
            }

            .no-voucher {
                text-align: center;
                color: #888;
                margin-top: 40px;
                font-size: 18px;
            }

            @media (max-width: 768px) {
                .sidebar {
                    display: none;
                }

                .main-content {
                    margin-left: 0;
                    padding: 20px;
                }
            }
        </style>
    </head>
    <body>

        <%@include file="../include/user-side-bar.jsp" %>


        <!-- Main content -->
        <div class="main-content">
            <div class="voucher-container">
                <h2>Danh sách mã giảm giá</h2>

                <% if (error != null) {%>
                <div style="color:red; text-align:center;"><%= error%></div>
                <% } %>

                <% if (voucherList == null || voucherList.isEmpty()) { %>
                <p class="no-voucher">Không có voucher khả dụng!</p>
                <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>Mã voucher</th>
                            <th>Phần trăm giảm</th>
                            <th>Giá trị đơn tối thiểu</th>
                            <th>Ngày hết hạn</th>
                        </tr>
                        <% for (Voucher v : voucherList) {%>
                        <tr>
                            <td><%= v.getCode()%></td>
                            <td><%= v.getDiscountPercent()%>%</td>
                            <td><%= String.format("%,.0f", v.getMinOrderValue())%> VND</td>
                            <td><%= new java.text.SimpleDateFormat("dd-MM-yyyy").format(v.getExpiredAt())%></td>
                        </tr>
                        <% } %>
                </table>
                <% }%>
            </div>
        </div>
        <%@ include file="footer.jsp" %>