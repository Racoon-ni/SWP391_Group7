package controller;

import DAO.CartDAO;
import DAO.UserAddressDAO;
import DAO.UserDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cart;
import model.User;
import model.UserAddress;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

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

       String productIdParam = request.getParameter("productId");
       String[] selectedItemIds = request.getParameterValues("selectedItems");

       List<Cart> selectedItems = new ArrayList<>();
       CartDAO cartDAO = new CartDAO();

       if (productIdParam != null) {
           // ✅ Mua ngay: chỉ lấy 1 sản phẩm
           try {
               int productId = Integer.parseInt(productIdParam);
               Cart singleItem = cartDAO.getCartItemForBuyNow(productId);
               if (singleItem != null) {
                   selectedItems.add(singleItem);
               }
           } catch (NumberFormatException e) {
               e.printStackTrace();
           }

       } else if (selectedItemIds != null && selectedItemIds.length > 0) {
           // ✅ Mua từ giỏ hàng: lấy sản phẩm được chọn
           List<Cart> allItems = cartDAO.getCartItemsByUserId(userId);
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
                   e.printStackTrace();
               }
           }

       } else {
           // ✅ fallback: mua toàn bộ giỏ hàng
           selectedItems = cartDAO.getCartItemsByUserId(userId);
       }

       double totalAmount = cartDAO.calculateTotal(selectedItems);

       UserDAO userDAO = new UserDAO();
       User fullUser = userDAO.getUserByIdForCheckout(userId);

       UserAddressDAO addressDAO = new UserAddressDAO();
       List<UserAddress> addressList = addressDAO.getAddressesByUserId(userId);

       request.setAttribute("userInfo", fullUser);
       request.setAttribute("addressList", addressList);
       request.setAttribute("totalAmount", totalAmount);
       session.setAttribute("cartItems", selectedItems);

       RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/include/checkout.jsp");
       dispatcher.forward(request, response);
   }
}
