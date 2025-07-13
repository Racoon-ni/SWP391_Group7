package model;


public class Customer {

    private int userId;
    private String fullName;
    private String email;
    private String gender;
    private String dateOfBirth;
    private String address;
    private String phone;
    private String password;

    // Full constructor with 8 parameters
    public Customer(int userId, String fullName, String email, String gender, String dateOfBirth, String address, String phone, String password) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.address = address;
        this.phone = phone;
        this.password = password;
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
