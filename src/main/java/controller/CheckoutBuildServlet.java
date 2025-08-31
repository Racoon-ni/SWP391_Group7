// File: src/main/java/controller/CheckoutBuildServlet.java
package controller;

import DAO.CartDAO;
import DAO.UserAddressDAO;
import DAO.UserDAO;
import DAO.VoucherDAO;
import model.Cart;
import model.User;
import model.UserAddress;
import model.Voucher;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CheckoutBuildServlet", urlPatterns = {"/CheckoutBuild"})
public class CheckoutBuildServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/BuildPC");
    }

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

        // 2) Lấy danh sách buildProductIds từ form
        String[] buildIds = request.getParameterValues("buildProductIds");
        // Lấy qtyMap từ session
@SuppressWarnings("unchecked")
Map<String, Integer> qtyMap = (Map<String, Integer>) session.getAttribute("qtyMap");
        CartDAO cartDAO = new CartDAO();
        List<Cart> selectedItems = new ArrayList<>();
        if (buildIds != null) {
            for (String pidStr : buildIds) {
                try {
                    int pid = Integer.parseInt(pidStr);
                    Cart item = cartDAO.getCartItemForBuyNow(pid);
                    if (item != null) {
                                        // nếu có qtyMap thì cập nhật lại số lượng
                if (qtyMap != null) {
                    // xác định type theo build
                    @SuppressWarnings("unchecked")
                    Map<String, model.Product> build =
                        (Map<String, model.Product>) session.getAttribute("currentBuild");

                    if (build != null) {
                        for (Map.Entry<String, model.Product> e : build.entrySet()) {
                            if (e.getValue() != null && e.getValue().getProductId() == pid) {
                                int q = qtyMap.getOrDefault(e.getKey(), 1);
                                item.setQuantity(q);
                                break;
                            }
                        }
                    }
                }
                        selectedItems.add(item);
                    }
                } catch (NumberFormatException ignored) {
                }
            }
        }

        // 3) Tính tổng trước voucher
        double totalAmount = cartDAO.calculateTotal(selectedItems);

        // 4) Xử lý apply voucher (chỉ voucher user đã claim)
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

        RequestDispatcher dispatcher
                = request.getRequestDispatcher("/WEB-INF/include/checkoutbuild.jsp");
        dispatcher.forward(request, response);
    }
}
