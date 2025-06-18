<%-- 
    Document   : drop-down
    Created on : Jun 17, 2025, 8:28:36 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@ page pageEncoding="UTF-8" %>
<style>


    .custom-dropdown {
        position: relative;
        width: 180px;
        margin: 0 auto;
    }

    .dropdown-button {
        width: 126%;
        background-color: white;
        cursor: pointer;
        display: flex;
        justify-content: space-between; /* Center content horizontally */
        align-items: center;

    }

    .arrow {
        border: solid black;
        border-width: 0 3px 3px 0;
        display: inline-block;
        padding: 3px;
        margin-bottom: 5px;
    }


    .down {
        transform: rotate(45deg);
        -webkit-transform: rotate(45deg);
    }

    .dropdown-menu {
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        background: white;
        border: 1px solid #ccc;
        display: none;
        flex-direction: column;
        z-index: 10;
    }

    .dropdown-menu label {
        padding: 10px;
        cursor: pointer;
    }

    .dropdown-menu label:hover {
        background-color: #f0f0f0;
    }

    input[type="checkbox"] {
        margin-right: 8px;
    }

    .custom-dropdown.open .dropdown-menu {
        display: flex;
    }

    .category-title {
        margin-left: -46px;
    }
</style>

<hr>
<div class="custom-dropdown">
    <div class="dropdown-button" onclick="toggleDropdown(this)">
        <span class="category-title">Thương hiệu</span>
        <span class="arrow down"></span>
    </div>
    <div class="dropdown-menu">
        <label><input type="checkbox" name="brand" value="apple"> Apple</label>
        <label><input type="checkbox" name="brand" value="samsung"> Samsung</label>
    </div>
</div>

<hr>
<div class="custom-dropdown">
    <div class="dropdown-button" onclick="toggleDropdown(this)">
        <span class="category-title">Loại hàng</span>
        <span class="arrow down"></span>
    </div>
    <div class="dropdown-menu">
        <label><input type="checkbox" name="type" value="laptop"> Laptop</label>
        <label><input type="checkbox" name="type" value="tablet"> Tablet</label>
    </div>
</div>

<hr>
<div class="custom-dropdown">
    <div class="dropdown-button" onclick="toggleDropdown(this)">
        <span class="category-title">Series</span>
        <span class="arrow down"></span>
    </div>
    <div class="dropdown-menu">
        <label><input type="checkbox" name="type" value="laptop"> Laptop</label>
        <label><input type="checkbox" name="type" value="tablet"> Tablet</label>
    </div>
</div>

<hr>
<div class="custom-dropdown">
    <div class="dropdown-button" onclick="toggleDropdown(this)">
        <span class="category-title">Nhu cầu</span>
        <span class="arrow down"></span>
    </div>
    <div class="dropdown-menu">
        <label><input type="checkbox" name="type" value="laptop"> Laptop</label>
        <label><input type="checkbox" name="type" value="tablet"> Tablet</label>
    </div>
</div>

<hr>
<div class="custom-dropdown">
    <div class="dropdown-button" onclick="toggleDropdown(this)">
        <span class="category-title">PC Segment</span>
        <span class="arrow down"></span>
    </div>
    <div class="dropdown-menu">
        <label><input type="checkbox" name="type" value="laptop"> Laptop</label>
        <label><input type="checkbox" name="type" value="tablet"> Tablet</label>
    </div>
</div>

<hr>
<div class="custom-dropdown">
    <div class="dropdown-button" onclick="toggleDropdown(this)">
        <span class="category-title">Series CPU</span>
        <span class="arrow down"></span>
    </div>
    <div class="dropdown-menu">
        <label><input type="checkbox" name="type" value="laptop"> Laptop</label>
        <label><input type="checkbox" name="type" value="tablet"> Tablet</label>
    </div>
</div>

<hr>
<div class="custom-dropdown">
    <div class="dropdown-button" onclick="toggleDropdown(this)">
        <span class="category-title">Thế hệ</span>
        <span class="arrow down"></span>
    </div>
    <div class="dropdown-menu">
        <label><input type="checkbox" name="type" value="laptop"> Laptop</label>
        <label><input type="checkbox" name="type" value="tablet"> Tablet</label>
    </div>
</div>

<hr>
<div class="custom-dropdown">
    <div class="dropdown-button" onclick="toggleDropdown(this)">
        <span class="category-title">RAM</span>
        <span class="arrow down"></span>
    </div>
    <div class="dropdown-menu">
        <label><input type="checkbox" name="type" value="laptop"> Laptop</label>
        <label><input type="checkbox" name="type" value="tablet"> Tablet</label>
    </div>
</div>

<hr>
<div class="custom-dropdown">
    <div class="dropdown-button" onclick="toggleDropdown(this)">
        <span class="category-title">Đồ họa rời</span>
        <span class="arrow down"></span>
    </div>
    <div class="dropdown-menu">
        <label><input type="checkbox" name="type" value="laptop"> Laptop</label>
        <label><input type="checkbox" name="type" value="tablet"> Tablet</label>
    </div>
</div>

<hr>
<div class="custom-dropdown">
    <div class="dropdown-button" onclick="toggleDropdown(this)">
        <span class="category-title">Dung lượng SSD</span>
        <span class="arrow down"></span>
    </div>
    <div class="dropdown-menu">
        <label><input type="checkbox" name="type" value="laptop"> Laptop</label>
        <label><input type="checkbox" name="type" value="tablet"> Tablet</label>
    </div>
</div>

<hr>
<div class="custom-dropdown">
    <div class="dropdown-button" onclick="toggleDropdown(this)">
        <span class="category-title">Hệ điều hành</span>
        <span class="arrow down"></span>
    </div>
    <div class="dropdown-menu">
        <label><input type="checkbox" name="type" value="laptop"> Laptop</label>
        <label><input type="checkbox" name="type" value="tablet"> Tablet</label>
    </div>
</div>
<script>
    function toggleDropdown(button) {
        const dropdown = button.closest(".custom-dropdown");
        dropdown.classList.toggle("open");
    }

// Close all dropdowns if clicking outside
    window.addEventListener('click', function (e) {
        document.querySelectorAll(".custom-dropdown").forEach(dropdown => {
            if (!dropdown.contains(e.target)) {
                dropdown.classList.remove("open");
            }
        });
    });
</script>