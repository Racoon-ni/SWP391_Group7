package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DBConnect {
 private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=CPCC;encrypt=true;trustServerCertificate=true;";
    private static final String USER = "sa";
    private static final String PASSWORD = "123";


    // Kết nối đến database
    public static Connection connect() throws ClassNotFoundException, SQLException {
        //Khai bao driver
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

   
    public static PreparedStatement prepareStatement(String query) throws SQLException, ClassNotFoundException {
        Connection conn = connect();  // Lấy kết nối từ phương thức connect()
        return conn.prepareStatement(query); // Trả về một PreparedStatement thực tế
    }

    // Phương thức kiểm tra kết nối
    public void testConnection() {
        try ( Connection conn = connect()) {
            if (conn != null) {
                System.out.println("Kết nối đến database thành công!");
            } else {
                System.out.println("Kết nối thất bại!");
            }
        } catch (Exception e) {
            System.err.println("Lỗi kết nối: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        DBConnect db = new DBConnect();
        db.testConnection();
    }
}
