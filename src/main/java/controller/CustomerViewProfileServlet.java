package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Customer;
import DAO.CustomerDAO;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/view-profile")
public class CustomerViewProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Tiến hành lấy thông tin người dùng từ database
        CustomerDAO dao = new CustomerDAO();
        Customer customer = null;
        customer = dao.getCustomerById(1);

        // Kiểm tra nếu không tìm thấy thông tin người dùng
        if (customer == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
            return;
        }

        // Gửi thông tin người dùng đến trang JSP
        req.setAttribute("customer", customer);
        req.getRequestDispatcher("WEB-INF/include/customer-view-profile.jsp").forward(req, resp);
    }
}
