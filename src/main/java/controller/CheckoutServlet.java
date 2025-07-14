package controller;

<<<<<<< HEAD

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
=======
import DAO.CartDAO;
import DAO.UserDAO;
import model.User;
import model.Cart;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
>>>>>>> fc2302132c71aa13aaed03ea183a3ae763ab616d

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    @Override
<<<<<<< HEAD
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
=======
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
>>>>>>> fc2302132c71aa13aaed03ea183a3ae763ab616d
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        int userId = sessionUser.getId();

<<<<<<< HEAD
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
=======
        UserDAO userDAO = new UserDAO();
        User fullUser = userDAO.getUserByIdForCheckout(userId); // phải lấy đủ info từ DB

        CartDAO cartDAO = new CartDAO();
        List<Cart> cartItems = cartDAO.getCartItemsByUserId(userId);
        double totalAmount = cartDAO.calculateTotal(cartItems);

        request.setAttribute("userInfo", fullUser);
        request.setAttribute("cartItems", cartItems);
>>>>>>> fc2302132c71aa13aaed03ea183a3ae763ab616d
        request.setAttribute("totalAmount", totalAmount);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/include/checkout.jsp");
        dispatcher.forward(request, response);
    }
}
