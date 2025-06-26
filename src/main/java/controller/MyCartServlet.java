/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CartDAO;
import Model.Cart;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class MyCartServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("user") == null) {
        request.getRequestDispatcher("/WEB-INF/include/myCarts.jsp").forward(request, response);
        return;
    }

    int userId = (Integer) session.getAttribute("user");
    CartDAO dao = new CartDAO();

    try {
        List<Cart> cartItems = dao.getCartByUserId(userId);
        double totalAmount = dao.getTotalAmount(cartItems);

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("cartItems", null);
        request.setAttribute("totalAmount", 0);
    }

    request.getRequestDispatcher("myCarts.jsp").forward(request, response);
}

}
