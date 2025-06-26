/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Long
 */
// Lưu thông tin sản phẩm yêu thích của user
public class Wishlist {

    private int userId;           // ID người dùng
    private int productId;        // ID sản phẩm
    private String productName;   // Tên sản phẩm
    private String imageUrl;      // URL hình ảnh sản phẩm
    private double price;         // Giá sản phẩm
    private Date addedAt;         // Thời gian sản phẩm được thêm vào wishlist

    // Constructor mặc định
    public Wishlist() {
    }

    // Constructor đầy đủ
    public Wishlist(int userId, int productId, String productName, String imageUrl, double price, Date addedAt) {
        this.userId = userId;
        this.productId = productId;
        this.productName = productName;
        this.imageUrl = imageUrl;
        this.price = price;
        this.addedAt = addedAt;
    }

    // Getter và Setter
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Date getAddedAt() {
        return addedAt;
    }

    public void setAddedAt(Date addedAt) {
        this.addedAt = addedAt;
    }
}
