package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;
import DAO.CustomerDAO;

import java.io.IOException;
import model.User;

@WebServlet("/update-profile")
public class CustomerUpdateProfileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User loggedInUser = (User) session.getAttribute("user");
        Customer customer = new CustomerDAO().getCustomerById(loggedInUser.getId());

        if (customer != null) {
            String fullName = req.getParameter("fullName");
            String email = req.getParameter("email");
            String gender = req.getParameter("gender");
            String dateOfBirth = req.getParameter("dob");
            String phone = req.getParameter("phone");
            String address = req.getParameter("address");

            customer.setFullName(fullName);
            customer.setEmail(email);
            customer.setGender(gender);
            customer.setDateOfBirth(dateOfBirth);
            customer.setPhone(phone);
            customer.setAddress(address);

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
