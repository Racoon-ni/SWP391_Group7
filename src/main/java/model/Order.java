package model;

import java.util.Date;
import java.sql.Timestamp;

public class Order {

    private int orderId;
    private int userId;
    private String status;
    private double discountAmount; // Số tiền giảm
    private Double finalPrice;     // Tổng sau giảm giá
    private Integer voucherId;     // ID voucher (có thể null)
    private double totalPrice;
    private Date createdAt;

    // === Thêm thuộc tính này ===
    private ShippingInfo shippingInfo;
    private String productsJson; // Thêm dòng này vào class
    // 1. Constructor mặc định

    public Order() {
    }

    // 2. Constructor cũ (5 tham số) - dùng trong PlaceOrderServlet
    public Order(int orderId, int userId, String status, double totalPrice, Date createdAt) {
        this.orderId = orderId;
        this.userId = userId;
        this.status = status;
        this.totalPrice = totalPrice;
        this.discountAmount = 0.0;
        this.finalPrice = totalPrice;
        this.voucherId = null;
        this.createdAt = (createdAt != null)
                ? new Timestamp(createdAt.getTime())
                : new Timestamp(System.currentTimeMillis());
    }

    // 3. Constructor mới (8 tham số) - dùng trong CheckoutServlet, orderDAO
    public Order(int orderId, int userId, String status, double totalPrice,
            double discountAmount, double finalPrice, Integer voucherId, Timestamp createdAt) {
        this.orderId = orderId;
        this.userId = userId;
        this.status = status;
        this.totalPrice = totalPrice;
        this.discountAmount = discountAmount;
        this.finalPrice = finalPrice;
        this.voucherId = voucherId;
        this.createdAt = (createdAt != null)
                ? createdAt
                : new Timestamp(System.currentTimeMillis());
    }

    public double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public Double getFinalPrice() {
        return finalPrice;
    }

    public void setFinalPrice(Double finalPrice) {
        this.finalPrice = finalPrice;
    }

    public Integer getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(Integer voucherId) {
        this.voucherId = voucherId;
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
    // === toString ===
    @Override
    public String toString() {
        return "Order{" +
                "orderId=" + orderId +
                ", userId=" + userId +
                ", status='" + status + '\'' +
                ", totalPrice=" + totalPrice +
                ", discountAmount=" + discountAmount +
                ", finalPrice=" + finalPrice +
                ", voucherId=" + voucherId +
                ", createdAt=" + createdAt +
                '}';
    }
}
