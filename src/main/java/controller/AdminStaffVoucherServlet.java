package controller;

import DAO.AdminStaffVoucherDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.AdminStaffVoucher;
import java.io.IOException;
import java.util.ArrayList;

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
            String expiredAt = request.getParameter("expiredAt");

            AdminStaffVoucher voucher = new AdminStaffVoucher(code, discountPercent, minOrderValue, expiredAt);
            AdminStaffVoucherDAO voucherDAO = new AdminStaffVoucherDAO();

            boolean success = voucherDAO.addVoucher(voucher);
            if (success) {
                response.sendRedirect("manage-vouchers?success=true");
            } else {
                response.sendRedirect("manage-vouchers?error=true");
            }
        } else if ("edit".equals(action)) {
            // Cập nhật voucher
            int voucherId = Integer.parseInt(request.getParameter("voucherId"));
            String code = request.getParameter("voucherCode");
            int discountPercent = Integer.parseInt(request.getParameter("discountPercent"));
            double minOrderValue = Double.parseDouble(request.getParameter("minOrderValue"));
            String expiredAt = request.getParameter("expiredAt");

            AdminStaffVoucher voucher = new AdminStaffVoucher(voucherId, code, discountPercent, minOrderValue, expiredAt);
            AdminStaffVoucherDAO voucherDAO = new AdminStaffVoucherDAO();

            boolean success = voucherDAO.updateVoucher(voucher);
            if (success) {
                response.sendRedirect("manage-vouchers?success=true");
            } else {
                response.sendRedirect("manage-vouchers?error=true");
            }
        } else if ("delete".equals(action)) {
            // Xóa voucher
            int voucherId = Integer.parseInt(request.getParameter("voucherId"));
            AdminStaffVoucherDAO voucherDAO = new AdminStaffVoucherDAO();
            boolean success = voucherDAO.deleteVoucher(voucherId);
            if (success) {
                response.sendRedirect("manage-vouchers?success=true");
            } else {
                response.sendRedirect("manage-vouchers?error=true");
            }
        }
    }
}
