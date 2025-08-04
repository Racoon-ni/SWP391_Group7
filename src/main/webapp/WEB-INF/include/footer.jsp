<%@ page pageEncoding="UTF-8" %>

<!-- Chat Icon -->
<div style="position: fixed; bottom: 15px; right: 25px; z-index: 1000;">
    <a href="#"><img src="${pageContext.request.contextPath}/assets/images/icon-zalo.png" alt="Chat Zalo" style="width: 80px;"></a>
</div>
<%@include file="../include/pop-up-chat.jsp" %>

<!-- Footer Content -->
<footer class="text-white pt-5 pb-4" style="background-color: #121212;">
    <div class="container text-md-left">
        <div class="row">

            <!-- Quick Links -->
            <div class="col-md-3 col-lg-3 col-xl-3 mx-auto mt-3">
                <h5 class="text-uppercase mb-4 font-weight-bold text-info">Liên kết nhanh</h5>
                <p><a href="/about-us" class="text-white text-decoration-none">Giới thiệu</a></p>
                <p><a href="/warranty-policy" class="text-white text-decoration-none">Chính sách bảo hành</a></p>
            </div>

            <!-- Contact Info -->
            <div class="col-md-3 col-lg-3 col-xl-3 mx-auto mt-3">
                <h5 class="text-uppercase mb-4 font-weight-bold text-info">Liên hệ</h5>
                <p><i class="fas fa-map-marker-alt me-2 text-info"></i> 600 Nguyễn Văn Cừ Nối Dài, Cần Thơ</p>
                <p><i class="fas fa-phone me-2 text-info"></i> 0765 931 799</p>
                <p><i class="fas fa-envelope me-2 text-info"></i> tuongnghi04@gmail.com</p>
            </div>

            <!-- Social Media -->
            <div class="col-md-3 col-lg-3 col-xl-3 mx-auto mt-3">
                <h5 class="text-uppercase mb-4 font-weight-bold text-info">Kết nối</h5>
                <a href="https://www.facebook.com/share/16hRLT3keT/?mibextid=wwXIfr" class="text-white me-3"><i class="fab fa-facebook fa-lg"></i></a>
                <a href="#" class="text-white me-3"><i class="fab fa-youtube fa-lg"></i></a>
                <a href="#" class="text-white me-3"><i class="fab fa-instagram fa-lg"></i></a>
            </div>

            <!-- Feedback -->
            <div class="col-md-3 col-lg-3 col-xl-3 mx-auto mt-3">
                <h5 class="text-uppercase mb-4 font-weight-bold text-info">Góp ý</h5>
                <p>Nếu bạn có bất kỳ phản hồi hoặc đề xuất nào, hãy gửi cho chúng tôi:</p>

                <a href="${pageContext.request.contextPath}/sendFeedback" class="btn btn-outline-info btn-sm" style="margin-top: 10px">
                    Send Feedback
                </a>


            </div>
        </div>

        <!-- Footer Bottom -->
        <div class="row mt-4">
            <div class="col text-center">
                <p class="text-white mb-0">© 2025 PC Store. All rights reserved.</p>
            </div>
        </div>
    </div>
</footer>