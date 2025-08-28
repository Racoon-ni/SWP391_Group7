package controller;

import DAO.CartDAO;
import DAO.UserAddressDAO;
import DAO.UserDAO;
import DAO.VoucherDAO;
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
import model.Voucher;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private void loadAndForward(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        @SuppressWarnings("unchecked")
        List<Cart> selectedItems = (List<Cart>) (session != null ? session.getAttribute("cartItems") : null);
        CartDAO cartDAO = new CartDAO();
        if (selectedItems == null || selectedItems.isEmpty()) {
            selectedItems = cartDAO.getCartItemsByUserId(userId);
            if (session != null) {
                session.setAttribute("cartItems", selectedItems);
            }
        }

        double totalAmount = cartDAO.calculateTotal(selectedItems);

        UserDAO userDAO = new UserDAO();
        User fullUser = userDAO.getUserByIdForCheckout(userId);

        UserAddressDAO addressDAO = new UserAddressDAO();
        List<UserAddress> addressList = addressDAO.getAddressesByUserId(userId);

        request.setAttribute("userInfo", fullUser);
        request.setAttribute("addressList", addressList);
        request.setAttribute("cartItems", selectedItems);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("finalAmount", totalAmount);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/include/checkout.jsp");
        dispatcher.forward(request, response);
    }

    private User checkLoginOrRedirect(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return null;
        }
        return (User) session.getAttribute("user");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User sessionUser = checkLoginOrRedirect(request, response);
        if (sessionUser == null) return;

        loadAndForward(request, response, sessionUser.getId());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = checkLoginOrRedirect(request, response);
        if (sessionUser == null) return;

        int userId = sessionUser.getId();

        String productIdParam = request.getParameter("productId");
        String[] selectedItemIds = request.getParameterValues("selectedItems");

        List<Cart> selectedItems = new ArrayList<>();
        CartDAO cartDAO = new CartDAO();

        if (productIdParam != null) {
            // ✅ Flow "Mua ngay"
            try {
                int productId = Integer.parseInt(productIdParam);

                try {
                    int currentQty = cartDAO.getCartQuantity(userId, productId);
                    int stock = cartDAO.getProductStock(productId);

                    if (currentQty >= stock) {
                        response.sendRedirect(request.getContextPath() + "/ViewComponentDetail?productId=" + productId + "&msg=maxed");
                        return;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/ViewComponentDetail?productId=" + productId + "&msg=error");
                    return;
                }

                Cart singleItem = cartDAO.getCartItemForBuyNow(productId);
                if (singleItem != null) selectedItems.add(singleItem);
            } catch (NumberFormatException ignored) {}
        } else if (selectedItemIds != null && selectedItemIds.length > 0) {
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
                } catch (NumberFormatException ignored) {}
            }
        } else {
            selectedItems = cartDAO.getCartItemsByUserId(userId);
        }

        double totalAmount = cartDAO.calculateTotal(selectedItems);

        // Áp voucher nếu có
        String voucherCode = request.getParameter("voucherCode");
        String voucherMessage = null;
        double discountAmount = 0;
        Voucher appliedVoucher = null;

        if (voucherCode != null && !voucherCode.trim().isEmpty()) {
            VoucherDAO voucherDAO = new VoucherDAO();
            appliedVoucher = voucherDAO.getVoucherByCode(voucherCode.trim());

            if (appliedVoucher == null) {
                voucherMessage = "Mã voucher không tồn tại.";
            } else if (!voucherDAO.userHasVoucher(userId, appliedVoucher.getVoucherId())) {
                voucherMessage = "Bạn chưa lấy mã này.";
            } else if (appliedVoucher.getExpiredAt().before(new Date())) {
                voucherMessage = "Mã voucher đã hết hạn.";
            } else if (totalAmount < appliedVoucher.getMinOrderValue()) {
                voucherMessage = String.format("Đơn hàng tối thiểu %,.0f₫ để sử dụng mã này.", appliedVoucher.getMinOrderValue());
            } else {
                discountAmount = totalAmount * appliedVoucher.getDiscountPercent() / 100.0;
                totalAmount -= discountAmount;
                voucherMessage = String.format("Áp dụng thành công: -%d%% (%,.0f₫)",
                        appliedVoucher.getDiscountPercent(), discountAmount);
            }
        }

        UserDAO userDAO = new UserDAO();
        User fullUser = userDAO.getUserByIdForCheckout(userId);

        UserAddressDAO addressDAO = new UserAddressDAO();
        List<UserAddress> addressList = addressDAO.getAddressesByUserId(userId);

        request.setAttribute("userInfo", fullUser);
        request.setAttribute("addressList", addressList);
        request.setAttribute("cartItems", selectedItems);
        request.setAttribute("totalAmount", totalAmount);

        request.setAttribute("voucherMessage", voucherMessage);
        request.setAttribute("discountAmount", discountAmount);
        request.setAttribute("appliedVoucher", appliedVoucher);
        request.setAttribute("finalAmount", totalAmount);

        HttpSession session = request.getSession();
        session.setAttribute("cartItems", selectedItems);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/include/checkout.jsp");
        dispatcher.forward(request, response);
    }
}
