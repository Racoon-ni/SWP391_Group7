<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String category = request.getParameter("category") != null ? request.getParameter("category") : "tat-ca";
    String ram = request.getParameter("ram");
    String os = request.getParameter("os");
    String brand = request.getParameter("brand");
    String ssd = request.getParameter("ssd");

    class Product {
        String name, ram, os, brand, ssd, img;
        int price;
        Product(String name, String ram, String os, String brand, String ssd, int price, String img) {
            this.name = name;
            this.ram = ram;
            this.os = os;
            this.brand = brand;
            this.ssd = ssd;
            this.price = price;
            this.img = img;
        }
    }

    java.util.ArrayList<Product> all = new java.util.ArrayList<>();
    all.add(new Product("ASUS Gaming 8GB Windows 256GB", "8GB", "Windows", "ASUS", "256GB", 12000000, "https://via.placeholder.com/300x200?text=ASUS+8GB"));
    all.add(new Product("MSI Workstation 16GB Windows 512GB", "16GB", "Windows", "MSI", "512GB", 18000000, "https://via.placeholder.com/300x200?text=MSI+16GB"));
    all.add(new Product("Macbook Pro 32GB MacOS 1TB", "32GB", "MacOS", "Apple", "1TB", 30000000, "https://via.placeholder.com/300x200?text=Macbook+32GB"));
    all.add(new Product("GIGABYTE Mini PC 8GB Windows 512GB", "8GB", "Windows", "GIGABYTE", "512GB", 10000000, "https://via.placeholder.com/300x200?text=GIGA+8GB"));
    all.add(new Product("ASUS Creator 16GB Windows 1TB", "16GB", "Windows", "ASUS", "1TB", 25000000, "https://via.placeholder.com/300x200?text=ASUS+16GB"));
    all.add(new Product("MSI Gaming 32GB Windows 1TB", "32GB", "Windows", "MSI", "1TB", 28000000, "https://via.placeholder.com/300x200?text=MSI+32GB"));
    all.add(new Product("GIGABYTE Office 16GB MacOS 256GB", "16GB", "MacOS", "GIGABYTE", "256GB", 14000000, "https://via.placeholder.com/300x200?text=GIGA+16GB"));
    all.add(new Product("ASUS Ultra 32GB Windows 1TB", "32GB", "Windows", "ASUS", "1TB", 27000000, "https://via.placeholder.com/300x200?text=ASUS+Ultra"));
    all.add(new Product("MSI Budget 8GB Windows 256GB", "8GB", "Windows", "MSI", "256GB", 9000000, "https://via.placeholder.com/300x200?text=MSI+Budget"));
    all.add(new Product("Macbook Air 16GB MacOS 512GB", "16GB", "MacOS", "Apple", "512GB", 22000000, "https://via.placeholder.com/300x200?text=Mac+16GB"));

    java.util.ArrayList<Product> filtered = new java.util.ArrayList<>();
    for (Product p : all) {
        boolean match = true;
        if (ram != null && !ram.isEmpty() && !p.ram.equalsIgnoreCase(ram)) match = false;
        if (os != null && !os.isEmpty() && !p.os.equalsIgnoreCase(os)) match = false;
        if (brand != null && !brand.isEmpty() && !p.brand.equalsIgnoreCase(brand)) match = false;
        if (ssd != null && !ssd.isEmpty() && !p.ssd.equalsIgnoreCase(ssd)) match = false;
        if (match) filtered.add(p);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title><%= category.toUpperCase() %> | Sản phẩm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
    <style>
        .product-card img { height: 180px; object-fit: cover; }
        .filter-label { font-weight: bold; margin-top: 10px; }
    </style>
</head>
<body>
<div class="container-fluid mt-4">
    <div class="row">
        <!-- FILTER -->
        <div class="col-md-3">
            <form method="get" action="products">
                <input type="hidden" name="category" value="pc">

                <label class="filter-label">RAM</label>
                <div><input type="radio" name="ram" value="8GB" <%= "8GB".equals(ram) ? "checked" : "" %>> 8GB</div>
                <div><input type="radio" name="ram" value="16GB" <%= "16GB".equals(ram) ? "checked" : "" %>> 16GB</div>
                <div><input type="radio" name="ram" value="32GB" <%= "32GB".equals(ram) ? "checked" : "" %>> 32GB</div>

                <label class="filter-label mt-3">Thương hiệu</label>
                <div><input type="radio" name="brand" value="ASUS" <%= "ASUS".equals(brand) ? "checked" : "" %>> ASUS</div>
                <div><input type="radio" name="brand" value="MSI" <%= "MSI".equals(brand) ? "checked" : "" %>> MSI</div>
                <div><input type="radio" name="brand" value="GIGABYTE" <%= "GIGABYTE".equals(brand) ? "checked" : "" %>> GIGABYTE</div>
                <div><input type="radio" name="brand" value="Apple" <%= "Apple".equals(brand) ? "checked" : "" %>> Apple</div>

                <label class="filter-label mt-3">Hệ điều hành</label>
                <div><input type="radio" name="os" value="Windows" <%= "Windows".equals(os) ? "checked" : "" %>> Windows</div>
                <div><input type="radio" name="os" value="MacOS" <%= "MacOS".equals(os) ? "checked" : "" %>> MacOS</div>

                <label class="filter-label mt-3">Dung lượng SSD</label>
                <div><input type="radio" name="ssd" value="256GB" <%= "256GB".equals(ssd) ? "checked" : "" %>> 256GB</div>
                <div><input type="radio" name="ssd" value="512GB" <%= "512GB".equals(ssd) ? "checked" : "" %>> 512GB</div>
                <div><input type="radio" name="ssd" value="1TB" <%= "1TB".equals(ssd) ? "checked" : "" %>> 1TB</div>

                <button class="btn btn-primary mt-4 w-100">Áp dụng</button>
            </form>
        </div>

        <!-- PRODUCT LIST -->
        <div class="col-md-9">
            <h4 class="mb-3">Sản phẩm phù hợp</h4>
            <div class="row g-4">
                <% if (filtered.isEmpty()) { %>
                    <div class="col-12"><div class="alert alert-warning">Không tìm thấy sản phẩm phù hợp!</div></div>
                <% } else {
                    for (Product p : filtered) { %>
                        <div class="col-md-4">
                            <div class="card product-card h-100">
                                <img src="<%= p.img %>" class="card-img-top">
                                <div class="card-body">
                                    <h6 class="card-title"><%= p.name %></h6>
                                    <p class="text-danger fw-bold"><%= String.format("%,d", p.price) %> đ</p>
                                    <p><strong>RAM:</strong> <%= p.ram %> | <strong>SSD:</strong> <%= p.ssd %></p>
                                    <p><strong>OS:</strong> <%= p.os %> | <strong>Brand:</strong> <%= p.brand %></p>
                                    <a href="#" class="btn btn-outline-primary btn-sm w-100">Thêm vào giỏ</a>
                                </div>
                            </div>
                        </div>
                <% } } %>
            </div>
        </div>
    </div>
</div>
</body>
</html>
