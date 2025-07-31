/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Long
 */
public class CustomPCBuildDetail {

    private int buildId;
    private int componentId;
    private int quantity;
    private Product product; 

    public CustomPCBuildDetail() {
    }

    public CustomPCBuildDetail(int buildId, int componentId, int quantity) {
        this.buildId = buildId;
        this.componentId = componentId;
        this.quantity = quantity;
    }
    // Getter/setter các trường...

    public int getBuildId() {
        return buildId;
    }

    public void setBuildId(int buildId) {
        this.buildId = buildId;
    }

    public int getComponentId() {
        return componentId;
    }

    public void setComponentId(int componentId) {
        this.componentId = componentId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }
}
