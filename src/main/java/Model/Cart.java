/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author NghiLTTCE182357
 */
public class Cart {
     private int cartItemId;
    private int productId;
    private String productName;
    private String imageUrl;
    private int quantity;
    private int stock;
    private double price;

    public Cart(int cartItemId, int productId, String productName, String imageUrl,
                    int quantity, int stock, double price) {
        this.cartItemId = cartItemId;
        this.productId = productId;
        this.productName = productName;
        this.imageUrl = imageUrl;
        this.quantity = quantity;
        this.stock = stock;
        this.price = price;
    }

    // Getters và setters
    public int getCartItemId() { return cartItemId; }
    public int getProductId() { return productId; }
    public String getProductName() { return productName; }
    public String getImageUrl() { return imageUrl; }
    public int getQuantity() { return quantity; }
    public int getStock() { return stock; }
    public double getPrice() { return price; }

    public void setQuantity(int quantity) { this.quantity = quantity; }
}

