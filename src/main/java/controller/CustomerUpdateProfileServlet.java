package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;
import DAO.CustomerDAO;

import java.io.IOException;

@WebServlet("/update-profile")
public class CustomerUpdateProfileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Customer customer = (Customer) session.getAttribute("loggedInUser");

        if (customer != null) {
            String fullName = req.getParameter("fullName");
            String email = req.getParameter("email");

            customer.setFullName(fullName);
            customer.setEmail(email);

            CustomerDAO dao = new CustomerDAO();
            boolean success = dao.updateCustomerInfo(customer);

            if (success) {
                session.setAttribute("loggedInUser", customer);
                resp.sendRedirect("view-profile?success=true");
            } else {
                resp.sendRedirect("view-profile?error=true");
            }
        } else {
            resp.sendRedirect("login.jsp");
        }
    }
}
