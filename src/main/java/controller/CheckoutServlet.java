package controller;

import DAO.CartDAO;
import DAO.UserDAO;
import model.User;
import model.Cart;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        int userId = sessionUser.getId();

        UserDAO userDAO = new UserDAO();
        User fullUser = userDAO.getUserByIdForCheckout(userId); // phải lấy đủ info từ DB

        CartDAO cartDAO = new CartDAO();
        List<Cart> cartItems = cartDAO.getCartItemsByUserId(userId);
        double totalAmount = cartDAO.calculateTotal(cartItems);

        request.setAttribute("userInfo", fullUser);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/include/checkout.jsp");
        dispatcher.forward(request, response);
    }
}
