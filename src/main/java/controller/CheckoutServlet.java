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
import jakarta.servlet.http.*;
import model.Cart;
import model.User;
import model.UserAddress;
import model.Voucher;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
// 1) Kiểm tra login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        int userId = sessionUser.getId();
// 2) Lấy danh sách buildProductIds từ form (long)
        String[] buildIds = request.getParameterValues("buildProductIds"); //long
        String productIdParam = request.getParameter("productId");
        String[] selectedItemIds = request.getParameterValues("selectedItems");

        List<Cart> selectedItems = new ArrayList<>();
        CartDAO cartDAO = new CartDAO();
//long
        if (buildIds != null) {
            for (String pidStr : buildIds) {
                try {
                    int pid = Integer.parseInt(pidStr);
                    Cart item = cartDAO.getCartItemForBuyNow(pid);
                    if (item != null) {
                        selectedItems.add(item);
                    }
                } catch (NumberFormatException ignored) {
                }
            }
        }
        //end
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
// 3) Tính tổng trước voucher
        double totalAmount = cartDAO.calculateTotal(selectedItems);
        //4) Xử lý apply voucher (chỉ voucher user đã claim) Long
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
                voucherMessage = String.format(
                        "Đơn hàng tối thiểu %,.0f₫ để sử dụng mã này.",
                        appliedVoucher.getMinOrderValue()
                );
            } else {
                // Áp dụng chiết khấu
                discountAmount = totalAmount * appliedVoucher.getDiscountPercent() / 100.0;
                totalAmount -= discountAmount;
                voucherMessage = String.format(
                        "Áp dụng thành công: -%d%% (%,.0f₫)",
                        appliedVoucher.getDiscountPercent(),
                        discountAmount
                );
            }
        }
        //end
        // 5) Lấy thông tin User & Address
        UserDAO userDAO = new UserDAO();
        User fullUser = userDAO.getUserByIdForCheckout(userId);

        UserAddressDAO addressDAO = new UserAddressDAO();
        List<UserAddress> addressList = addressDAO.getAddressesByUserId(userId);
// 6) Set attributes và forward
        request.setAttribute("userInfo", fullUser);
        request.setAttribute("addressList", addressList);
        request.setAttribute("totalAmount", totalAmount);
        //long
        request.setAttribute("voucherMessage", voucherMessage);
        request.setAttribute("discountAmount", discountAmount);
        request.setAttribute("appliedVoucher", appliedVoucher);
// totalAmount giờ đã là finalAmount

        request.setAttribute("finalAmount", totalAmount);
        // end
        request.setAttribute("totalAmount", totalAmount);
        session.setAttribute("cartItems", selectedItems);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/include/checkout.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/BuildPC");
    }
}
