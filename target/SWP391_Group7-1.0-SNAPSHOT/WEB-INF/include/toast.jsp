<%-- 
    Document   : toast
    Created on : Jun 24, 2025, 5:02:28 PM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    .toast-progress {
        height: 4px;
        background-color: rgba(255, 255, 255, 0.75);
        width: 0%;
        animation: toastProgress 3s linear forwards;
    }

    @keyframes toastProgress {
        from {
            width: 0%;
        }
        to {
            width: 100%;
        }
    }
</style>
<div class="toast-container position-fixed top-0 start-50 translate-middle-x p-5" style="z-index: 1100;">
    <div id="myToast" class="toast align-items-center 
         <c:if test="${not empty requestScope.error}">text-bg-danger </c:if>  
         <c:if test="${not empty requestScope.success}">text-bg-success </c:if>  
         border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">
             <c:if test="${not empty requestScope.error}">${requestScope.error}</c:if> 
             <c:if test="${not empty requestScope.success}">${requestScope.success}</c:if> 
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <!-- Progress Bar -->
        <div class="toast-progress"></div>
    </div>
</div>

<!-- Script to Show Toast -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const toastEl = document.getElementById('myToast');
        const toast = new bootstrap.Toast(toastEl, {
            delay: 3000 // 3 seconds
        });

        toastEl.querySelector('.toast-progress').style.animation = 'toastProgress 3s linear forwards';
        toast.show();
    });
</script>

