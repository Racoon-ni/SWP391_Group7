package model;

public class ShippingInfo {
    private String receiverName;
    private String phone;
    private String shippingAddress;
    private String paymentMethod;
    private String paymentStatus;

    public ShippingInfo() {
    }

    
    public ShippingInfo(String receiverName, String phone, String shippingAddress, String paymentMethod, String paymentStatus) {
        this.receiverName = receiverName;
        this.phone = phone;
        this.shippingAddress = shippingAddress;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
    }
   
    public String getReceiverName() { return receiverName; }
    public String getPhone() { return phone; }
    public String getShippingAddress() { return shippingAddress; }
    public String getPaymentMethod() { return paymentMethod; }
    public String getPaymentStatus() { return paymentStatus; }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    
    
}
