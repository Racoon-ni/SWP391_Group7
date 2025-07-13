<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="header.jsp" %>

<div class="container mt-5">
    <h3>${notification.title}</h3>
    <p class="text-muted">${notification.createdAt}</p>
    <hr/>
    <p>${notification.message}</p>
    <a href="home" class="btn btn-secondary mt-3">Về trang chủ</a>
</div>
