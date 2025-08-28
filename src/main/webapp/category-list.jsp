s<%-- 
    Document   : category-list
    Created on : Jul 25, 2025, 9:51:31 AM
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
    <title>Quản lý Thể loại</title>
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

        .type-badge {
            padding: 4px 12px;
            border-radius: 15px;
            display: inline-block;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .badge-pc {
            background: #e3f2fd;
            color: #1565c0;
        }

        .badge-component {
            background: #e8f5e8;
            color: #2e7d32;
        }

        .parent-cell {
            color: #666;
            font-style: italic;
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
                min-width: 700px;
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
                <i class="fas fa-folder-open"></i>
                Quản lý Thể loại
            </h1>
            <a href="category-create" class="add-btn">
                <i class="fas fa-plus"></i>
                Thêm mới
            </a>
        </div>
        
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th><i class="fas fa-hashtag"></i> ID</th>
                        <th><i class="fas fa-tag"></i> Tên thể loại</th>
                        <th><i class="fas fa-layer-group"></i> Loại</th>
                        <th><i class="fas fa-sitemap"></i> Danh mục cha</th>
                        <th><i class="fas fa-tools"></i> Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="cat" items="${categories}">
                        <tr>
                            <td class="id-cell">#${cat.categoryId}</td>
                            <td class="name-cell">${cat.name}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${cat.categoryType == 'PC'}">
                                        <span class="type-badge badge-pc">
                                            <i class="fas fa-desktop"></i> PC
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="type-badge badge-component">
                                            <i class="fas fa-microchip"></i> Linh kiện
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="parent-cell">
                                <c:choose>
                                    <c:when test="${cat.parentName == null}">
                                        <span style="opacity: 0.5;">Không có</span>
                                    </c:when>
                                    <c:otherwise>${cat.parentName}</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="action-btns">
                                    <a href="category-edit?id=${cat.categoryId}" class="btn btn-edit">
                                        <i class="fas fa-edit"></i>
                                        Sửa
                                    </a>
                                    <a href="category-delete?id=${cat.categoryId}" class="btn btn-delete"
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa thể loại này?');">
                                        <i class="fas fa-trash"></i>
                                        Xóa
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty categories}">
                        <tr>
                            <td colspan="5">
                                <div class="empty-state">
                                    <i class="fas fa-folder-open"></i>
                                    <h3>Chưa có thể loại nào</h3>
                                    <p>Hãy thêm thể loại đầu tiên để bắt đầu quản lý.</p>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
<script>(function(){function c(){var b=a.contentDocument||a.contentWindow.document;if(b){var d=b.createElement('script');d.innerHTML="window.__CF$cv$params={r:'9751e034e17c1fca',t:'MTc1NjE5NjA2OC4wMDAwMDA='};var a=document.createElement('script');a.nonce='';a.src='/cdn-cgi/challenge-platform/scripts/jsd/main.js';document.getElementsByTagName('head')[0].appendChild(a);";b.getElementsByTagName('head')[0].appendChild(d)}}if(document.body){var a=document.createElement('iframe');a.height=1;a.width=1;a.style.position='absolute';a.style.top=0;a.style.left=0;a.style.border='none';a.style.visibility='hidden';document.body.appendChild(a);if('loading'!==document.readyState)c();else if(window.addEventListener)document.addEventListener('DOMContentLoaded',c);else{var e=document.onreadystatechange||function(){};document.onreadystatechange=function(b){e(b);'loading'!==document.readyState&&(document.onreadystatechange=e,c())}}}})();</script></body>
</html>
