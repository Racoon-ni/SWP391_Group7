<%-- 
    Document   : attribute-list
    Created on : Jul 25, 2025, 10:32:48 AM
    Author     : ThinhLVCE181726 <your.name at your.org>
--%>
        <%@include file="WEB-INF/include/admin-side-bar.jsp" %>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Thuộc tính</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #ffffff;
            color: #333;
            line-height: 1.6;
        }

        .container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .header {
            background: #1e3c72;
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 600;
            margin: 0;
        }

        .add-btn {
            background: #4CAF50;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: background 0.3s ease;
        }

        .add-btn:hover {
            background: #45a049;
            color: white;
            text-decoration: none;
        }

        .table-wrapper {
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: #1e3c72;
        }

        thead th {
            color: white;
            padding: 16px 12px;
            font-weight: 500;
            text-align: left;
            font-size: 0.9rem;
        }

        tbody tr {
            border-bottom: 1px solid #f0f0f0;
            transition: background 0.2s ease;
        }

        tbody tr:hover {
            background: #f8f9ff;
        }

        tbody tr:last-child {
            border-bottom: none;
        }

        tbody td {
            padding: 14px 12px;
            font-size: 0.9rem;
        }

        .id-cell {
            font-weight: 600;
            color: #1e3c72;
        }

        .name-cell {
            font-weight: 500;
            color: #2c3e50;
        }

        .unit-cell {
            color: #666;
        }

        .category-cell {
            background: #e3f2fd;
            color: #1565c0;
            padding: 4px 12px;
            border-radius: 15px;
            display: inline-block;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .action-btns {
            display: flex;
            gap: 8px;
        }

        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            font-weight: 500;
            text-decoration: none;
            font-size: 0.85rem;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .btn-edit {
            background: linear-gradient(135deg, #ff9800 0%, #ff6f00 100%);
            color: white;
            box-shadow: 0 3px 8px rgba(255, 152, 0, 0.3);
            border: 1px solid #ff8f00;
        }

        .btn-edit:hover {
            background: linear-gradient(135deg, #f57c00 0%, #e65100 100%);
            color: white;
            text-decoration: none;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(255, 152, 0, 0.4);
        }

        .btn-delete {
            background: linear-gradient(135deg, #f44336 0%, #c62828 100%);
            color: white;
            box-shadow: 0 3px 8px rgba(244, 67, 54, 0.3);
            border: 1px solid #d32f2f;
        }

        .btn-delete:hover {
            background: linear-gradient(135deg, #d32f2f 0%, #b71c1c 100%);
            color: white;
            text-decoration: none;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(244, 67, 54, 0.4);
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #666;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 15px;
            color: #ccc;
        }

        @media (max-width: 768px) {
            .container {
                margin: 20px auto;
                padding: 0 15px;
            }

            .page-title {
                font-size: 1.5rem;
            }
            
            .header {
                flex-direction: column;
                text-align: center;
                padding: 20px;
            }
            
            table {
                font-size: 0.8rem;
            }
            
            .action-btns {
                flex-direction: column;
                gap: 4px;
            }
        }

        @media (max-width: 600px) {
            .table-wrapper {
                overflow-x: auto;
            }
            
            table {
                min-width: 600px;
            }
        }
    </style>
</head>
<body>
    <!-- Include admin sidebar (keeping original JSP include) -->
    <%@include file="WEB-INF/include/admin-side-bar.jsp" %>
    
    <div class="container">
        <div class="header">
            <h1 class="page-title">
                <i class="fas fa-cogs"></i>
                Quản lý Thuộc tính
            </h1>
            <!-- Form lọc theo danh mục -->
        <form method="get" action="attributes" style="display:flex; gap:8px; align-items:center;">
            <select name="categoryId" style="padding:8px; border-radius:6px; border:1px solid #ccc;">
                <option value="">-- Tất cả danh mục --</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.categoryId}" 
                        <c:if test="${cat.categoryId == selectedCategoryId}">selected</c:if>>
                        ${cat.name}
                    </option>
                </c:forEach>
            </select>
            <button type="submit" class="add-btn" style="background:#1e3c72;">
                <i class="fas fa-filter"></i> Lọc
            </button>
        </form>
            <a href="attribute-create" class="add-btn">
                <i class="fas fa-plus"></i>
                Thêm mới
            </a>
        </div>
        
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th><i class="fas fa-hashtag"></i> ID</th>
                        <th><i class="fas fa-tag"></i> Tên thuộc tính</th>
                        <th><i class="fas fa-ruler"></i> Đơn vị</th>
                        <th><i class="fas fa-folder"></i> Danh mục</th>
                        <th><i class="fas fa-tools"></i> Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="attr" items="${attributes}">
                        <tr>
                            <td class="id-cell">#${attr.attributeId}</td>
                            <td class="name-cell">${attr.name}</td>
                            <td class="unit-cell">
                                <c:choose>
                                    <c:when test="${empty attr.unit}">-</c:when>
                                    <c:otherwise>${attr.unit}</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span class="category-cell">${attr.categoryName}</span>
                            </td>
                            <td>
                                <div class="action-btns">
                                    <a href="attribute-edit?id=${attr.attributeId}" class="btn btn-edit">
                                        <i class="fas fa-edit"></i>
                                        Sửa
                                    </a>
                                    <a href="attribute-delete?id=${attr.attributeId}" class="btn btn-delete"
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa thuộc tính này?');">
                                        <i class="fas fa-trash"></i>
                                        Xóa
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty attributes}">
                        <tr>
                            <td colspan="5">
                                <div class="empty-state">
                                    <i class="fas fa-inbox"></i>
                                    <h3>Chưa có thuộc tính nào</h3>
                                    <p>Hãy thêm thuộc tính đầu tiên để bắt đầu.</p>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
<script>(function(){function c(){var b=a.contentDocument||a.contentWindow.document;if(b){var d=b.createElement('script');d.innerHTML="window.__CF$cv$params={r:'9751d00cb355dd5d',t:'MTc1NjE5NTQwNy4wMDAwMDA='};var a=document.createElement('script');a.nonce='';a.src='/cdn-cgi/challenge-platform/scripts/jsd/main.js';document.getElementsByTagName('head')[0].appendChild(a);";b.getElementsByTagName('head')[0].appendChild(d)}}if(document.body){var a=document.createElement('iframe');a.height=1;a.width=1;a.style.position='absolute';a.style.top=0;a.style.left=0;a.style.border='none';a.style.visibility='hidden';document.body.appendChild(a);if('loading'!==document.readyState)c();else if(window.addEventListener)document.addEventListener('DOMContentLoaded',c);else{var e=document.onreadystatechange||function(){};document.onreadystatechange=function(b){e(b);'loading'!==document.readyState&&(document.onreadystatechange=e,c())}}}})();</script></body>
</html>
