package model;
import java.sql.Date;



public class AdminStaffSalesStats {
    private Date date;       // dùng cho thống kê theo ngày
    private int month;       // dùng cho thống kê theo tháng
    private int year;        // dùng cho thống kê theo tháng
    private double revenue;  // doanh thu

    // Constructor dùng cho tổng doanh thu
    public AdminStaffSalesStats(double revenue) {
        this.revenue = revenue;
    }

    // Constructor dùng cho thống kê theo ngày
    public AdminStaffSalesStats(Date date, double revenue) {
        this.date = date;
        this.revenue = revenue;
    }

    // Constructor dùng cho thống kê theo tháng
    public AdminStaffSalesStats(int year, int month, double revenue) {
        this.year = year;
        this.month = month;
        this.revenue = revenue;
    }

    // Getter + Setter
    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public double getRevenue() {
        return revenue;
    }

    public void setRevenue(double revenue) {
        this.revenue = revenue;
    }
}
