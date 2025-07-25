/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ThinhLVCE181726 <your.name at your.org>
 */
public class Attribute {

    private Integer attributeId;
    private String name;
    private Integer categoryId;
    private String unit;
    private String categoryName; // để join cho dễ hiển thị

    public Attribute() {
    }

    public Attribute(Integer attributeId, String name, Integer categoryId, String unit, String categoryName) {
        this.attributeId = attributeId;
        this.name = name;
        this.categoryId = categoryId;
        this.unit = unit;
        this.categoryName = categoryName;
    }

    // Getter/Setter
    public Integer getAttributeId() {
        return attributeId;
    }

    public void setAttributeId(Integer attributeId) {
        this.attributeId = attributeId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
}
