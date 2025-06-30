package controller;

import DAO.CartDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Cart;
import model.User;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "MyCartServlet", urlPatterns = {"/my-carts"})
public class MyCartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login?msg=not_login");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getId();

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

        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/include/myCarts.jsp");
        rd.forward(request, response);
    }
}
