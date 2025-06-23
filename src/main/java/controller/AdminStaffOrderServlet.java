/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.AdminStaffOrder;



import repository.AdminStaffOrderDAO;

import java.io.IOException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author ADMIN
 */
@WebServlet("/manage-orders")
public class AdminStaffOrderServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

//        HttpSession session = req.getSession(false);
//        String role = (session != null && session.getAttribute("role") != null)
//            ? session.getAttribute("role").toString()
//            : "guest";

//        if ("admin".equals(role) || "staff".equals(role)) {
            AdminStaffOrderDAO repo = new AdminStaffOrderDAO();
            ArrayList<AdminStaffOrder> orders = new ArrayList<>();
            orders = repo.getAllOrders();

            req.setAttribute("orders", orders);
            req.getRequestDispatcher("WEB-INF/include/manage-orders.jsp").forward(req, resp);
//        } else {
//            resp.sendRedirect("access-denied");
//        }
    }
}
