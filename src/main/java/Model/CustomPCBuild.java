/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;
import java.util.List;

/**
 *
 * @author Long
 */
public class CustomPCBuild {

    private int buildId;
    private int userId;
    private String name;
    private double totalPrice;
    private Date createdAt;
    private List<CustomPCBuildDetail> components; // Danh sách linh kiện đã chọn

    public CustomPCBuild() {
    }

    public CustomPCBuild(int buildId, int userId, String name, double totalPrice, Date createdAt) {
        this.buildId = buildId;
        this.userId = userId;
        this.name = name;
        this.totalPrice = totalPrice;
        this.createdAt = createdAt;
    }

    public int getBuildId() {
        return buildId;
    }

    public void setBuildId(int buildId) {
        this.buildId = buildId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public List<CustomPCBuildDetail> getComponents() {
        return components;
    }

    public void setComponents(List<CustomPCBuildDetail> components) {
        this.components = components;
    }
}
