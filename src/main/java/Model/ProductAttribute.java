/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Huynh Trong Nguyen - CE190356
 */
public class ProductAttribute {
    private int productId;
    private Attribute attribute;
    private String value;

    public ProductAttribute() {
    }

    public ProductAttribute(int productId, Attribute attribute, String value) {
        this.productId = productId;
        this.attribute = attribute;
        this.value = value;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public Attribute getAttribute() {
        return attribute;
    }

    public void setAttribute(Attribute attribute) {
        this.attribute = attribute;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    
}
