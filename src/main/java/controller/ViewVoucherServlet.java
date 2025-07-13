//package controller;
//
//import DAO.VoucherDAO;
//import model.Voucher;
//
//import jakarta.servlet.*;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//import java.util.ArrayList;
//
//@WebServlet("/vouchers-list")
//public class ViewVoucherServlet extends HttpServlet {
//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
//        throws ServletException, IOException {
//
//        // Lấy danh sách voucher từ DAO
//        VoucherDAO dao = new VoucherDAO();
//        ArrayList<Voucher> vouchers = dao.getAllVouchers();
//
//        // Gửi sang view
//        req.setAttribute("voucherList", vouchers);
//        req.getRequestDispatcher("WEB-INF/include/voucherlist.jsp").forward(req, resp);
//    }
//}
