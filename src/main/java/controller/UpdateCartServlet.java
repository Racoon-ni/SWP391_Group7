// UpdateCartServlet.java
package controller;

import DAO.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Cart;
import model.User;

@WebServlet(name = "UpdateCartServlet", urlPatterns = {"/update-cart"})
public class UpdateCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        String idStr = request.getParameter("cartItemId");
        String quantityStr = request.getParameter("quantity");

        try {
            int cartItemId = Integer.parseInt(idStr);
            int quantity = Integer.parseInt(quantityStr);
            if (quantity < 1) quantity = 1;

            CartDAO dao = new CartDAO();
            dao.updateCartItemQuantity(cartItemId, quantity);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Load lại giỏ hàng sau cập nhật
        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        try {
            CartDAO dao = new CartDAO();
            List<Cart> cartItems = dao.getCartByUserId(userId);
            double totalAmount = dao.getTotalAmount(cartItems);

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("totalAmount", totalAmount);
        } catch (Exception e) {
            request.setAttribute("cartItems", null);
            request.setAttribute("totalAmount", 0.0);
        }

        request.getRequestDispatcher("/WEB-INF/include/myCarts.jsp").forward(request, response);
    }
}
