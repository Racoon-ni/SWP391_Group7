package model;

public class AdminStaffVoucher {
    private int voucherId;
    private String code;
    private int discountPercent;
    private double minOrderValue;
    private String expiredAt;

    // Constructor
    public AdminStaffVoucher(int voucherId, String code, int discountPercent, double minOrderValue, String expiredAt) {
        this.voucherId = voucherId;
        this.code = code;
        this.discountPercent = discountPercent;
        this.minOrderValue = minOrderValue;
        this.expiredAt = expiredAt;
    }

    public AdminStaffVoucher(String code, int discountPercent, double minOrderValue, String expiredAt) {
        this.code = code;
        this.discountPercent = discountPercent;
        this.minOrderValue = minOrderValue;
        this.expiredAt = expiredAt;
    }

    // Getters and Setters
    public int getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(int voucherId) {
        this.voucherId = voucherId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }

    public double getMinOrderValue() {
        return minOrderValue;
    }

    public void setMinOrderValue(double minOrderValue) {
        this.minOrderValue = minOrderValue;
    }

    public String getExpiredAt() {
        return expiredAt;
    }

    public void setExpiredAt(String expiredAt) {
        this.expiredAt = expiredAt;
    }
}
