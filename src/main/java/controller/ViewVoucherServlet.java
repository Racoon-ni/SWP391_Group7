package controller;

import dao.VoucherDAO;
import model.Voucher;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/view-vouchers")
public class ViewVoucherServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        // Lấy danh sách voucher từ DAO
        VoucherDAO dao = new VoucherDAO();
        ArrayList<Voucher> vouchers = dao.getAllVouchers();

        // Gửi sang view
        req.setAttribute("voucherList", vouchers);
        req.getRequestDispatcher("voucher-list.jsp").forward(req, resp);
    }
}
