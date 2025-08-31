package model;

public class AdminStaffVoucher {

    private int voucherId;
    private String code;
    private int discountPercent;
    private double minOrderValue;
    private String startDate;
    private String expiredAt;
    private int quantity;

    // Constructor với tất cả các trường
    public AdminStaffVoucher(int voucherId, String code, int discountPercent, double minOrderValue, String startDate, String expiredAt, int quantity) {
        this.voucherId = voucherId;
        this.code = code;
        this.discountPercent = discountPercent;
        this.minOrderValue = minOrderValue;
        this.startDate = startDate;
        this.expiredAt = expiredAt;
        this.quantity = quantity;
    }

    // Constructor không có voucherId (dùng khi thêm mới voucher)
    public AdminStaffVoucher(String code, int discountPercent, double minOrderValue, String startDate, String expiredAt, int quantity) {
        this.code = code;
        this.discountPercent = discountPercent;
        this.minOrderValue = minOrderValue;
        this.startDate = startDate;
        this.expiredAt = expiredAt;
        this.quantity = quantity;
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

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getExpiredAt() {
        return expiredAt;
    }

    public void setExpiredAt(String expiredAt) {
        this.expiredAt = expiredAt;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
