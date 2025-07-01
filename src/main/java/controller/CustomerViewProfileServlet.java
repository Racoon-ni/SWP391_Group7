package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;
import DAO.CustomerDAO;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import model.User;

@WebServlet("/view-profile")
public class CustomerViewProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
         User loggedInUser = (User) session.getAttribute("user");

        if (loggedInUser == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        Customer customer = new CustomerDAO().getCustomerById(loggedInUser.getId());
        req.setAttribute("customer", customer);
        req.getRequestDispatcher("/WEB-INF/include/customer-view-profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Customer loggedInUser = (Customer) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        List<String> errors = new ArrayList<>();

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String gender = req.getParameter("gender");
        String address = req.getParameter("address");
        String phone = req.getParameter("phone");
        String dob = req.getParameter("dob");

        if (fullName == null || fullName.trim().length() < 3 || !fullName.matches("^[\\p{L}\\s]{3,50}$")) {
            errors.add("Họ tên không hợp lệ!");
        }

        if (email == null || !email.matches("^[\\w-.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            errors.add("Email không đúng định dạng!");
        }

        if (phone == null || !phone.matches("^0\\d{9,10}$")) {
            errors.add("Số điện thoại phải bắt đầu bằng 0 và gồm 10-11 số!");
        }

        if (!"Nam".equals(gender) && !"Nữ".equals(gender) && !"Khác".equals(gender)) {
            errors.add("Giới tính không hợp lệ!");
        }

        if (dob == null) {
            errors.add("Ngày sinh không được để trống!");
        } else {
            try {
                LocalDate birthDate = LocalDate.parse(dob);
                if (birthDate.isAfter(LocalDate.now().minusYears(13))) {
                    errors.add("Bạn phải ít nhất 13 tuổi!");
                }
            } catch (Exception e) {
                errors.add("Ngày sinh không hợp lệ!");
            }
        }

        if (address == null || address.length() < 5 || address.matches(".*[<>;].*")) {
            errors.add("Địa chỉ không hợp lệ!");
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            doGet(req, resp);
            return;
        }

        Customer c = new Customer(
                loggedInUser.getUserId(),
                fullName,
                email,
                gender,
                address,
                phone,
                dob,
                ""
        );

        boolean updated = new CustomerDAO().updateCustomerInfo(c);
        if (updated) {
            session.setAttribute("loggedInUser", c);
            resp.sendRedirect("view-profile?success=true");
        } else {
            resp.sendRedirect("view-profile?error=true");
        }
    }
}
