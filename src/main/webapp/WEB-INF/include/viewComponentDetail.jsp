<%@ include file="/WEB-INF/include/header.jsp" %>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<title>Chi tiết sản phẩm - <c:out value="${product.name}" default="Sản phẩm"/></title>
<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
<style>
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
    .product-image {
        max-height: 400px;
        object-fit: contain;
    }
</style>
</head>
<body class="bg-gray-100">

    <div class="container mx-auto px-4 py-8">
        <c:if test="${not empty errorMessage}">
            <div class="error-message bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-lg text-center">
                <c:out value="${errorMessage}"/>
            </div>
        </c:if>
        <c:choose>
            <c:when test="${not empty product}">
                <div class="bg-white rounded-lg shadow-md p-6 max-w-4xl mx-auto">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div class="flex justify-center">
                            <img src="${product.imageUrl}" alt="${product.name}" class="product-image w-full rounded-lg"/>
                        </div>
                        <div>
                            <h1 class="text-3xl font-bold text-gray-800 mb-4"><c:out value="${product.name}"/></h1>
                            <p class="text-gray-600 text-lg mb-4"><c:out value="${product.description}" default="Không có mô tả"/></p>
                            <p class="text-pink-600 font-bold text-2xl mb-4"><c:out value="${product.price}"/> USD</p>
                            <p class="text-gray-500 mb-4">Tồn kho: <c:out value="${product.stock}"/></p>
                            <p class="text-gray-500 mb-4">Loại sản phẩm: <c:out value="${product.productType}" default="Không xác định"/></p>
                            <p class="text-gray-500 mb-4">Danh mục ID: <c:out value="${product.categoryId}"/></p>
                            <div class="flex space-x-4">
                                <button onclick="addToCart(${product.productId})" 
                                        class="btn bg-green-600 text-white py-3 px-6 rounded-md hover:bg-green-700">
                                    Thêm vào giỏ
                                </button>
                                <!-- Mua ngay button -->
                                <a href="${pageContext.request.contextPath}/checkout?productId=${product.productId}" 
                                   class="btn bg-blue-600 text-white py-3 px-6 rounded-md hover:bg-blue-700">
                                    Mua ngay
                                </a>
                                <a href="javascript:void(0);" onclick="addToWishlist(${product.productId})" 
                                   class="inline-flex items-center text-red-600 hover:text-red-800">
                                    <svg class="w-6 h-6 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd"/>
                                    </svg>
                                    Yêu thích
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="bg-white p-8 rounded-lg shadow-md text-center text-gray-600 text-lg">
                    Không tìm thấy sản phẩm.
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
</body>
</html>