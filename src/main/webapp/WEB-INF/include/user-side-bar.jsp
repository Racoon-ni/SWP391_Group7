<%@ page pageEncoding="UTF-8" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">

<style>
.user-sidebar {

    position: fixed;
    top: 80px;
    left: 0;
    width: 260px;
    height: calc(100% - 80px);
    background: linear-gradient(180deg, #2c3e50, #34495e);
    box-shadow: 3px 0 15px rgba(0, 0, 0, 0.15);
    z-index: 500; /* hạ thấp hơn modal */
    overflow-y: auto;
}




    .user-sidebar .sidebar-header {
        padding: 20px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.15);
        text-align: center;
    }

    .user-sidebar .sidebar-title {
        font-size: 1.1rem;
        font-weight: 600;
        color: #fff;
        margin: 0;
    }

    .user-sidebar .nav-link {
        display: flex;
        align-items: center;
        color: rgba(255, 255, 255, 0.85);
        padding: 12px 20px;
        border-left: 3px solid transparent;
        transition: all 0.3s ease;
        font-weight: 500;
        font-size: 0.95rem;
    }

    .user-sidebar .nav-link i {
        margin-right: 12px;
        font-size: 1rem;
        width: 20px;
        text-align: center;
        opacity: 0.9;
    }

    .user-sidebar .nav-link:hover {
        background: rgba(52, 152, 219, 0.15);
        border-left-color: #3498db;
        color: #fff;
    }

    .user-sidebar .nav-link.active {
        background: rgba(52, 152, 219, 0.25);
        border-left-color: #3498db;
        font-weight: 600;
        color: #fff;
    }

    /* Scrollbar */
    .user-sidebar::-webkit-scrollbar { width: 6px; }
    .user-sidebar::-webkit-scrollbar-thumb {
        background: rgba(255, 255, 255, 0.3);
        border-radius: 3px;
    }
    .user-sidebar::-webkit-scrollbar-thumb:hover {
        background: rgba(255, 255, 255, 0.5);
    }

    /* Responsive */
    @media (max-width: 768px) {
        .user-sidebar {
            transform: translateX(-100%);
            transition: transform 0.3s ease;
        }
        .user-sidebar.mobile-open {
            transform: translateX(0);
        }
    }
</style>

 Sidebar 
<div class="user-sidebar">
    <div class="sidebar-header">
        <h3 class="sidebar-title">Tài khoản của tôi</h3>
    </div>
    <nav class="nav flex-column">
        <a class="nav-link" href="view-profile"><i class="fa-solid fa-user"></i> Thông tin tài khoản</a>
        <a class="nav-link" href="ViewAddress"><i class="fa-solid fa-location-dot"></i> Sổ địa chỉ</a>
        <a class="nav-link" href="change-password"><i class="fa-solid fa-lock"></i> Đổi mật khẩu</a>
        <a class="nav-link" href="ViewMyVoucher"><i class="fa-solid fa-ticket"></i> Kho voucher</a>
        <a class="nav-link" href="ViewWishlist"><i class="fa-solid fa-heart"></i> Danh sách yêu thích</a>
    </nav>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const currentPath = window.location.pathname;
        document.querySelectorAll('.user-sidebar .nav-link').forEach(link => {
            const href = link.getAttribute('href');
            if (currentPath.includes(href)) {
                link.classList.add('active');
            }
        });
    });

    function toggleSidebar() {
        document.querySelector('.user-sidebar').classList.toggle('mobile-open');
    }
</script>
