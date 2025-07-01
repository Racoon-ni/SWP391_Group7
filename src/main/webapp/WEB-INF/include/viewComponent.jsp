<%@ include file="/WEB-INF/include/header.jsp" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
        0% {
            opacity: 0;
        }
        100% {
            opacity: 1;
        }
    }
</style>
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
        0% {
            opacity: 0;
        }
        100% {
            opacity: 1;
        }
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

                                <!-- Hiển thị rating -->
                                <div class="mb-1">
                                    <c:choose>
                                        <c:when test="${product.totalRatings > 0}">
                                            <span class="text-yellow-500 font-bold">
                                                ★ ${product.avgStars} / 5
                                            </span>
                                            <span class="text-gray-500 text-sm ml-2">
                                                (${product.totalRatings} đánh giá)
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-gray-400 italic text-sm">Chưa có đánh giá</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <p class="text-gray-600 text-sm mt-2 h-12 overflow-hidden">${product.description}</p>
                                <p class="text-pink-600 font-bold text-lg mt-2">${product.price} USD</p>
                                <p class="text-gray-500 text-sm mt-1">Tồn kho: ${product.stock}</p>
                                <div class="mt-4 flex space-x-2">
                                    <a href="${pageContext.request.contextPath}/ViewComponentDetail?productId=${product.productId}" 
                                       class="btn flex-1 bg-blue-600 text-white py-2 rounded-md text-center hover:bg-blue-700">
                                        Xem chi tiết
                                    </a>
                                    <!-- THÊM VÀO GIỎ HÀNG -->
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user}">
                                            <form method="post" action="${pageContext.request.contextPath}/AddToCart" class="flex-1">
                                                <input type="hidden" name="productId" value="${product.productId}" />
                                                <button type="submit"
                                                         class="btn bg-green-600 text-white text-center rounded-md hover:bg-green-700 whitespace-nowrap">
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
                                    <button onclick="addToWishlist(${product.productId})" 
                                            class="btn bg-red-100 text-red-600 p-2 rounded-md hover:bg-red-200">
                                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd"/>
                                        </svg>
                                    </button>
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

    <script>
        function addToCart(productId) {
            fetch('${pageContext.request.contextPath}/AddToCart?productId=' + productId, {
                method: 'POST',
                headers: {'Content-Type': 'application/json'}
            })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('Đã thêm sản phẩm vào giỏ hàng!');
                        } else {
                            alert('Lỗi: ' + data.message);
                        }
                    })
                    .catch(error => {
                        alert('Lỗi khi thêm vào giỏ hàng: ' + error);
                    });
        }

        function addToWishlist(productId) {
            fetch('${pageContext.request.contextPath}/AddToWishlist?productId=' + productId, {
                method: 'POST',
                headers: {'Content-Type': 'application/json'}
            })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('Đã thêm sản phẩm vào danh sách yêu thích!');
                        } else {
                            alert('Lỗi: ' + data.message);
                        }
                    })
                    .catch(error => {
                        alert('Lỗi khi thêm vào danh sách yêu thích: ' + error);
                    });
        }
    </script>

    <%@ include file="/WEB-INF/include/footer.jsp" %>
</body>
</html>