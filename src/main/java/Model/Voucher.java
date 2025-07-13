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
// Lưu thông tin voucher
public class Voucher {

    private int voucherId;
    private String code;
    private int discountPercent;
    private double minOrderValue;
    private Date expiredAt;
    private int createdBy;

    public Voucher() {
    }

    public Voucher(int voucherId, String code, int discountPercent, double minOrderValue, Date expiredAt, int createdBy) {
        this.voucherId = voucherId;
        this.code = code;
        this.discountPercent = discountPercent;
        this.minOrderValue = minOrderValue;
        this.expiredAt = expiredAt;
        this.createdBy = createdBy;
    }

    public int getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(int voucherId) {
        this.voucherId = voucherId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }

    public double getMinOrderValue() {
        return minOrderValue;
    }

    public void setMinOrderValue(double minOrderValue) {
        this.minOrderValue = minOrderValue;
    }

    public Date getExpiredAt() {
        return expiredAt;
    }

    public void setExpiredAt(Date expiredAt) {
        this.expiredAt = expiredAt;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }
}
