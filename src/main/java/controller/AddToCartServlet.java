package controller;

import DAO.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import java.io.IOException;

@WebServlet(name = "AddToCartServlet", urlPatterns = {"/AddToCart"})
public class AddToCartServlet extends HttpServlet {

    private static final int ADDED = 1;   // thêm/ tăng 1 thành công
    private static final int MAXED = 0;   // đã tối đa stock, không tăng nữa
    private static final int ERROR = -1;  // lỗi

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String productIdStr = request.getParameter("productId");
        String redirect = request.getParameter("redirect"); // URL để quay lại (VD: /ViewComponent?category=CPU)

        // Fallback nếu không truyền redirect thì quay về giỏ
        if (redirect == null || redirect.trim().isEmpty()) {
            redirect = request.getContextPath() + "/my-carts";
        }

        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            response.sendRedirect(redirect + (redirect.contains("?") ? "&" : "?") + "msg=error");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(productIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(redirect + (redirect.contains("?") ? "&" : "?") + "msg=error");
            return;
        }

        int result;
        try {
            CartDAO dao = new CartDAO();
            result = dao.addToCartRespectingStock(user.getId(), productId);
        } catch (Exception e) {
            e.printStackTrace();
            result = ERROR;
        }

        String msg = (result == ADDED) ? "added" : (result == MAXED) ? "maxed" : "error";
        response.sendRedirect(redirect + (redirect.contains("?") ? "&" : "?") + "msg=" + msg + "#p" + productId);
    }
}
