package controller;


import DAO.CartDAO;
import DAO.UserDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.Cart;
import model.User;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        int userId = sessionUser.getId();

        String[] selectedItemIds = request.getParameterValues("selectedItems");
        if (selectedItemIds == null || selectedItemIds.length == 0) {
            request.setAttribute("error", "Vui lòng chọn ít nhất một sản phẩm để thanh toán.");
            response.sendRedirect("cart.jsp");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        List<Cart> allItems = cartDAO.getCartItemsByUserId(userId);
        List<Cart> selectedItems = new ArrayList<>();

        for (String idStr : selectedItemIds) {
            try {
                int id = Integer.parseInt(idStr);
                for (Cart item : allItems) {
                    if (item.getCartItemId() == id) {
                        selectedItems.add(item);
                        break;
                    }
                }
            } catch (NumberFormatException e) {
                // Ignore invalid IDs
            }
        }

        double totalAmount = cartDAO.calculateTotal(selectedItems);

        UserDAO userDAO = new UserDAO();
        User fullUser = userDAO.getUserByIdForCheckout(userId);

        request.setAttribute("userInfo", fullUser);
        session.setAttribute("cartItems", selectedItems);
        request.setAttribute("totalAmount", totalAmount);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/include/checkout.jsp");
        dispatcher.forward(request, response);
    }
}
