<%@ include file="/WEB-INF/include/header.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Product" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<title>Danh sách linh kiện - ${category}</title>
<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

                            <!-- Đánh giá sản phẩm -->
                            <div class="rating-info flex items-center mt-1 mb-1">
                                <c:choose>
                                    <c:when test="${product.totalRatings > 0}">
                                        <c:set var="avg" value="${product.avgStars}" />
                                        <c:set var="fullStars" value="${avg - (avg % 1)}" />
                                        <c:set var="hasHalf" value="${avg - fullStars >= 0.25 && avg - fullStars < 0.75}" />
                                        <c:set var="emptyStars" value="${5 - fullStars - (hasHalf ? 1 : 0)}" />

                                        <c:forEach var="i" begin="1" end="${fullStars}">
                                            <i class="fa-solid fa-star" style="color: orange;"></i>
                                        </c:forEach>
                                        <c:if test="${hasHalf}">
                                            <i class="fa-solid fa-star-half-stroke" style="color: orange;"></i>
                                        </c:if>
                                        <c:forEach var="i" begin="1" end="${emptyStars}">
                                            <i class="fa-regular fa-star" style="color: orange;"></i>
                                        </c:forEach>
                                        <span class="ml-2 font-semibold text-sm">
                                            ${String.format("%.1f", avg)} / 5
                                        </span>
                                        <span class="ml-1 text-gray-400 text-xs">(${product.totalRatings} đánh giá)</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-gray-400 text-sm ml-1">Chưa có đánh giá</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <!-- Kết thúc đánh giá -->

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
