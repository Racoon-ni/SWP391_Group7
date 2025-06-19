package model;

public class Voucher {
    private String code;
    private String description;
    private String expiryDate;
    private double discountPercent;

    public Voucher() {}

    public Voucher(String code, String description, String expiryDate, double discountPercent) {
        this.code = code;
        this.description = description;
        this.expiryDate = expiryDate;
        this.discountPercent = discountPercent;
    }

    // Getter và Setter
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getExpiryDate() { return expiryDate; }
    public void setExpiryDate(String expiryDate) { this.expiryDate = expiryDate; }

    public double getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(double discountPercent) { this.discountPercent = discountPercent; }
}
