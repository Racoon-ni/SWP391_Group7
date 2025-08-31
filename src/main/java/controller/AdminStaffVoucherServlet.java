package controller;

import DAO.AdminStaffVoucherDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.AdminStaffVoucher;
import java.io.IOException;
import java.util.ArrayList;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@WebServlet("/manage-vouchers")  // Sửa đường dẫn cho dễ phân biệt
public class AdminStaffVoucherServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Kiểm tra quyền truy cập
//        HttpSession session = request.getSession(false);
//        String role = (String) session.getAttribute("role");

//        if ("Admin".equals(role)) {
        // Chỉ cho phép Admin truy cập
        int page = Integer.parseInt(request.getParameter("page") != null ? request.getParameter("page") : "1");
        int limit = 5;  // Giới hạn số voucher trên mỗi trang

        AdminStaffVoucherDAO voucherDAO = new AdminStaffVoucherDAO();
        ArrayList<AdminStaffVoucher> voucherList = voucherDAO.getAllVouchers(page, limit);  // Example for pagination
        request.setAttribute("voucherList", voucherList);
        request.getRequestDispatcher("/WEB-INF/include/manage-vouchers.jsp").forward(request, response);
//        } else {
//            response.sendRedirect("access-denied.jsp"); // Nếu không phải Admin
//        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            // Thêm voucher mới
            String code = request.getParameter("voucherCode");
            int discountPercent = Integer.parseInt(request.getParameter("discountPercent"));
            double minOrderValue = Double.parseDouble(request.getParameter("minOrderValue"));
            String startDate = request.getParameter("startDate");
            String expiredAt = request.getParameter("expiredAt");
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // Validation: Kiểm tra ngày bắt đầu không thể lớn hơn ngày hết hạn
            if (!validateDateRange(startDate, expiredAt)) {
                response.sendRedirect("manage-vouchers?error=invalid_date_range&message=Ngày bắt đầu không thể lớn hơn ngày hết hạn");
                return;
            }

            // Validation: Kiểm tra các trường bắt buộc
            if (code == null || code.trim().isEmpty() || discountPercent <= 0 || minOrderValue <= 0 || quantity <= 0) {
                response.sendRedirect("manage-vouchers?error=invalid_input&message=Thông tin nhập vào không hợp lệ");
                return;
            }

            AdminStaffVoucher voucher = new AdminStaffVoucher(code, discountPercent, minOrderValue, startDate, expiredAt, quantity);
            AdminStaffVoucherDAO voucherDAO = new AdminStaffVoucherDAO();

            boolean success = voucherDAO.addVoucher(voucher);
            if (success) {
                // ✅ Gửi thông báo voucher mới đến khách hàng
                DAO.NotificationDAO notiDAO = new DAO.NotificationDAO();
                notiDAO.sendVoucherUpdateToAllUsers(code);

                response.sendRedirect("manage-vouchers?success=true&message=Voucher đã được tạo thành công");
            } else {
                response.sendRedirect("manage-vouchers?error=true&message=Không thể tạo voucher, vui lòng thử lại");
            }

        } else if ("edit".equals(action)) {
            // Cập nhật voucher
            int voucherId = Integer.parseInt(request.getParameter("voucherId"));
            String code = request.getParameter("voucherCode");
            int discountPercent = Integer.parseInt(request.getParameter("discountPercent"));
            double minOrderValue = Double.parseDouble(request.getParameter("minOrderValue"));
            String startDate = request.getParameter("startDate");
            String expiredAt = request.getParameter("expiredAt");
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // Validation: Kiểm tra ngày bắt đầu không thể lớn hơn ngày hết hạn
            if (!validateDateRange(startDate, expiredAt)) {
                response.sendRedirect("manage-vouchers?error=invalid_date_range&message=Ngày bắt đầu không thể lớn hơn ngày hết hạn");
                return;
            }

            // Validation: Kiểm tra các trường bắt buộc
            if (code == null || code.trim().isEmpty() || discountPercent <= 0 || minOrderValue <= 0 || quantity <= 0) {
                response.sendRedirect("manage-vouchers?error=invalid_input&message=Thông tin nhập vào không hợp lệ");
                return;
            }

            AdminStaffVoucher voucher = new AdminStaffVoucher(voucherId, code, discountPercent, minOrderValue, startDate, expiredAt, quantity);
            AdminStaffVoucherDAO voucherDAO = new AdminStaffVoucherDAO();

            boolean success = voucherDAO.updateVoucher(voucher);
            if (success) {
                response.sendRedirect("manage-vouchers?success=true&message=Voucher đã được cập nhật thành công");
            } else {
                response.sendRedirect("manage-vouchers?error=true&message=Không thể cập nhật voucher, vui lòng thử lại");
            }

        } else if ("delete".equals(action)) {
            // Xóa voucher
            int voucherId = Integer.parseInt(request.getParameter("voucherId"));
            AdminStaffVoucherDAO voucherDAO = new AdminStaffVoucherDAO();
            boolean success = voucherDAO.deleteVoucher(voucherId);
            if (success) {
                response.sendRedirect("manage-vouchers?success=true&message=Voucher đã được xóa thành công");
            } else {
                response.sendRedirect("manage-vouchers?error=true&message=Không thể xóa voucher, vui lòng thử lại");
            }
        }
    }

    // Method validation ngày bắt đầu và ngày hết hạn
    private boolean validateDateRange(String startDate, String expiredAt) {
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate start = LocalDate.parse(startDate, formatter);
            LocalDate expired = LocalDate.parse(expiredAt, formatter);
            
            // Ngày bắt đầu không thể lớn hơn ngày hết hạn
            return !start.isAfter(expired);
        } catch (Exception e) {
            return false; // Nếu có lỗi parse date thì return false
        }
    }
}
