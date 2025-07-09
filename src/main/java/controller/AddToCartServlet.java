package controller;

import DAO.CartDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/AddToCart")
public class AddToCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String productIdStr = request.getParameter("productId");

        if (productIdStr == null) {
            response.sendRedirect("/component-list.jsp?error=missing_product");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            User user = (User) session.getAttribute("user");

            CartDAO dao = new CartDAO();
            dao.addToCart(user.getId(), productId);

            response.sendRedirect(request.getContextPath() + "/my-carts");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/component-list.jsp?error=exception");
        }
    }
}
