<%-- 
    Document   : attribute-edit
    Created on : Jul 25, 2025, 10:36:11 AM
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
    <title>Sửa Thuộc tính</title>
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
            padding: 20px;
        }

        .container {
            max-width: 600px;
            margin: 40px auto;
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .header {
            background: #1e3c72;
            color: white;
            padding: 25px 30px;
            text-align: center;
        }

        .form-title {
            font-size: 1.8rem;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .form-content {
            padding: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
            color: #2c3e50;
            font-size: 0.95rem;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: #fff;
        }

        .form-control:focus {
            outline: none;
            border-color: #1e3c72;
            box-shadow: 0 0 0 3px rgba(30, 60, 114, 0.1);
        }

        .form-control::placeholder {
            color: #999;
            font-style: italic;
        }

        .form-select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: #fff;
            cursor: pointer;
        }

        .form-select:focus {
            outline: none;
            border-color: #1e3c72;
            box-shadow: 0 0 0 3px rgba(30, 60, 114, 0.1);
        }

        .button-group {
            display: flex;
            gap: 15px;
            align-items: center;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .btn-primary {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.95rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 3px 8px rgba(30, 60, 114, 0.3);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #2a5298 0%, #1e3c72 100%);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(30, 60, 114, 0.4);
        }

        .btn-link {
            color: #666;
            text-decoration: none;
            padding: 12px 16px;
            border-radius: 6px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-weight: 500;
        }

        .btn-link:hover {
            color: #1e3c72;
            background: #f8f9ff;
            text-decoration: none;
        }

        .required-field::after {
            content: " *";
            color: #f44336;
            font-weight: bold;
        }

        @media (max-width: 768px) {
            .container {
                margin: 20px auto;
            }

            .form-title {
                font-size: 1.5rem;
            }

            .form-content {
                padding: 20px;
            }

            .button-group {
                flex-direction: column;
                align-items: stretch;
            }

            .btn-primary,
            .btn-link {
                justify-content: center;
                width: 100%;
            }
        }

        /* Input validation styles */
        .form-control:invalid {
            border-color: #f44336;
        }

        .form-control:valid {
            border-color: #4CAF50;
        }

        /* Loading state for form submission */
        .btn-primary:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
    </style>
</head>
<body>
    <!-- Include admin sidebar (keeping original JSP include) -->
    <%@include file="WEB-INF/include/admin-side-bar.jsp" %>
    
    <div class="container">
        <div class="header">
            <h1 class="form-title">
                <i class="fas fa-edit"></i>
                Sửa Thuộc tính
            </h1>
        </div>
        
        <div class="form-content">
            <form method="post" autocomplete="off">
                <input type="hidden" name="id" value="${attribute.attributeId}" />
                
                <div class="form-group">
                    <label class="form-label required-field">Tên thuộc tính</label>
                    <input name="name" class="form-control" required value="${attribute.name}" 
                           placeholder="Nhập tên thuộc tính..." />
                </div>
                
                <div class="form-group">
                    <label class="form-label">Đơn vị</label>
                    <input name="unit" class="form-control" value="${attribute.unit}" 
                           placeholder="VD: GB, MHz, inch..." />
                </div>
                
                <div class="form-group">
                    <label class="form-label required-field">Danh mục</label>
                    <select name="categoryId" class="form-select" required>
                        <option value="">-- Chọn danh mục --</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryId}" 
                                    <c:if test="${attribute.categoryId == cat.categoryId}">selected</c:if>>
                                ${cat.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="button-group">
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-save"></i>
                        Lưu thay đổi
                    </button>
                    <a href="attributes" class="btn-link">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại
                    </a>
                </div>
            </form>
        </div>
    </div>
<script>(function(){function c(){var b=a.contentDocument||a.contentWindow.document;if(b){var d=b.createElement('script');d.innerHTML="window.__CF$cv$params={r:'9751d58866580725',t:'MTc1NjE5NTYzMS4wMDAwMDA='};var a=document.createElement('script');a.nonce='';a.src='/cdn-cgi/challenge-platform/scripts/jsd/main.js';document.getElementsByTagName('head')[0].appendChild(a);";b.getElementsByTagName('head')[0].appendChild(d)}}if(document.body){var a=document.createElement('iframe');a.height=1;a.width=1;a.style.position='absolute';a.style.top=0;a.style.left=0;a.style.border='none';a.style.visibility='hidden';document.body.appendChild(a);if('loading'!==document.readyState)c();else if(window.addEventListener)document.addEventListener('DOMContentLoaded',c);else{var e=document.onreadystatechange||function(){};document.onreadystatechange=function(b){e(b);'loading'!==document.readyState&&(document.onreadystatechange=e,c())}}}})();</script></body>
</html>
