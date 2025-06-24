<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="header.jsp" %>

<html>
<head>
    <title>Danh sách danh mục con</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h3 class="mb-4 text-primary">Danh sách loại: ${category}</h3>

    <div class="row">
        <c:forEach var="cat" items="${componentList}">
            <div class="col-md-4 mb-3">
                <div class="card shadow-sm h-100">
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title">${cat.name}</h5>
                        <p class="card-text">Mã danh mục: ${cat.categoryId}</p>
                        <p class="card-text">Loại: ${cat.categoryType}</p>
                        <a href="ViewComponentDetail?id=${cat.categoryId}" class="btn btn-primary mt-auto">
                            Xem chi tiết
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>
