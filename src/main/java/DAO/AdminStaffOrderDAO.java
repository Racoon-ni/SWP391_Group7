/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import model.AdminStaffOrder;
import config.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;


public class AdminStaffOrderDAO extends DBConnect {

    public ArrayList<AdminStaffOrder> getAllOrders() {
        ArrayList<AdminStaffOrder> orders = new ArrayList<>();
        // SQL chuẩn
        String sql = "SELECT o.order_id, o.user_id, o.total_price, o.status, o.created_at FROM Orders o";

        try ( Connection conn = DBConnect.connect();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                orders.add(new AdminStaffOrder(
                        rs.getInt("order_id"),
                        rs.getInt("user_id"),
                        rs.getDate("created_at"),
                        rs.getDouble("total_price"),
                        rs.getString("status")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace(); // in lỗi nếu có
        }

        return orders;
    }
    public ArrayList<AdminStaffOrder> filterOrders(String status, String date, String month, String fromDate, String toDate) {
    ArrayList<AdminStaffOrder> list = new ArrayList<>();
    StringBuilder sql = new StringBuilder("SELECT order_id, user_id, created_at, total_price, status FROM Orders WHERE 1=1");
    ArrayList<Object> params = new ArrayList<>();

    if (status != null && !status.isEmpty()) {
        sql.append(" AND status = ?");
        params.add(status);
    }

    if (date != null && !date.isEmpty()) {
        sql.append(" AND DATE(created_at) = ?");
        params.add(java.sql.Date.valueOf(date));
    }

    if (month != null && !month.isEmpty()) {
        sql.append(" AND DATE_FORMAT(created_at, '%Y-%m') = ?");
        params.add(month);
    }

    if (fromDate != null && !fromDate.isEmpty()) {
        sql.append(" AND DATE(created_at) >= ?");
        params.add(java.sql.Date.valueOf(fromDate));
    }

    if (toDate != null && !toDate.isEmpty()) {
        sql.append(" AND DATE(created_at) <= ?");
        params.add(java.sql.Date.valueOf(toDate));
    }

    sql.append(" ORDER BY created_at DESC");

    try (PreparedStatement ps = DBConnect.prepareStatement(sql.toString())) {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            AdminStaffOrder order = new AdminStaffOrder(
                rs.getInt("order_id"),
                rs.getInt("user_id"),
                rs.getTimestamp("created_at"),
                rs.getDouble("total_price"),
                rs.getString("status")
            );
            list.add(order);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

}
