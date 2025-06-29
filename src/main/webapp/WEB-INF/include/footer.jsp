<%-- 
    Document   : footer
    Created on : Jun 17, 2025, 8:05:59 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<!-- Chat Icon -->
<div style="position: fixed; bottom: 15px; right: 25px;">
    <a href="#"><img src="${pageContext.request.contextPath}/assets/images/icon-zalo.png" alt="Chat Zalo" style="width: 80px;"></a>
</div>
    <%@include file="../include/pop-up-chat.jsp" %>
<!-- Footer Content -->
<footer class="bg-dark text-white py-4">
    <div class="container">
        <div class="row">
            <!-- About Us Section -->
            <div class="col-md-4">
                <h5>PC Store</h5>
                <p>Your one-stop shop for all PC components and pre-built PCs.</p>
            </div>
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
            <!-- Follow Us Section -->
            <div class="col-md-4">
                <h5>Follow Us</h5>
                <ul class="list-unstyled">
                    <li><a href="#" class="text-white">Facebook</a></li>
                    <li><a href="#" class="text-white">Instagram</a></li>
                    <li><a href="#" class="text-white">Twitter</a></li>
                </ul>
            </div>
        </div>
        <!-- Copyright -->
        <div class="text-center mt-4">
            <p>&copy; 2025 PC Store. All rights reserved.</p>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
