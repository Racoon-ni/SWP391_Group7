<%-- 
    Document   : admin-pc-details
    Created on : Jul 14, 2025, 9:00:54 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@page import="model.ProductAttribute"%>
<%@page import="java.util.ArrayList"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.PC" %>
<%
    PC pc = (PC) request.getAttribute("pc"); // Assume it's passed from a servlet
    ArrayList<ProductAttribute> pAttList = (ArrayList<ProductAttribute>) request.getAttribute("pAttList");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thông số PC</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">

        <div class="container mt-5">
            <div class="row g-4">
                <!-- Left: Image -->
                <div class="col-md-4">
                    <div class="card shadow-sm">
                        <img src="<%= pc.getImageUrl()%>" class="card-img-top" alt="<%= pc.getName()%>">
                    </div>
                </div>

                <!-- Right: PC Info -->
                <div class="col-md-6">
                    <div class="card shadow-sm p-4">
                        <h2 class="mb-3"><%= pc.getName()%></h2>
                        <p class="text-muted mb-4"><%= pc.getDescription()%></p>

                        <ul class="list-group list-group-flush mb-4">
                            <%
                                for (ProductAttribute pAtt : pAttList) {

                            %>
                            <li class="list-group-item"><strong> <%= pAtt.getAttribute().getName()%>: </strong>
                                <%= pAtt.getValue()%>  <%= pAtt.getAttribute().getUnit()%>  
                            </li>
                            <%}%>
                        </ul>

                        <h4 class="text-success mb-3"><%
                            java.text.NumberFormat vndFormat = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
                            String formattedPrice = vndFormat.format(pc.getPrice()) + "₫";
                            %>
                            <%= formattedPrice%>
                        </h4>

                    </div>
                </div>
            </div>
        </div>

    </body>
</html>

