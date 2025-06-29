<%@ include file="/WEB-INF/include/header.jsp" %>
    <c:set var="isLoggedIn" value="${not empty sessionScope.user}" />

    <%@ page import="java.util.List" %>
        <%@ page import="model.Voucher" %>
            <%@ page pageEncoding="UTF-8" %>
                <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

                    <title>Chi tiết sản phẩm -
                        <c:out value="${product.name}" default="Sản phẩm" />
                    </title>
                    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
                    <% List<Voucher> vouchers = (List<Voucher>) request.getAttribute("vouchers");
                            Integer userId = (Integer) session.getAttribute("userId"); // từ session sau khi login
                            %>
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
                                        <div
                                            class="error-message bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-lg text-center">
                                            <c:out value="${errorMessage}" />
                                        </div>
                                    </c:if>
                                    <c:choose>
                                        <c:when test="${not empty product}">
                                            <div class="bg-white rounded-lg shadow-md p-6 max-w-4xl mx-auto">
                                                <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                                                    <div class="flex justify-center">
                                                        <img src="${product.imageUrl}" alt="${product.name}"
                                                            class="product-image w-full rounded-lg" />
                                                    </div>
                                                    <div>
                                                        <h1 class="text-3xl font-bold text-gray-800 mb-4">
                                                            <c:out value="${product.name}" />
                                                        </h1>
                                                        <p class="text-gray-600 text-lg mb-4">
                                                            <c:out value="${product.description}"
                                                                default="Không có mô tả" />
                                                        </p>
                                                        <p class="text-pink-600 font-bold text-2xl mb-4">
                                                            <c:out value="${product.price}" /> USD
                                                        </p>
                                                        <p class="text-gray-500 mb-4">Tồn kho:
                                                            <c:out value="${product.stock}" />
                                                        </p>
                                                        <p class="text-gray-500 mb-4">Loại sản phẩm:
                                                            <c:out value="${product.productType}"
                                                                default="Không xác định" />
                                                        </p>
                                                        <p class="text-gray-500 mb-4">Danh mục ID:
                                                            <c:out value="${product.categoryId}" />
                                                        </p>
                                                        <div class="flex space-x-4">
                                                            <form method="post"
                                                                action="${pageContext.request.contextPath}/AddToCart"
                                                                class="flex-1">
                                                                <input type="hidden" name="productId"
                                                                    value="${product.productId}" />
                                                                <button type="submit"
                                                                    class="btn w-full bg-green-600 text-white py-2 rounded-md hover:bg-green-700">
                                                                    Thêm vào giỏ hàng
                                                                </button>
                                                            </form>

                                                            <!-- Mua ngay button -->
                                                            <a href="${pageContext.request.contextPath}/checkout?productId=${product.productId}"
                                                                class="btn bg-blue-600 text-white py-3 px-6 rounded-md hover:bg-blue-700">
                                                                Mua ngay
                                                            </a>
                                                            <button onclick="addToWishlist(${product.productId})"
                                                                class="btn bg-red-100 text-red-600 py-3 px-4 rounded-md hover:bg-red-200">
                                                                <svg class="w-6 h-6 inline-block" fill="currentColor"
                                                                    viewBox="0 0 20 20">
                                                                    <path fill-rule="evenodd"
                                                                        d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z"
                                                                        clip-rule="evenodd" />
                                                                </svg>
                                                                Yêu thích
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div
                                                class="bg-white p-8 rounded-lg shadow-md text-center text-gray-600 text-lg">
                                                Không tìm thấy sản phẩm.
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <h3 class="text-xl font-semibold mt-8 mb-4 text-gray-800">Voucher đang có</h3>
                                <% if (vouchers !=null && !vouchers.isEmpty()) { %>
                                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                                        <% for (Voucher v : vouchers) {%>
                                            <div
                                                class="bg-white p-4 shadow-md rounded-lg flex flex-col justify-between border border-gray-200">
                                                <div>
                                                    <h4 class="text-lg font-bold text-red-600 mb-1">
                                                        <%= v.getCode()%>
                                                    </h4>
                                                    <p class="text-sm text-gray-700 mb-1">
                                                        Giảm <%= v.getDiscountPercent()%>% cho đơn từ <span
                                                                class="font-medium">
                                                                <%= String.format("%,.0f", v.getMinOrderValue())%> đ
                                                            </span>
                                                    </p>
                                                    <p class="text-xs text-gray-500">Hạn: <%= new
                                                            java.text.SimpleDateFormat("dd-MM-yyyy").format(v.getExpiredAt())%>
                                                    </p>
                                                </div>
                                                <form action="GetVoucher" method="post" class="mt-4 text-right">
                                                    <input type="hidden" name="voucherId"
                                                        value="<%= v.getVoucherId()%>">
                                                    <button type="submit"
                                                        class="px-4 py-1 bg-red-500 hover:bg-red-600 text-white text-sm rounded transition">
                                                        Nhận ngay
                                                    </button>
                                                </form>
                                            </div>
                                            <% } %>
                                    </div>
                                    <% } else { %>
                                        <p class="text-gray-500">Hiện chưa có voucher nào khả dụng.</p>
                                        <% }%>
                                            <script>
                                                // Kiểm tra đăng nhập từ server, gán biến JS dạng string "true"/"false"
                                                const isLoggedIn = "${not empty sessionScope.user}";

                                                function addToCart(productId) {
                                                    if (isLoggedIn !== "true") {
                                                        alert("Bạn cần đăng nhập để thêm sản phẩm vào giỏ hàng.");
                                                        window.location.href = '${pageContext.request.contextPath}/login';
                                                        return;
                                                    }

                                                    fetch('${pageContext.request.contextPath}/AddToCart?productId=' + productId, {
                                                        method: 'POST'
                                                    })
                                                        .then(response => response.text())
                                                        .then(text => {
                                                            try {
                                                                const data = JSON.parse(text);
                                                                if (data.success) {
                                                                    alert('Đã thêm sản phẩm vào giỏ hàng!');
                                                                } else {
                                                                    alert('Lỗi: ' + data.message);
                                                                }
                                                            } catch (e) {
                                                                alert('Lỗi định dạng phản hồi từ server.');
                                                            }
                                                        })
                                                        .catch(error => {
                                                            alert('Lỗi khi thêm vào giỏ hàng: ' + error);
                                                        });
                                                }
                                            </script>

                                            <%@ include file="/WEB-INF/include/footer.jsp" %>
                            </body>

                            </html>