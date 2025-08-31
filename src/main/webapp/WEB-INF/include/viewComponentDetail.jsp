<%@page import="model.Voucher"%>
<%@ include file="/WEB-INF/include/header.jsp" %>
<c:set var="isLoggedIn" value="${not empty sessionScope.user}" />

<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<title>Chi tiết sản phẩm - <c:out value="${product.name}" default="Sản phẩm"/></title>
<%
    List<Voucher> vouchers = (List<Voucher>) request.getAttribute("vouchers");
%>

<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
    .btn { transition: background-color 0.3s ease, transform 0.2s ease; }
    .btn:hover { transform: scale(1.05); }
    .product-image { max-height: 400px; object-fit: contain; }
    .review-thumb { width: 180px; height: 180px; object-fit: cover; border-radius: 12px;
                    border: 2px solid #e5e7eb; cursor: pointer; box-shadow: 0 1px 8px #0002; }
    .review-thumb:hover { border-color: #3b82f6; box-shadow: 0 4px 20px #0003; }
    #imageModal { display:none; position:fixed; z-index:9999; top:0; left:0; width:100vw; height:100vh;
                  background:rgba(0,0,0,0.8); align-items:center; justify-content:center; }
    #imageModal img { max-width:92vw; max-height:92vh; border-radius:16px; background:#fff; box-shadow:0 0 32px #222; }
    #imageModal .close-btn { position:absolute; top:44px; right:60px; font-size:48px; font-weight:bold; color:#fff;
                             cursor:pointer; text-shadow:0 2px 8px #000; }
</style>
</head>
<body class="bg-gray-100">

<div class="container mx-auto px-4 py-8">
    <c:choose>
        <c:when test="${not empty product}">
            <div class="bg-white rounded-lg shadow-md p-6 max-w-4xl mx-auto">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                    <div class="flex justify-center">
                        <img src="${product.imageUrl}" alt="${product.name}" class="product-image w-full rounded-lg"/>
                    </div>
                    <div>
                        <h1 class="text-3xl font-bold text-gray-800 mb-4">${product.name}</h1>
                        <p class="text-gray-600 text-lg mb-4">${product.description}</p>

                        <!-- ✅ Giá format kiểu VN -->
                        <p class="text-pink-600 font-bold text-2xl mb-4">
                            <c:set var="formattedPrice">
                                <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" maxFractionDigits="0"/>
                            </c:set>
                            ${fn:replace(formattedPrice, ',', '.')} VND
                        </p>

                        <p class="text-gray-500 mb-4">Tồn kho: ${product.stock}</p>
                        <p class="text-gray-500 mb-4">Loại sản phẩm: ${product.productType}</p>
                        <p class="text-gray-500 mb-4">Danh mục ID: ${product.categoryId}</p>

                        <div class="flex space-x-4">
                            <!-- ✅ Thêm vào giỏ -->
                            <form method="post" action="${pageContext.request.contextPath}/AddToCart" class="flex-1">
                                <input type="hidden" name="productId" value="${product.productId}" />
                                <input type="hidden" name="redirect"
                                       value="${pageContext.request.contextPath}/ViewComponentDetail?productId=${product.productId}" />
                                <button type="submit"
                                        class="btn w-full bg-green-600 text-white py-2 rounded-md hover:bg-green-700">
                                    Thêm vào giỏ
                                </button>
                            </form>

                            <!-- ✅ Mua ngay -->
                            <form id="buyNowForm" method="post" action="${pageContext.request.contextPath}/checkout" class="flex-1">
                                <input type="hidden" name="productId" value="${product.productId}" />
                                <button type="button" onclick="handleBuyNow()"
                                        class="btn w-full bg-blue-600 text-white py-2 rounded-md hover:bg-blue-700">
                                    Mua ngay
                                </button>
                            </form>

                            <!-- ✅ Yêu thích -->
                            <div class="flex-1">
                                <button type="button" onclick="addToWishlist(${product.productId})"
                                        class="btn w-full bg-red-100 text-red-600 py-2 rounded-md hover:bg-red-200">
                                    <svg class="w-6 h-6 inline-block mr-1" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd"
                                              d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z"
                                              clip-rule="evenodd"/>
                                    </svg>
                                    Yêu thích
                                </button>
                            </div>
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

<!-- Voucher -->
<h3 class="text-xl font-semibold mt-8 mb-4 text-gray-800">Voucher đang có</h3>
<% if (vouchers != null && !vouchers.isEmpty()) { %>
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
    <% for (Voucher v : vouchers) {%>
    <div class="bg-white p-4 shadow-md rounded-lg border border-gray-200">
        <h4 class="text-lg font-bold text-red-600 mb-1"><%= v.getCode()%></h4>
        <p class="text-sm text-gray-700 mb-1">
            Giảm <%= v.getDiscountPercent()%>% cho đơn từ 
            <span class="font-medium">
                <%= new java.text.DecimalFormat("#,##0").format(v.getMinOrderValue()).replace(",", ".") %> VND
            </span>
        </p>
        <p class="text-xs text-gray-500">Hạn: <%= new java.text.SimpleDateFormat("dd-MM-yyyy").format(v.getExpiredAt())%></p>
        <form action="GetVoucher" method="post" class="mt-4 text-right">
            <input type="hidden" name="voucherId" value="<%= v.getVoucherId()%>">
            <button type="submit" class="px-4 py-1 bg-red-500 hover:bg-red-600 text-white text-sm rounded">
                Nhận ngay
            </button>
        </form>
    </div>
    <% } %>
</div>
<% } else { %>
<p class="text-gray-500">Hiện chưa có voucher nào khả dụng.</p>
<% }%>

<!-- Rating -->
<div class="bg-white mt-8 rounded-lg shadow-md p-6 max-w-4xl mx-auto">
    <h2 class="text-2xl font-semibold text-gray-800 mb-4">Đánh giá sản phẩm</h2>
    <c:choose>
        <c:when test="${not empty ratingList}">
            <c:forEach var="rating" items="${ratingList}">
                <div class="border-b border-gray-200 py-4 flex">
                    <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mr-4">
                        <i class="fas fa-user text-2xl text-gray-400"></i>
                    </div>
                    <div class="flex-1">
                        <div class="flex items-center mb-1">
                            <span class="font-bold text-gray-700 mr-2">${rating.userName}</span>
                            <span class="text-yellow-500 font-bold mr-2 flex">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= rating.stars}">
                                            <i class="fas fa-star mr-1"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="far fa-star mr-1"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </span>
                            <span class="text-gray-400 text-xs ml-2">
                                <fmt:formatDate value="${rating.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                            </span>
                        </div>
                        <div class="text-gray-800 mb-2">${rating.comment}</div>
                        <c:if test="${not empty rating.imageUrls}">
                            <div class="flex flex-wrap gap-3 mt-2">
                                <c:forEach var="img" items="${rating.imageUrls}">
                                    <c:if test="${not empty img}">
                                        <img src="${pageContext.request.contextPath}/${img}" class="review-thumb" onclick="showFullImage(this.src)"/>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="text-gray-500 italic">Chưa có đánh giá nào cho sản phẩm này.</div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Modal -->
