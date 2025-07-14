package model;

import java.util.Date;

<<<<<<< HEAD
=======
import java.util.Date;

/**
 *
 * @author Huynh Trong Nguyen - CE190356
 */
>>>>>>> fc2302132c71aa13aaed03ea183a3ae763ab616d
public class User {

    private int id;
    private String username;
    private String password;
<<<<<<< HEAD
    private String email;
    private String fullname;
    private Date dateOfBirth; // sửa về java.sql.Date cho dễ thao tác với DB
=======
    private Date date_of_birth;
>>>>>>> fc2302132c71aa13aaed03ea183a3ae763ab616d
    private String address;
    private String phone;
    private String gender;
    private String role;
    private boolean status;
    private Date created_at;
    private String idCard;

    // Constructors
    public User() {
    }

<<<<<<< HEAD
    public User(int id, String username, String password, String email, String fullname,
            Date dateOfBirth, String address, String phone, String gender, String role, boolean status) {
=======
    public User(int id, String username, String email, String password, Date date_of_birth, String address, String phone, String gender, String role, boolean status, Date created_at, String idCard) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.date_of_birth = date_of_birth;
        this.address = address;
        this.phone = phone;
        this.gender = gender;
        this.role = role;
        this.status = status;
        this.created_at = created_at;
        this.idCard = idCard;
    }
    
    public User(int id, String username, String email, String password, String role, boolean status) {
>>>>>>> fc2302132c71aa13aaed03ea183a3ae763ab616d
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.fullname = fullname;
        this.dateOfBirth = dateOfBirth;
        this.address = address;
        this.phone = phone;
        this.gender = gender;
        this.role = role;
        this.status = status;
    }

    // Getters & Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
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

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }   

    public Date getDate_of_birth() {
        return date_of_birth;
    }
<<<<<<< HEAD
=======

    public void setDate_of_birth(Date date_of_birth) {
        this.date_of_birth = date_of_birth;
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

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Date created_at) {
        this.created_at = created_at;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }
    
    
>>>>>>> fc2302132c71aa13aaed03ea183a3ae763ab616d
}
