package repository;

import config.DBConnect;
import model.Customer;
import java.sql.Connection;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CustomerDAO extends DBConnect{
    public Customer getCustomerById(int userId) {
        Customer customer = null;
        String sql = "SELECT * FROM Users WHERE user_id = ?";

        try (Connection conn = DBConnect.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                customer = new Customer(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("email")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return customer;
    }
}
