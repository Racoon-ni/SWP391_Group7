/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Huynh Trong Nguyen - CE190356
 */
public class Category {
    private int categoryId;
    private Integer parentId;
    private String name;
    private String categoryType;
    private String parentName; // tên danh mục cha (không lưu DB, chỉ dùng hiển thị)


    public Category() {
    }
    

    public Category(int categoryId, int parentId, String name, String categoryType) {
        this.categoryId = categoryId;
        this.parentId = parentId;
        this.name = name;
        this.categoryType = categoryType;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategoryType() {
        return categoryType;
    }

    public void setCategoryType(String categoryType) {
        this.categoryType = categoryType;
    }

    public String getParentName() {
        return parentName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }
    
    
}
