package DAO;

import java.sql.Date;

import config.DBConnect;
import model.AdminStaffSalesStats;

import java.sql.*;
import java.util.*;

public class AdminStaffSalesDAO {

    public double getTotalRevenue() {
        String sql = "SELECT SUM(total_price) AS total FROM Orders";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public ArrayList<AdminStaffSalesStats> getDailyRevenue() {
        ArrayList<AdminStaffSalesStats> list = new ArrayList<>();
        String sql = "SELECT CAST(created_at AS DATE) AS date, SUM(total_price) AS revenue\n"
                + "FROM Orders GROUP BY CAST(created_at AS DATE) ORDER BY date DESC";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Date date = rs.getDate("date");
                double revenue = rs.getDouble("revenue");
                AdminStaffSalesStats stat = new AdminStaffSalesStats(date, revenue);
                list.add(stat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<AdminStaffSalesStats> getMonthlyRevenue() {
        List<AdminStaffSalesStats> list = new ArrayList<>();
        String sql = "SELECT YEAR(created_at) AS year, MONTH(created_at) AS month, SUM(total_price) AS revenue FROM Orders GROUP BY YEAR(created_at), MONTH(created_at) ORDER BY year DESC, month DESC";
        try ( PreparedStatement ps = DBConnect.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int year = rs.getInt("year");
                int month = rs.getInt("month");
                double revenue = rs.getDouble("revenue");
                AdminStaffSalesStats stat = new AdminStaffSalesStats(year, month, revenue);
                list.add(stat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
