package model;

import java.util.Date;

public class Order {

    private int orderId;
    private int userId;
    private String status;
    private double totalPrice;
    private Date createdAt;

    // === Thêm thuộc tính này ===
    private ShippingInfo shippingInfo;
    private String productsJson; // Thêm dòng này vào class

    public Order(int orderId, int userId, String status, double totalPrice, Date createdAt) {
        this.orderId = orderId;
        this.userId = userId;
        this.status = status;
        this.totalPrice = totalPrice;
        this.createdAt = createdAt;
    }

    // --- GETTER/SETTER mới ---
    public ShippingInfo getShippingInfo() {
        return shippingInfo;
    }

    public void setShippingInfo(ShippingInfo shippingInfo) {
        this.shippingInfo = shippingInfo;
    }
    // --- END ---

    public String getProductsJson() {
        return productsJson;
    }

    public void setProductsJson(String productsJson) {
        this.productsJson = productsJson;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}
