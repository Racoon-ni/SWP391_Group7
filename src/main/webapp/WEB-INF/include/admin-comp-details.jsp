<%-- 
    Document   : admin-comp-details
    Created on : Jul 18, 2025, 2:23:10 PM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@page import="model.Component"%>
<%@page import="model.ProductAttribute"%>
<%@page import="java.util.ArrayList"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Component comp = (Component) request.getAttribute("comp"); // Assume it's passed from a servlet
    ArrayList<ProductAttribute> pAttList = (ArrayList<ProductAttribute>) request.getAttribute("pAttList");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thông tin linh kiện</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .admin-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 2rem 0;
            }

            .spec-item {
                border-left: 4px solid #667eea;
                background: #f8f9fa;
                margin-bottom: 0.5rem;
                transition: all 0.3s ease;
            }

            .spec-item:hover {
                background: #e9ecef;
                transform: translateX(5px);
            }

            .price-badge {
                background: linear-gradient(45deg, #28a745, #20c997);
                color: white;
                font-size: 1.5rem;
                font-weight: bold;
                padding: 1rem 2rem;
                border-radius: 50px;
                display: inline-block;
                box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
            }

            .admin-card {
                border: none;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                overflow: hidden;
            }

            .product-image {
                border-radius: 15px;
                transition: transform 0.3s ease;
            }

            .product-image:hover {
                transform: scale(1.05);
            }

            .admin-badge {
                background: #dc3545;
                color: white;
                padding: 0.5rem 1rem;
                border-radius: 25px;
                font-size: 0.9rem;
                font-weight: 600;
            }

            .back-btn {
                background: linear-gradient(45deg, #6c757d, #495057);
                border: none;
                color: white;
                padding: 0.75rem 2rem;
                border-radius: 25px;
                transition: all 0.3s ease;
            }

            .back-btn:hover {
                background: linear-gradient(45deg, #495057, #343a40);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            }
        </style>
    </head>
<body class="bg-light">
        <!-- Admin Header -->
        <div class="admin-header">
            <div class="container">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="mb-0 opacity-75">Thông số linh kiện</h1>
                    </div>
                </div>
            </div>
        </div>

        <div class="container mt-5">
            <!-- Back Button -->
            <div class="mb-4">
                <button class="btn back-btn" onclick="window.history.back()">
                    ← Quay lại danh sách linh kiện
                </button>
            </div>

            <div class="row g-4">
                <!-- Left: Product Image -->
                <div class="col-lg-4">
                    <div class="admin-card">
                        <img src="${comp.imageUrl}" 
                             class="card-img-top product-image" 
                             alt="Gaming PC Setup"
                             style="height: 400px; object-fit: cover;">
                    </div>
                </div>

                <!-- Right: Product Information -->
                <div class="col-lg-7">
                    <div class="admin-card p-4">
                        <!-- Product Name -->
                        <div class="mb-4">
                            <h2 class="text-primary mb-2">${comp.name}</h2>
                            <p class="text-muted lead">${comp.description}</p>
                        </div>

                        <!-- Specifications -->
                        <div class="mb-4">
                            <h4 class="mb-3 text-dark">Thông số kỹ thuật</h4>
                            <div class="row">
                                <div class="col-12">
                                    <%
                                        for (ProductAttribute pAtt : pAttList) {

                                    %>

                                    <div class="spec-item p-3 rounded">
                                        <strong><%= pAtt.getAttribute().getName()%>:</strong> 
                                        <%= pAtt.getValue()%>  <%= pAtt.getAttribute().getUnit()%>  
                                    </div>

                                    <%}%>
                                </div>
                            </div>
                        </div>

                        <!-- Price -->
                        <div class="mb-4">
                            <h4 class="mb-3 text-dark">Giá</h4>
                            <div class="text-center">
                                <%
                                    java.text.NumberFormat vndFormat = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
                                    String formattedPrice = vndFormat.format(comp.getPrice()) + " VND";
                                %>
<span class="price-badge"> <%= formattedPrice%></span>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                    // Add hover effects for better interactivity
                    document.querySelectorAll('.spec-item').forEach(item => {
                        item.addEventListener('mouseenter', function () {
                            this.style.borderLeftColor = '#28a745';
                        });

                        item.addEventListener('mouseleave', function () {
                            this.style.borderLeftColor = '#667eea';
                        });
                    });
        </script>
</html>