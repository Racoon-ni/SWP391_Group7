package model;

public class UserAddress {
    private int id;
    private int userId;
    private String fullName;
    private String phone;
    private String specificAddress;
    private boolean defaultAddress;

    public UserAddress() {}

    public UserAddress(int id, int userId, String fullName, String phone, String specificAddress, boolean defaultAddress) {
        this.id = id;
        this.userId = userId;
        this.fullName = fullName;
        this.phone = phone;
        this.specificAddress = specificAddress;
        this.defaultAddress = defaultAddress;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

 
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getSpecificAddress() { return specificAddress; }
    public void setSpecificAddress(String specificAddress) { this.specificAddress = specificAddress; }

    public boolean isDefaultAddress() { return defaultAddress; }
    public void setDefaultAddress(boolean defaultAddress) { this.defaultAddress = defaultAddress; }
}
