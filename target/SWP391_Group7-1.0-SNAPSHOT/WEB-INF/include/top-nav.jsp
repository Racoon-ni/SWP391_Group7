<%-- 
    Document   : top-nav
    Created on : Jun 18, 2025, 12:06:55 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@ page pageEncoding="UTF-8" %>
<style>
    /* The Modal (background) */
    .modal {
        display: none; /* Hidden by default */
        position: fixed; /* Stay in place */
        z-index: 1; /* Sit on top */
        padding-top: 100px; /* Location of the box */
        left: 0;
        top: 0;
        width: 100%; /* Full width */
        height: 100%; /* Full height */
        overflow: auto; /* Enable scroll if needed */
        background-color: rgb(0,0,0); /* Fallback color */
        background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
    }

    /* Modal Content */
    .modal-content {
        background-color: #fefefe;
        margin-left: 210px;
        padding: 20px 20px 20px 32px;
        border: 2px solid black;
        max-width: 240px;
        border-radius: 14px;
    }

    /* The Close Button */
    .close {
        color: white;
        float: right;
        font-size: 0px;
    }

    .close:hover,
    .close:focus {
        color: #000;
        text-decoration: none;
        cursor: pointer;
    }
    ul.no-bullets {
        list-style-type: none; /* Remove bullets */
        padding: 0; /* Remove padding */
        margin: 0; /* Remove margins */
    }
    .button {
        background-color: white;
        border-style: none;
    }
</style>
</head>
<body>

    <!-- Trigger/Open The Modal -->
    <button class="button" id="myBtn">
        <img src="${pageContext.request.contextPath}/assets/images/icons8-view-headline-50.png" alt="modal" style="margin-right: 10px;"/>
    </button>

   <!-- The Modal -->
    <div id="myModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <ul class="no-bullets">
                <li><a href="${pageContext.request.contextPath}/ViewComponent?category=PC">PC - Máy tính bàn</a></li>
                <li><a href="${pageContext.request.contextPath}/ViewComponent?category=CPU">CPU (Bộ vi xử lý)</a></li>
                <li><a href="${pageContext.request.contextPath}/ViewComponent?category=Mainboard">Mainboard (Bo mạch chủ)</a></li>
                <li><a href="${pageContext.request.contextPath}/ViewComponent?category=RAM">RAM (Bộ nhớ tạm)</a></li>
                <li><a href="${pageContext.request.contextPath}/ViewComponent?category=Storage">Ổ cứng (SSD/HDD)</a></li>
                <li><a href="${pageContext.request.contextPath}/ViewComponent?category=GPU">GPU (Card màn hình)</a></li>
                <li><a href="${pageContext.request.contextPath}/ViewComponent?category=PSU">PSU (Bộ nguồn)</a></li>
                <li><a href="${pageContext.request.contextPath}/ViewComponent?category=Cooling">Tản nhiệt (Cooling)</a></li>
                <li><a href="${pageContext.request.contextPath}/ViewComponent?category=Monitor">Màn hình (Monitor)</a></li>
                <li><a href="${pageContext.request.contextPath}/ViewComponent?category=KeyboardMouse">Bàn phím và Chuột</a></li>
                <li><a href="${pageContext.request.contextPath}/ViewComponent?category=Case">Vỏ máy (Case)</a></li>
            </ul>
        </div>
    </div>
    <script>
        // Get the modal
        var modal = document.getElementById("myModal");

        // Get the button that opens the modal
        var btn = document.getElementById("myBtn");

        // Get the <span> element that closes the modal
        var span = document.getElementsByClassName("close")[0];

        // When the user clicks the button, open the modal 
        btn.onclick = function () {
            modal.style.display = "block";
        };

        // When the user clicks on <span> (x), close the modal
        span.onclick = function () {
            modal.style.display = "none";
        };

        // When the user clicks anywhere outside of the modal, close it
        window.onclick = function (event) {
            if (event.target === modal) {
                modal.style.display = "none";
            }
        };
    </script>