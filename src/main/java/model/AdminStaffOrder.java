/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author ADMIN
 */
package model;

import java.util.Date;

/**
 * Model đại diện cho đơn hàng dành riêng cho phần quản trị (admin/staff)
 */
public class AdminStaffOrder {
    private int orderId;
    private int customerId;
    private Date orderDate;
    private double totalPrice;
    private String status;

    public AdminStaffOrder(int orderId, int customerId, Date orderDate, double totalPrice, String status) {
        this.orderId = orderId;
        this.customerId = customerId;
        this.orderDate = orderDate;
        this.totalPrice = totalPrice;
        this.status = status;
    }

    public int getOrderId() {
        return orderId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public String getStatus() {
        return status;
    }
}
