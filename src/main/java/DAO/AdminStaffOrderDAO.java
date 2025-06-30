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
}