<div id="imageModal">
    <span class="close-btn" onclick="closeImageModal()">&times;</span>
    <img id="fullImage" src="" />
</div>

<script>
    const isLoggedIn = "${not empty sessionScope.user}";

    function handleBuyNow() {
        if (isLoggedIn !== "true") {
            Swal.fire({icon:'info', title:'Bạn cần đăng nhập!', timer:1500, showConfirmButton:false});
            setTimeout(()=> window.location.href='${pageContext.request.contextPath}/login', 1500);
        } else {
            document.getElementById("buyNowForm").submit();
        }
    }

    function addToWishlist(productId) {
        if (isLoggedIn !== "true") {
            Swal.fire({icon:'info', title:'Bạn cần đăng nhập!', timer:1500, showConfirmButton:false});
            setTimeout(()=> window.location.href='${pageContext.request.contextPath}/login', 1500);
            return;
        }
        fetch('${pageContext.request.contextPath}/AddToWishlist?productId='+productId, {method:'POST'})
            .then(r=>r.json())
            .then(d=>{
                if(d.success){
                    Swal.fire({icon:'success', title:'Đã thêm vào yêu thích!', timer:1200, showConfirmButton:false});
                }else{
                    Swal.fire({icon:'error', title:'Không thể thêm yêu thích', text:d.message||''});
                }
            })
            .catch(e=> Swal.fire({icon:'error', title:'Lỗi', text:String(e)}));
    }

    // ✅ Popup khi thêm vào giỏ hoặc mua ngay bị max
    (function(){
        const params = new URLSearchParams(window.location.search);
        const msg = params.get("msg");
        if(!msg) return;
        if(msg==="added"){
            Swal.fire({icon:"success", title:"Đã thêm vào giỏ!", timer:1200, showConfirmButton:false});
        }else if(msg==="maxed"){
            Swal.fire({icon:"info", title:"Đã đạt số lượng tối đa!", text:"Bạn đã chọn tối đa theo tồn kho.", timer:1600, showConfirmButton:false});
        }else{
            Swal.fire({icon:"error", title:"Có lỗi xảy ra!", timer:1400, showConfirmButton:false});
        }
        const url=new URL(window.location.href);
        url.searchParams.delete("msg");
        window.history.replaceState({}, "", url.toString());
    })();

    // Modal ảnh
    function showFullImage(src){ document.getElementById("fullImage").src=src; document.getElementById("imageModal").style.display="flex"; }
    function closeImageModal(){ document.getElementById("imageModal").style.display="none"; }
</script>

<%@ include file="/WEB-INF/include/footer.jsp" %>
</body>
</html>
