package DAO;

import config.DBConnect;
import model.ShippingInfo;

import java.sql.*;
//DAO
public class ShippingInfoDAO {

    public void insertShippingInfo(int orderId, ShippingInfo shippingInfo) {
        String sql = "INSERT INTO OrderShippingPayment (order_id, shipping_address, receiver_name, phone, payment_method, payment_status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.setString(2, shippingInfo.getShippingAddress());
            ps.setString(3, shippingInfo.getReceiverName());
            ps.setString(4, shippingInfo.getPhone());
            ps.setString(5, shippingInfo.getPaymentMethod());
            ps.setString(6, shippingInfo.getPaymentStatus());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
