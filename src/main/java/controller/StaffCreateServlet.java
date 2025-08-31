package controller;

import DAO.UserDAO;
import model.User;
import util.EmailUtil;
import util.ValidationUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Admin
 */

@WebServlet(name = "StaffCreateServlet", urlPatterns = {"/StaffCreate"})
public class StaffCreateServlet extends HttpServlet {

    private static final String PASSWORD_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789!@#$%^&*?";
    private static final SecureRandom RANDOM = new SecureRandom();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/include/staff-create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Lấy params
        String username = request.getParameter("username");
        String password = request.getParameter("password"); // có thể admin tự nhập, nếu rỗng sẽ tạo random
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String dobStr = request.getParameter("dateOfBirth");
        String phoneRaw = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");

        String phone = ValidationUtils.normalizePhoneVN(phoneRaw);

        Date dobSql = null;
        try {
            if (dobStr != null && !dobStr.isEmpty()) {
                dobSql = Date.valueOf(dobStr); // yyyy-MM-dd
            }
        } catch (Exception e) {
            // để errors xử lý sau
        }

        Map<String, String> errors = new HashMap<>();
        UserDAO dao = new UserDAO();

        // Required
        if (username == null || username.trim().isEmpty()) {
            errors.put("username", "Bắt buộc.");
        }
        if (password == null || password.trim().isEmpty()) {
            // không bắt lỗi ở đây, sẽ tạo password random nếu admin không nhập
        }

        // Email
        if (!ValidationUtils.isValidEmail(email)) {
            errors.put("email", "Email không hợp lệ.");
        } else if (dao.emailExists(email)) {
            errors.put("email", "Email đã tồn tại.");
        }

        // Fullname
        if (!ValidationUtils.isValidFullname(fullname)) {
            errors.put("fullname", "Họ tên không chứa số/ký tự đặc biệt.");
        }

        // DOB & 18+
        if (dobSql == null) {
            errors.put("dateOfBirth", "Ngày sinh không hợp lệ.");
        } else if (!ValidationUtils.isAdult(dobSql.toLocalDate())) {
            errors.put("dateOfBirth", "Nhân viên phải từ 18 tuổi.");
        }

        // Phone VN + unique (nếu nhập)
        if (!ValidationUtils.isValidVNPhoneOrEmpty(phone)) {
            errors.put("phone", "SĐT phải là số di động VN hợp lệ (03/05/07/08/09 + 8 số).");
        } else if (phone != null && !phone.isEmpty() && dao.phoneExists(phone)) {
            errors.put("phone", "SĐT đã tồn tại.");
        }

        // Username unique
        if (username != null && !username.trim().isEmpty() && dao.usernameExists(username)) {
            errors.put("username", "Tên đăng nhập đã tồn tại.");
        }

        // Nếu có lỗi -> trả lại form với dữ liệu
        if (!errors.isEmpty()) {
            User form = new User();
            form.setUsername(username);
            form.setPassword(password); // giữ nếu admin đã nhập
            form.setEmail(email);
            form.setFullname(fullname);
            form.setDateOfBirth(dobSql);
            form.setPhone(phone);
            form.setGender(gender);
            form.setAddress(address);
            form.setRole("Staff");
            form.setStatus(true);

            request.setAttribute("errors", errors);
            request.setAttribute("formData", form);
            request.getRequestDispatcher("/WEB-INF/include/staff-create.jsp").forward(request, response);
            return;
        }

        // Nếu admin không nhập password, tạo random
        String rawPassword = (password == null || password.trim().isEmpty()) ? generateRandomPassword(12) : password.trim();

        // Tạo User (lưu ý: addStaff() của bạn sẽ hash MD5 trước khi insert)
        User user = new User(0, username, rawPassword, email, fullname, dobSql, address, phone, gender, "Staff", true);

        int added = dao.addStaff(user);
        if (added == 1) {
            // Gửi email thật
            String subject = "Tạo tài khoản nhân viên - PC Store";
            StringBuilder sb = new StringBuilder();
            sb.append("<p>Xin chào <b>").append(fullname == null ? username : fullname).append("</b>,</p>");
            sb.append("<p>Bạn vừa được tạo tài khoản nhân viên tại <b>PC Store</b>.</p>");
            sb.append("<p><b>Tên đăng nhập:</b> ").append(username).append("</p>");
            sb.append("<p><b>Mật khẩu tạm:</b> ").append(rawPassword).append("</p>");
            sb.append("<p>Vui lòng đăng nhập và đổi mật khẩu ngay sau lần đăng nhập đầu tiên.</p>");
            sb.append("<p><a href='http://localhost:8080/SWP391_Group7/login'>Đăng nhập ngay</a></p>");
            String body = sb.toString();

            try {
                EmailUtil.sendEmail(email, subject, body);
                // thành công -> chuyển về danh sách
                response.sendRedirect("StaffList?message=Thêm nhân viên & tạo account Staff thành công!");
                return;
            } catch (Exception ex) {
                ex.printStackTrace();
                // nếu gửi email thất bại, rollback (xóa user vừa tạo)
                try {
                    User created = dao.getUserIdByEmail(email);
                    if (created != null) {
                        dao.deleteUser(created.getId());
                    }
                } catch (Exception ignore) {
                    // bỏ qua lỗi xoá (đã log ở trên)
                }
                request.setAttribute("error", "Đã tạo nhân viên nhưng gửi email thất bại. Tài khoản đã được xóa để tránh trạng thái không nhất quán.");
                // để admin dễ kiểm tra lại form, trả các trường đã nhập (không trả password)
                User form = new User();
                form.setUsername(username);
                form.setEmail(email);
                form.setFullname(fullname);
                form.setDateOfBirth(dobSql);
                form.setPhone(phone);
                form.setGender(gender);
                form.setAddress(address);
                request.setAttribute("formData", form);
                request.getRequestDispatcher("/WEB-INF/include/staff-create.jsp").forward(request, response);
                return;
            }
        } else {
            request.setAttribute("error", "Lỗi thêm nhân viên.");
            User form = new User();
            form.setUsername(username);
            form.setPassword(""); // không lộ mật khẩu
            form.setEmail(email);
            form.setFullname(fullname);
            form.setDateOfBirth(dobSql);
            form.setPhone(phone);
            form.setGender(gender);
            form.setAddress(address);
            request.setAttribute("formData", form);
            request.getRequestDispatcher("/WEB-INF/include/staff-create.jsp").forward(request, response);
            return;
        }
    }

    private String generateRandomPassword(int length) {
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(PASSWORD_CHARS.charAt(RANDOM.nextInt(PASSWORD_CHARS.length())));
        }
        return sb.toString();
    }

    @Override
    public String getServletInfo() {
        return "StaffCreateServlet - tạo nhân viên và gửi mail thật";
    }
}
