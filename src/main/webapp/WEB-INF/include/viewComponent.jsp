<%@ include file="/WEB-INF/include/header.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Product" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
</head>
<body>
    <h2>Danh Sách ${category}</h2>
    <div class="pc-container">
        <c:choose>
            <c:when test="${empty componentList}">
                <div class="no-pc">Không có sản phẩm nào trong danh mục này.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="pc" items="${componentList}">
                    <div class="pc-card">
                        <img class="pc-img" src="${pc.imageUrl == null ? 'images/default-pc.png' : 'images/' += pc.imageUrl}" alt="${pc.name}" />
                        <div class="pc-title">${pc.name}</div>
                        <div class="pc-desc">${pc.description}</div>
                        <div class="pc-price">${pc.price} USD</div>
                        <div class="pc-stock">Tồn kho: ${pc.stock}</div>

                        <div class="rating-info">
                            <c:choose>
                                <c:when test="${pc.totalRatings > 0}">
                                    <c:set var="avg" value="${pc.avgStars}" />
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
                                    <span style="margin-left: 4px; font-weight: bold;">
                                        ${String.format("%.1f", avg)} / 5
                                    </span>
                                    <span style="color: gray;">(${pc.totalRatings} đánh giá)</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: gray;">Chưa có đánh giá</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="btn-row">
                            <a class="pc-detail-btn blue" href="ViewComponentDetail?productId=${pc.productId}">Xem chi tiết</a>
                            <button type="submit" class="pc-detail-btn green">Thêm vào giỏ</button>
                            <button class="btn-wish" title="Yêu thích"><i class="fa fa-heart"></i></button>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
