<%@ include file="/WEB-INF/include/header.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Product" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<<<<<<< HEAD
<!DOCTYPE html>
<html>
<head>
    <title>Danh sách linh kiện. - ${category}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f7f7;
            margin: 0;
        }
        h2 {
            text-align: center;
            margin-top: 30px;
            font-size: 2em;
            color: #333;
        }
        .pc-container {
            max-width: 1200px;
            margin: 30px auto;
            display: flex;
            flex-wrap: wrap;
            gap: 24px;
            justify-content: center;
        }
        .pc-card {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 12px;
            width: 260px;
            padding: 16px;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            align-items: center;
            transition: box-shadow 0.3s ease, transform 0.2s;
        }
        .pc-card:hover {
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
            transform: translateY(-4px);
        }
        .pc-img {
            width: 100%;
            height: 160px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 10px;
            border: 1px solid #eee;
            background-color: #fafafa;
        }
        .pc-title {
            font-size: 1.1em;
            font-weight: bold;
            text-align: center;
            margin: 6px 0;
            color: #222;
        }
        .pc-desc {
            font-size: 0.92em;
            color: #555;
            height: 36px;
            overflow: hidden;
            text-overflow: ellipsis;
            text-align: center;
        }
        .pc-price {
            color: #cc1d1d;
            font-weight: bold;
            margin: 8px 0;
            font-size: 1em;
        }
        .pc-stock {
            font-size: 0.9em;
            color: #007800;
            margin-bottom: 8px;
        }
        .rating-info {
            margin: 6px 0;
            font-size: 0.9em;
            text-align: center;
            color: #444;
        }
        .btn-row {
            display: flex;
            gap: 8px;
            margin-top: 10px;
            width: 100%;
            justify-content: center;
            flex-wrap: wrap;
        }
        .pc-detail-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            font-weight: 600;
            text-decoration: none;
            text-align: center;
            cursor: pointer;
            transition: background 0.2s;
        }
        .pc-detail-btn.blue {
            background-color: #005fff;
            color: #fff;
        }
        .pc-detail-btn.blue:hover {
            background-color: #0040b3;
        }
        .pc-detail-btn.green {
            background-color: #1dbf36;
            color: #fff;
        }
        .pc-detail-btn.green:hover {
            background-color: #158a28;
        }
        .btn-wish {
            background-color: #fff;
            border: 1px solid #ddd;
            padding: 8px 12px;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.2s, border 0.2s;
        }
        .btn-wish:hover {
            background-color: #ffecec;
            border-color: #cc1d1d;
        }
        .no-pc {
            text-align: center;
            margin-top: 50px;
            font-size: 1.2em;
            color: #999;
        }
    </style>
=======
<title>Danh sách linh kiện - ${category}</title>
<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
<style>
    .component-card {
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .component-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    }
    .btn {
        transition: background-color 0.3s ease, transform 0.2s ease;
    }
    .btn:hover {
        transform: scale(1.05);
    }
    .error-message {
        animation: fadeIn 0.5s ease-in-out;
    }
    @keyframes fadeIn {
        0% { opacity: 0; }
        100% { opacity: 1; }
    }
</style>
>>>>>>> dev
</head>
<body class="bg-gray-100">

<div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold text-center text-gray-800 mb-8">${category}</h1>

    <c:if test="${not empty errorMessage}">
        <div class="error-message bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-lg text-center">
            ${errorMessage}
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty componentList}">
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                <c:forEach var="product" items="${componentList}">
                    <div class="component-card bg-white rounded-lg shadow-md overflow-hidden">
                        <img src="${product.imageUrl}" alt="${product.name}" class="w-full h-48 object-contain p-4"/>
                        <div class="p-4">
                            <h3 class="text-lg font-semibold text-gray-800 truncate">${product.name}</h3>
                            <p class="text-xs text-gray-500 mt-1">${product.category.name}</p>
                            <p class="text-gray-600 text-sm mt-2 h-12 overflow-hidden">${product.description}</p>
                            <p class="text-pink-600 font-bold text-lg mt-2">${product.price} VNÐ</p>
                            <p class="text-gray-500 text-sm mt-1">Tồn kho: ${product.stock}</p>
                            <div class="mt-4 flex space-x-2">
                                <a href="${pageContext.request.contextPath}/ViewComponentDetail?productId=${product.productId}" 
                                   class="btn flex-1 bg-blue-600 text-white py-2 rounded-md text-center hover:bg-blue-700">
                                    Xem chi tiết
                                </a>

                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <form method="post" action="${pageContext.request.contextPath}/AddToCart" class="flex-1">
                                            <input type="hidden" name="productId" value="${product.productId}" />
                                            <button type="submit"
                                                    class="btn bg-green-600 text-white py-2 w-full rounded-md hover:bg-green-700">
                                                Thêm vào giỏ
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/login"
                                           class="btn flex-1 bg-green-600 text-white py-2 text-center rounded-md hover:bg-green-700">
                                            Thêm vào giỏ
                                        </a>
                                    </c:otherwise>
                                </c:choose>

                                <form method="post" action="${pageContext.request.contextPath}/AddToWishlist" class="">
                                    <input type="hidden" name="productId" value="${product.productId}" />
                                    <button type="submit" class="btn bg-red-100 text-red-600 p-2 rounded-md hover:bg-red-200">
                                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                                            <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd"/>
                                        </svg>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="no-components bg-white p-8 rounded-lg shadow-md text-center text-gray-600 text-lg">
                Không có linh kiện nào trong danh mục này.
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>
</body>
</html>

