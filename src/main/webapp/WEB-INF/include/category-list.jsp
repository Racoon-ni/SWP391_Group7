<%-- 
    Document   : category-list
    Created on : Jul 14, 2025, 3:14:29 AM
    Author     : ThinhLVCE181726 <your.name at your.org>
--%>

<%@ page pageEncoding="UTF-8"%>
<%@ page import="model.Category" %>
<%@ page import="java.util.List" %>
        <title>Danh mục sản phẩm</title>
        <style>
            .category-carousel-container {
                position: relative;
                width: 100%;
                max-width: 1000px;
                margin: 0 auto;
                overflow: hidden;
            }
            .category-carousel {
                display: flex;
                overflow-x: auto;
                scroll-behavior: smooth;
                gap: 16px;
                padding: 16px 0;
                scrollbar-width: none;
                -ms-overflow-style: none;
            }
            .category-carousel::-webkit-scrollbar {
                display: none;
            }
            .category-card {
                flex: 0 0 150px;
                min-width: 150px;
                min-height: 180px;
                background: #fff;
                border: 1px solid #eee;
                border-radius: 16px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                display: flex;
                flex-direction: column;
                align-items: center;
                transition: box-shadow 0.2s, transform 0.2s;
                cursor: pointer;
                text-decoration: none;
                color: inherit;
            }
            .category-card:hover {
                box-shadow: 0 8px 24px rgba(0,0,0,0.10);
                transform: translateY(-4px) scale(1.03);
            }
            .category-img-bg {
                width: 100%;
                height: 90px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 0 0 0 32px;
                margin-bottom: 8px;
            }
            /* Màu pastel */
            .bg-blue {
                background: #e2eafc;
            }
            .bg-orange {
                background: #ffe5d9;
            }
            .bg-gray {
                background: #e0e1dd;
            }
            .bg-green {
                background: #d3f9d8;
            }
            .bg-yellow {
                background: #fff3cd;
            }
            .bg-pink {
                background: #ffd6e0;
            }
            .bg-cyan {
                background: #baf2ef;
            }
            .bg-brown {
                background: #f7e6d0;
            }
            .category-title {
                font-weight: 500;
                font-size: 1.1em;
                text-align: center;
                margin: 8px 0 0 0;
                min-height: 2em;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            /* Navigation buttons */
            .carousel-btn {
                position: absolute;
                top: 50%;
                transform: translateY(-50%);
                background: #fff;
                border: 1px solid #ddd;
                border-radius: 50%;
                width: 38px;
                height: 38px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
                z-index: 1;
                font-size: 22px;
                transition: background 0.2s, opacity 0.2s;
                opacity: 0.85;
            }
            .carousel-btn.left {
                left: 0;
            }
            .carousel-btn.right {
                right: 0;
            }
            .carousel-btn:disabled,
            .carousel-btn[disabled] {
                opacity: 0.3;
                cursor: not-allowed;
            }
            @media (max-width: 700px) {
                .category-card {
                    min-width: 120px;
                }
                .category-carousel-container {
                    max-width: 100vw;
                }
            }
        </style>
        <h3>Danh mục sản phẩm</h3>
        <div class="category-carousel-container">
            <button class="carousel-btn left" id="btnCatLeft" onclick="scrollCategory(-1)" aria-label="Scroll left">&lt;</button>
            <div class="category-carousel" id="categoryCarousel">
                <%
                    String[] bgColors = {"bg-blue", "bg-orange", "bg-gray", "bg-green", "bg-yellow", "bg-pink", "bg-cyan", "bg-brown"};
                    int colorIdx = 0;
                    List<Category> categories = (List<Category>) request.getAttribute("categories");
                    if (categories != null) {
                        for (Category cat : categories) {
                %>
                <!-- Bọc thẻ <a> để chuyển trang khi click -->
                <a href="product-list.jsp?categoryId=<%=cat.getCategoryId()%>" class="category-card">
                    <div class="category-img-bg <%= bgColors[colorIdx % bgColors.length]%>">
                        <span style="font-size:2em; color:#888;">
                            <%= cat.getName().substring(0, 1).toUpperCase()%>
                        </span>
                    </div>
                    <div class="category-title"><%= cat.getName()%></div>
                </a>
                <%
                            colorIdx++;
                        }
                    }
                %>
            </div>
            <button class="carousel-btn right" id="btnCatRight" onclick="scrollCategory(1)" aria-label="Scroll right">&gt;</button>
        </div>

        <script>
            function scrollCategory(direction) {
                const carousel = document.getElementById('categoryCarousel');
                const card = carousel.querySelector('.category-card');
                if (!card)
                    return;
                const cardWidth = card.offsetWidth + 16; // 16px là gap
                carousel.scrollBy({left: direction * cardWidth * 2, behavior: 'smooth'});
            }

            // Disable/enable nút khi đã tới đầu/cuối
            function updateCarouselButtons() {
                const carousel = document.getElementById('categoryCarousel');
                const btnLeft = document.getElementById('btnCatLeft');
                const btnRight = document.getElementById('btnCatRight');
                // Cách xác định đã scroll hết bên trái/phải
                btnLeft.disabled = carousel.scrollLeft <= 0;
                // Đã tới cuối
                btnRight.disabled = carousel.scrollLeft + carousel.clientWidth >= carousel.scrollWidth - 1;
            }
            // Gắn event
            document.addEventListener("DOMContentLoaded", function () {
                const carousel = document.getElementById('categoryCarousel');
                carousel.addEventListener('scroll', updateCarouselButtons);
                // Gọi lần đầu khi load
                updateCarouselButtons();
                // Đảm bảo gọi lại sau mỗi lần click scroll
                document.getElementById('btnCatLeft').onclick = function () {
                    scrollCategory(-1);
                    setTimeout(updateCarouselButtons, 400);
                };
                document.getElementById('btnCatRight').onclick = function () {
                    scrollCategory(1);
                    setTimeout(updateCarouselButtons, 400);
                };
            });
        </script>

