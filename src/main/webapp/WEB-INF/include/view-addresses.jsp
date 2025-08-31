<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="../include/header.jsp" %>

<html>
<head>
    <title>Quản lý địa chỉ</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">

    <style>
        :root{
            --brand:#0d6efd;
            --muted:#6c757d;
            --ok:#28a745;
            --danger:#dc3545;
            --bg:#f5f7fb;
            --card:#ffffff;
        }
        body{font-family:system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;background:var(--bg)}
        .container-page{
            max-width: 980px;
            margin: 84px auto 48px auto;
            padding: 0 16px;
        }
        h1.page-title{
            font-weight: 800;
            letter-spacing: .2px;
        }

        /* ===== Address card ===== */
        .addr-card{
            border:1px solid #e9ecef;
            border-radius:16px;
            background:var(--card);
            box-shadow: 0 6px 20px rgba(13,110,253,.06);
            transition: transform .2s ease, box-shadow .2s ease, border-color .2s;
        }
        .addr-card:hover{
            transform: translateY(-2px);
            box-shadow: 0 10px 26px rgba(13,110,253,.10);
            border-color:#dfe6f5;
        }
        .addr-card.default{
            border-color: rgba(13,110,253,.35);
            box-shadow: 0 12px 28px rgba(13,110,253,.12);
        }
        .addr-head{
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:12px;
            margin-bottom:.35rem;
        }
        .addr-name{
            margin:0;
            font-weight:700;
            font-size:1.05rem;
        }
        .badge-default{
            background: linear-gradient(135deg, var(--brand), #4f8bff);
            border:none;
        }
        .top-actions .btn-warning{
            --bs-btn-bg:#f59e0b;
            --bs-btn-border-color:#f59e0b;
            --bs-btn-hover-bg:#d97706;
            --bs-btn-hover-border-color:#d97706;
            color:#fff;
            padding: .35rem .6rem;
            border-radius:10px;
            box-shadow: 0 4px 12px rgba(245,158,11,.25);
        }

        /* ===== Pretty form rows (label left – input right) ===== */
        .form-row{
            display:grid;
            grid-template-columns: 160px 1fr;
            gap:14px;
            align-items:center;
            margin-bottom:14px;
        }
        .form-row label{
            margin:0;
            font-weight:600;
            color:#343a40;
        }
        .form-control{
            border-radius:12px;
            padding:.6rem .9rem;
            border:1px solid #e5e7eb;
        }
        .form-control:focus{
            border-color: var(--brand);
            box-shadow: 0 0 0 .2rem rgba(13,110,253,.15);
        }
        .form-hint{font-size:.85rem;color:var(--muted);margin-top:4px}

        /* ===== Modal ===== */
        .modal{
            display:none; position:fixed; inset:0;
            background:rgba(17,24,39,.45);
            z-index:1000;
            padding: 32px 16px;
            align-items:center; justify-content:center;
        }
        .modal-content{
            background:var(--card);
            width:min(560px, 92vw);
            border-radius:16px;
            padding:20px 20px 16px 20px;
            box-shadow: 0 24px 64px rgba(0,0,0,.18);
            transform:translateY(12px);
            opacity:0;
            transition: all .18s ease;
        }
        .modal.show .modal-content{
            transform:none; opacity:1;
        }
        .modal-title{
            font-weight:800; margin:0 0 10px 0; color:#111827;
        }

        /* ===== Buttons ===== */
        .btn-action{
            display:inline-flex; gap:.5rem; align-items:center; justify-content:center;
            border-radius:12px; padding:.65rem .9rem; font-weight:600;
        }
        .btn-save{
            background: linear-gradient(135deg, #22c55e, #16a34a);
            color:#fff; border:none;
            box-shadow: 0 10px 24px rgba(34,197,94,.25);
        }
        .btn-save:hover{filter:brightness(.97)}
        .btn-cancel{
            background:#f1f5f9; color:#0f172a; border:1px solid #e2e8f0;
        }
        .btn-cancel:hover{background:#e9eef5}

        .stack-12>*+*{margin-top:12px}
        .stack-8>*+*{margin-top:8px}

        /* Small screens */
        @media (max-width: 576px){
            .form-row{grid-template-columns: 1fr; gap:6px}
        }
    </style>
</head>
<body>

<%@ include file="../include/user-side-bar.jsp" %>

<div class="container-page">
    <div class="d-flex align-items-center justify-content-between mb-3">
        <h1 class="page-title text-primary m-0">Quản lý địa chỉ</h1>
        <button class="btn btn-primary rounded-3 shadow-sm" onclick="openModal('addAddressModal')">
             Thêm địa chỉ mới
        </button>
    </div>

    <c:if test="${not empty message}">
        <div class="alert alert-info rounded-3 shadow-sm">${message}</div>
    </c:if>

    <p class="text-muted mb-3">Tổng: <strong>${fn:length(addressList)}</strong> địa chỉ</p>

    <c:choose>
        <c:when test="${empty addressList}">
            <div class="alert alert-warning rounded-3 shadow-sm">Không có địa chỉ nào!</div>
        </c:when>
        <c:otherwise>
            <div class="stack-12">
                <c:forEach var="addr" items="${addressList}">
                    <div class="addr-card ${addr.defaultAddress ? 'default' : ''}">
                        <div class="p-3 p-md-4">
                            <div class="addr-head">
                                <div class="d-flex align-items-center flex-wrap gap-2">
                                    <h5 class="addr-name">${addr.fullName}</h5>
                                    <c:if test="${addr.defaultAddress}">
                                        <span class="badge badge-default">Địa chỉ mặc định</span>
                                    </c:if>
                                </div>
                                <div class="top-actions">
                                    <button type="button"
                                            class="btn btn-warning btn-sm edit-btn-trigger"
                                            title="Sửa địa chỉ"
                                            data-id="${addr.id}"
                                            data-name="${fn:escapeXml(addr.fullName)}"
                                            data-phone="${addr.phone}"
                                            data-address="${fn:escapeXml(addr.specificAddress)}"
                                            data-default="${addr.defaultAddress}">
                                        Sửa
                                    </button>
                                </div>
                            </div>

                            <div class="text-muted small mb-3">
                                <div><strong>SDT:</strong> <span class="text-dark">${addr.phone}</span></div>
                                <div><strong>Địa chỉ:</strong> <span class="text-dark">${addr.specificAddress}</span></div>
                            </div>

                            <div class="d-flex flex-wrap gap-2">
                                <!-- Đặt mặc định -->
                                <form method="post" action="${pageContext.request.contextPath}/ViewAddress" class="m-0">
                                    <input type="hidden" name="action" value="setDefault" />
                                    <input type="hidden" name="addressId" value="${addr.id}" />
                                    <input type="hidden" name="from"   value="${param.from}" />
                                    <input type="hidden" name="return" value="${param['return']}" />
                                    <button type="submit" class="btn btn-outline-primary btn-sm rounded-3"
                                            <c:if test="${addr.defaultAddress}">disabled</c:if>>
                                        Đặt làm mặc định
                                    </button>
                                </form>

                                <!-- Xóa -->
                                <form method="post" action="${pageContext.request.contextPath}/ViewAddress"
                                      onsubmit="return confirm('Bạn có chắc chắn muốn xóa địa chỉ này?');" class="m-0">
                                    <input type="hidden" name="action" value="delete" />
                                    <input type="hidden" name="addressId" value="${addr.id}" />
                                    <input type="hidden" name="from"   value="${param.from}" />
                                    <input type="hidden" name="return" value="${param['return']}" />
                                    <button type="submit" class="btn btn-outline-danger btn-sm rounded-3">Xóa</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- =================== Modal: Thêm địa chỉ =================== -->
<div class="modal" id="addAddressModal" aria-hidden="true">
    <div class="modal-content">
        <h4 class="modal-title">Thêm địa chỉ mới</h4>
        <form method="post" action="${pageContext.request.contextPath}/ViewAddress" class="mt-3">
            <input type="hidden" name="action" value="add" />
            <input type="hidden" name="from"   value="${param.from}" />
            <input type="hidden" name="return" value="${param['return']}" />

            <div class="form-row">
                <label>Họ và tên</label>
                <div>
                    <input type="text" class="form-control" name="fullName" placeholder="Ví dụ: Nguyễn Văn A" required />
                </div>
            </div>

            <div class="form-row">
                <label>Số điện thoại</label>
                <div>
                    <input type="text" class="form-control" name="phone" placeholder="Chỉ nhập số"
                           required oninput="this.value=this.value.replace(/[^0-9]/g,'')" />
                    <div class="form-hint">VD: 0901234567</div>
                </div>
            </div>

            <div class="form-row">
                <label>Địa chỉ cụ thể</label>
                <div>
                    <input type="text" class="form-control" name="specificAddress"
                           placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành"
                           required />
                    <div class="form-hint">Nhập càng chi tiết càng tốt để giao nhanh hơn.</div>
                </div>
            </div>

            <div class="form-row">
                <label class="mb-0">Mặc định</label>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" name="defaultAddress" id="defaultAddress">
                    <label class="form-check-label" for="defaultAddress">Đặt làm địa chỉ mặc định</label>
                </div>
            </div>

            <div class="d-grid gap-2 mt-3">
                <button type="submit" class="btn-action btn-save">Lưu địa chỉ</button>
                <button type="button" class="btn-action btn-cancel" onclick="closeModal('addAddressModal')">Hủy</button>
            </div>
        </form>
    </div>
</div>

<!-- =================== Modal: Sửa địa chỉ =================== -->
<div class="modal" id="editAddressModal" aria-hidden="true">
    <div class="modal-content">
        <h4 class="modal-title">Sửa địa chỉ</h4>
        <form method="post" action="${pageContext.request.contextPath}/ViewAddress" class="mt-3">
            <input type="hidden" name="action" value="edit" />
            <input type="hidden" name="addressId" id="editAddressId" />
            <input type="hidden" name="from"   value="${param.from}" />
            <input type="hidden" name="return" value="${param['return']}" />

            <div class="form-row">
                <label>Họ và tên</label>
                <div>
                    <input type="text" class="form-control" name="fullName" id="editFullName" required />
                </div>
            </div>

            <div class="form-row">
                <label>Số điện thoại</label>
                <div>
                    <input type="text" class="form-control" name="phone" id="editPhone" required
                           oninput="this.value=this.value.replace(/[^0-9]/g,'')" />
                </div>
            </div>

            <div class="form-row">
                <label>Địa chỉ cụ thể</label>
                <div>
                    <input type="text" class="form-control" name="specificAddress" id="editSpecificAddress" required />
                </div>
            </div>

            <div class="form-row">
                <label class="mb-0">Mặc định</label>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" name="defaultAddress" id="editDefaultAddress">
                    <label class="form-check-label" for="editDefaultAddress">Đặt làm địa chỉ mặc định</label>
                </div>
            </div>

            <div class="d-grid gap-2 mt-3">
                <button type="submit" class="btn-action btn-save">Cập nhật</button>
                <button type="button" class="btn-action btn-cancel" onclick="closeModal('editAddressModal')">Hủy</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openModal(id){
        var m = document.getElementById(id);
        if(!m) return;
        m.classList.add('show');
        m.style.display = 'flex';
    }
    function closeModal(id){
        var m = document.getElementById(id);
        if(!m) return;
        m.classList.remove('show');
        // chờ animation nhẹ rồi ẩn
        setTimeout(function(){ m.style.display='none'; }, 120);
    }

    // click ra ngoài để đóng
    window.addEventListener('click', function(e){
        var addM = document.getElementById('addAddressModal');
        var editM = document.getElementById('editAddressModal');
        if(e.target === addM)  closeModal('addAddressModal');
        if(e.target === editM) closeModal('editAddressModal');
    });

    // Gán dữ liệu & mở modal Sửa
    document.addEventListener('DOMContentLoaded', function(){
        var triggers = document.querySelectorAll('.edit-btn-trigger');
        for (var i=0;i<triggers.length;i++){
            triggers[i].addEventListener('click', function(){
                document.getElementById('editAddressId').value       = this.dataset.id || '';
                document.getElementById('editFullName').value        = this.dataset.name || '';
                document.getElementById('editPhone').value           = this.dataset.phone || '';
                document.getElementById('editSpecificAddress').value = this.dataset.address || '';
                document.getElementById('editDefaultAddress').checked = (this.dataset.default === 'true');
                openModal('editAddressModal');
            });
        }
    });
</script>

</body>
</html>
