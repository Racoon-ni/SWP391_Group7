<%-- 
    Document   : footer
    Created on : Jun 17, 2025, 8:05:59 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>
<%@ page pageEncoding="UTF-8" %>
<!-- Chat Icon -->
<div style="position: fixed; bottom: 15px; right: 25px;">
    <a href="#"><img src="${pageContext.request.contextPath}/assets/images/icon-zalo.png" alt="Chat Zalo" style="width: 80px;"></a>
</div>
    <%@include file="../include/pop-up-chat.jsp" %>
<!-- Footer Content -->
<footer class="text-white pt-5 pb-4" style="background-color: #121212;">
    <div class="container text-md-left">
        <div class="row text-md-left">

            <!-- Quick Links -->
            <div class="col-md-4 col-lg-4 col-xl-4 mx-auto mt-3">
                <h5 class="text-uppercase mb-4 font-weight-bold text-info">Liên kết nhanh</h5>
                <p><a href="/about-us" class="text-white text-decoration-none">Giới thiệu</a></p>
                <p><a href="/warranty-policy" class="text-white text-decoration-none">Chính sách bảo hành</a></p>
             
            </div>

            <!-- Contact Info -->
            <div class="col-md-4 col-lg-4 col-xl-4 mx-auto mt-3">
                <h5 class="text-uppercase mb-4 font-weight-bold text-info">Thông tin liên hệ</h5>
                <p><i class="fas fa-map-marker-alt me-3 text-info"></i> 600 Nguyễn Văn Cừ Nối Dài, An Bình, Bình Thủy, Cần Thơ 900000, Vietnam</p>
                <p><i class="fas fa-phone me-3 text-info"></i> 0765 931 799</p>
                <p><i class="fas fa-envelope me-3 text-info"></i>tuongnghi04@gmail.com</p>
            <!-- Quick Links Section -->
            <div class="col-md-4">
                <h5>Quick Links</h5>
                <ul class="list-unstyled">
                    <li><a href="/about-us" class="text-white">About Us</a></li>
                    <li><a href="/contact-us" class="text-white">Contact Us</a></li>
                    <li><a href="/privacy-policy" class="text-white">Privacy Policy</a></li>
                    <li><a href="/terms" class="text-white">Terms & Conditions</a></li>
                    <li><a href="${pageContext.request.contextPath}/sendFeedback" class="text-white">Send Feedback</a></li>
                </ul>
            </div>

            <!-- Social Media -->
            <div class="col-md-4 col-lg-4 col-xl-4 mx-auto mt-3">
                <h5 class="text-uppercase mb-4 font-weight-bold text-info">Kết nối với chúng tôi</h5>
                <a href="https://www.facebook.com/share/16hRLT3keT/?mibextid=wwXIfr" class="text-white me-4"><i class="fab fa-facebook fa-lg"></i></a>
                <a href="#" class="text-white me-4"><i class="fab fa-youtube fa-lg"></i></a>
                <a href="#" class="text-white me-4"><i class="fab fa-instagram fa-lg"></i></a>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col text-center">
                <p class="text-white mb-0">© 2025 PC Store. All rights reserved.</p>
            </div>
        </div>
    </div>
</footer>

