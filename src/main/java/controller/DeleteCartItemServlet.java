package controller;

import DAO.CartDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "DeleteCartItemServlet", urlPatterns = {"/DeleteCartItem"})
public class DeleteCartItemServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-carts?error=invalid_id");
            return;
        }

        try {
            int cartItemId = Integer.parseInt(idStr);
            CartDAO dao = new CartDAO();
            dao.deleteCartItem(cartItemId);

            // Chuyển hướng lại giỏ hàng để thấy kết quả mới
            response.sendRedirect(request.getContextPath() + "/my-carts");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/my-carts?error=exception");
        }
    }
}
