package model;

public class Product {
    private int productId;
    private String name;
    private String description;
    private double price;
    private int stock;
    private String imageUrl;
    private String productType;
    private int categoryId;
    private int status;
    private Category category;
    // getters, setters

    // --- THÊM 2 FIELD MỚI ---
    private double avgStars;      // Số sao trung bình
    private int totalRatings;     // Số lượt đánh giá

    public Product() {
    }

    public Product(int productId, String name, String description, double price, int stock, String imageUrl, String productType, int categoryId, int status) {
        this.productId = productId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.imageUrl = imageUrl;
        this.productType = productType;
        this.categoryId = categoryId;
        this.status = status;
    }

    
     public Category getCategory() {
        return category;
    }

    // Getter & Setter đầy đủ ở đây (bạn có thể sinh bằng IDE)
    public void setCategory(Category category) {    
        this.category = category;
    }

    // Getter & Setter cho avgStars, totalRatings
  
    public double getAvgStars() {
        return avgStars;
    }

    public void setAvgStars(double avgStars) {
        this.avgStars = avgStars;
    }

    public int getTotalRatings() {
        return totalRatings;
    }

    public void setTotalRatings(int totalRatings) {
        this.totalRatings = totalRatings;
    }

    // ... Các getter/setter khác giữ nguyên như cũ ...

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getProductType() {
        return productType;
    }

    public void setProductType(String productType) {
        this.productType = productType;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
