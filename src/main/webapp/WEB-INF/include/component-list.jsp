<%-- 
    Document   : pc-list
    Created on : Jun 18, 2025, 8:50:06 PM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@page import="model.Component"%>
<%@page import="java.util.ArrayList"%>
<%@ page pageEncoding="UTF-8" %>
<%@include file="../include/admin-side-bar.jsp" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<title>Components List</title>

<%
    ArrayList<Component> componentList = (ArrayList<Component>) request.getAttribute("componentList");
%>


<div class="main-content">
    <div class="d-flex justify-content-end">
        <a href="${pageContext.request.contextPath}/manage-component?view=add" class="btn btn-success">
            <i class="fa-solid fa-square-plus"></i> Thêm Linh Kiện
        </a>
    </div>
    <%
        if (!componentList.isEmpty() && componentList != null) {
    %>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th scope="col" style="text-align: center">ID</th>
                <th scope="col">Tên</th>
                <th scope="col">Mô tả</th>
                <th scope="col">Giá</th>
                <th scope="col">Tồn kho</th>
                <th scope="col">Ảnh</th>
                <th scope="col">Trạng thái</th>
                <th>
                    Thể loại
                    <form id ="filterForm" action="${pageContext.request.contextPath}/manage-component" method="GET" style="display: inline;">
                        <button type="button" onclick="showDropdown()" style="background: none; border: none; cursor: pointer;">
                            <i class="fa fa-filter"></i> <!-- FontAwesome icon, or use 🔍 -->
                        </button>


                        <!-- Hidden select -->
                        <select name="cateId" id="categorySelect" style="display: none;" onchange="document.getElementById('filterForm').submit()">
                            <option value="">-- Chọn --</option>
                            <c:if test="${not empty cateList}">
                                <c:forEach items="${cateList}" var="cate">
                                    <c:if test="${cate.categoryType == 'Component'}">
                                        <option value="${cate.categoryId}"
                                                <c:if test="${not empty pc && pc.category.categoryId == cate.categoryId}">selected</c:if>>
                                            ${cate.name}
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </select>
                    </form>
                </th>
                <th scope="col" style="text-align: center">Chức năng</th>
            </tr>
        </thead>
        <tbody class="table-group-divider">
            <%
                for (Component comp : componentList) {
            %>
            <tr>
                <th scope="row" style="text-align: center"><%= comp.getId()%></th>
                <td scope="row"><%= comp.getName()%></td>
                <td><%= comp.getDescription()%></td>
                <td><%= comp.getPrice()%></td>
                <td><%= comp.getStock()%></td>
                <td><%= comp.getImageUrl()%></td>
                <td><%= comp.isStatus() ? "Còn bán" : "Hết hàng"%></td>
                <td><%= comp.getCategory().getName()%></td>
                <td class="d-flex justify-content-center gap-2" style="text-align: center">

                    <a href="${pageContext.request.contextPath}/manage-component?view=edit&id=<%= comp.getId()%>" class="btn btn-warning">
                        <i class="fa-solid fa-pen-to-square"></i>
                    </a>



                    <!-- Delete button for each PC -->
                    <a href="#" class="btn btn-danger" data-bs-toggle="modal"
                       data-bs-target="#deleteModal"
                       data-pcid="<%= comp.getId()%>">
                        <i class="fa-solid fa-trash"></i>
                    </a>



                </td>

            </tr>
            <%
                }
            } else {
            %>
        </tbody>
    </table>
    <p>Không có linh kiện nào trong danh sách này</p>
    <%
        }
    %>
    <c:if test="${not empty param.cateId}">
        <div style="    position: absolute; top: 20px;">
            <button type="button" class="btn btn-danger" onclick="clearFilter()">
                <i class="fa-solid fa-delete-left"></i> Xóa lọc
            </button>
        </div>
    </c:if>

</div>
<!-- One shared modal -->
<%@ include file="delete-component.jsp" %>

<script>
    function showDropdown() {
        const select = document.getElementById('categorySelect');
        select.style.display = 'block'; // or 'block' if needed
        select.focus();

        // Delay to prevent immediate close
        setTimeout(() => {
            function handleOutsideClick(event) {
                if (!select.contains(event.target)) {
                    select.style.display = 'none';
                    document.removeEventListener('click', handleOutsideClick);
                }
            }
            document.addEventListener('click', handleOutsideClick);
        }, 0);
    }

    function clearFilter() {
        const select = document.getElementById('categorySelect');
        select.value = '';
        document.getElementById('filterForm').submit();
    }
</script>


