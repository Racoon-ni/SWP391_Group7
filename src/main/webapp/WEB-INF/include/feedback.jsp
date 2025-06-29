<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Send Feedback</title>
</head>
<body>
    <h2>Send Feedback</h2>

    <form method="post" action="${pageContext.request.contextPath}/send-feedback">
        <label>Title:</label><br>
        <input type="text" name="title" required><br><br>

        <label>Message:</label><br>
        <textarea name="message" rows="5" cols="50" required></textarea><br><br>

        <input type="submit" value="Send Feedback">
    </form>

    <c:if test="${not empty success}">
        <p style="color:green">${success}</p>
    </c:if>
    <c:if test="${not empty error}">
        <p style="color:red">${error}</p>
    </c:if>
</body>
</html>
