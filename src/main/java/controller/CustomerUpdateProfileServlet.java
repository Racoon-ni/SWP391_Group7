package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;
import model.User;
import DAO.CustomerDAO;

import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/update-profile")
public class CustomerUpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User loggedInUser = (User) session.getAttribute("user");

        if (loggedInUser == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.getCustomerById(loggedInUser.getId());
        if (customer == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        Map<String, String> errors = new HashMap<>();

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String gender = req.getParameter("gender");
        String dateOfBirth = req.getParameter("dob");
        String phone = req.getParameter("phone");

        // Validate họ tên
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.put("errorFullName", "Họ tên không được để trống!");
        } else if (!fullName.matches("^[A-Za-zÀ-Ỹà-ỹ\\s]+$")) {
            errors.put("errorFullName", "Họ tên chỉ được chứa chữ cái và dấu cách, không chứa số hoặc ký tự đặc biệt!");
        } else if (!fullName.equals(fullName.trim())) {
            errors.put("errorFullName", "Họ tên không được chứa khoảng trắng ở đầu hoặc cuối!");
        }

        // Validate email
        if (email == null || email.trim().isEmpty()) {
            errors.put("errorEmail", "Email không được để trống!");
        } else if (!email.matches("^[a-zA-Z0-9]+@gmail\\.com$")) {
            errors.put("errorEmail", "Email phải đúng định dạng, chỉ cho phép @gmail.com và không chứa ký tự đặc biệt!");
        }

        // Validate giới tính
        if (!"Nam".equals(gender) && !"Nữ".equals(gender) && !"Khác".equals(gender)) {
            errors.put("errorGender", "Giới tính không hợp lệ!");
        }

        // Validate ngày sinh
        if (dateOfBirth == null || dateOfBirth.trim().isEmpty()) {
            errors.put("errorDob", "Ngày sinh không được để trống!");
        } else {
            try {
                LocalDate birthDate = LocalDate.parse(dateOfBirth);

                // ✅ thêm check năm sinh >= 1945
                if (birthDate.getYear() < 1945) {
                    errors.put("errorDob", "Năm sinh phải từ 1945 trở đi!");
                } else if (birthDate.isAfter(LocalDate.of(2025, 12, 31))) {
                    errors.put("errorDob", "Ngày sinh không được sau năm 2025!");
                } else if (birthDate.isAfter(LocalDate.now().minusYears(13))) {
                    errors.put("errorDob", "Bạn phải ít nhất 15 tuổi!");
                }
            } catch (Exception e) {
                errors.put("errorDob", "Ngày sinh không hợp lệ!");
            }
        }

        // Validate số điện thoại
        if (phone == null || phone.trim().isEmpty()) {
            errors.put("errorPhone", "Số điện thoại không được để trống!");
        } else if (!phone.matches("^0\\d{9,10}$")) {
            errors.put("errorPhone", "Số điện thoại chỉ được chứa số và phải bắt đầu bằng 0 (10-11 chữ số)!");
        }

        // ✅ Check DB: email trùng
        if (!errors.containsKey("errorEmail")) {
            if (customerDAO.isEmailExist(email, customer.getUserId())) {
                errors.put("errorEmail", "Email này đã được sử dụng!");
            }
        }

        // ✅ Check DB: phone trùng
        if (!errors.containsKey("errorPhone")) {
            if (customerDAO.isPhoneExist(phone, customer.getUserId())) {
                errors.put("errorPhone", "Số điện thoại này đã được sử dụng!");
            }
        }

        // Nếu có lỗi thì trả lại giao diện + giữ lại dữ liệu đã nhập
        if (!errors.isEmpty()) {
            Customer tempCustomer = new Customer();
            tempCustomer.setFullName(fullName);
            tempCustomer.setEmail(email);
            tempCustomer.setGender(gender);
            tempCustomer.setDateOfBirth(dateOfBirth);
            tempCustomer.setPhone(phone);

            for (Map.Entry<String, String> entry : errors.entrySet()) {
                req.setAttribute(entry.getKey(), entry.getValue());
            }

            req.setAttribute("customer", tempCustomer);
            req.getRequestDispatcher("/WEB-INF/include/customer-view-profile.jsp").forward(req, resp);
            return;
        }

        // Nếu hợp lệ, cập nhật thông tin
        customer.setFullName(fullName.trim());
        customer.setEmail(email.trim());
        customer.setGender(gender);
        customer.setDateOfBirth(dateOfBirth);
        customer.setPhone(phone.trim());

        boolean success = customerDAO.updateCustomerInfo(customer);

        if (success) {
            session.setAttribute("loggedInUser", customer);
            resp.sendRedirect("view-profile?success=true");
        } else {
            resp.sendRedirect("view-profile?error=true");
        }
    }
}
