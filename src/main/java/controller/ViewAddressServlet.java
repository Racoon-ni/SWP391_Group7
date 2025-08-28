package controller;

import DAO.UserAddressDAO;
import model.UserAddress;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewAddressServlet", urlPatterns = {"/ViewAddress"})
public class ViewAddressServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (loggedInUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        UserAddressDAO dao = new UserAddressDAO();
        List<UserAddress> addressList = dao.getAddressesByUserId(loggedInUser.getId());

        request.setAttribute("addressList", addressList);
        // Giữ nguyên các param điều hướng để form có thể mang theo khi submit
        request.getRequestDispatcher("/WEB-INF/include/view-addresses.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (loggedInUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = safe(request.getParameter("action"));
        String from = safe(request.getParameter("from"));        // "checkout" nếu đến từ trang checkout
        String ret = safe(request.getParameter("return"));      // ví dụ: "/checkout"

        UserAddressDAO dao = new UserAddressDAO();
        String message = null;

        try {
            switch (action) {
                case "add": {
                    String fullName = safe(request.getParameter("fullName"));
                    String phone = safe(request.getParameter("phone"));
                    String specificAddress = safe(request.getParameter("specificAddress"));
                    boolean isDefault = request.getParameter("defaultAddress") != null;

                    String error = validate(fullName, phone, specificAddress);
                    if (error != null) {
                        message = error;
                        break; // forward lại trang sổ địa chỉ để hiển thị lỗi
                    }

                    UserAddress address = new UserAddress();
                    address.setUserId(loggedInUser.getId());
                    address.setFullName(fullName.trim());
                    address.setPhone(phone.trim());
                    address.setSpecificAddress(specificAddress.trim());
                    address.setDefaultAddress(isDefault);

                    if (isDefault) {
                        dao.clearDefaultAddress(loggedInUser.getId());
                    }
                    dao.addAddress(address);

                    // *** QUY TẮC: chỉ khi add và đến từ checkout mới quay về checkout
                    if ("checkout".equals(from) && !ret.isEmpty()) {
                        redirectBack(request, response, ret);
                        return;
                    }

                    message = "Đã thêm địa chỉ mới!";
                    break;
                }

                case "edit": {
                    int addressId = Integer.parseInt(request.getParameter("addressId"));
                    String fullName = safe(request.getParameter("fullName"));
                    String phone = safe(request.getParameter("phone"));
                    String specificAddress = safe(request.getParameter("specificAddress"));
                    boolean isDefault = request.getParameter("defaultAddress") != null;

                    String error = validate(fullName, phone, specificAddress);
                    if (error != null) {
                        message = error;
                        break;
                    }

                    if (isDefault) {
                        dao.clearDefaultAddress(loggedInUser.getId());
                    }

                    UserAddress updated = new UserAddress();
                    updated.setId(addressId);
                    updated.setUserId(loggedInUser.getId());
                    updated.setFullName(fullName.trim());
                    updated.setPhone(phone.trim());
                    updated.setSpecificAddress(specificAddress.trim());
                    updated.setDefaultAddress(isDefault);

                    boolean ok = dao.updateAddress(updated);
                    message = ok ? "Cập nhật địa chỉ thành công!" : "Không tìm thấy địa chỉ để cập nhật.";
                    break; // vẫn ở lại trang sổ địa chỉ
                }

                case "delete": {
                    int addressId = Integer.parseInt(request.getParameter("addressId"));
                    dao.deleteAddress(addressId);
                    message = "Xóa địa chỉ thành công!";
                    break; // vẫn ở lại trang sổ địa chỉ
                }

                case "setDefault": {
                    int addressId = Integer.parseInt(request.getParameter("addressId"));
                    boolean success = dao.setOnlyOneDefaultAddress(loggedInUser.getId(), addressId);
                    message = success
                            ? "Đã cập nhật địa chỉ mặc định!"
                            : "Không thể đặt mặc định (không tìm thấy hoặc đã là mặc định).";
                    break; // vẫn ở lại trang sổ địa chỉ
                }

                default:
                    message = "Yêu cầu không hợp lệ.";
            }
        } catch (NumberFormatException nfe) {
            message = "Dữ liệu không hợp lệ.";
        } catch (Exception ex) {
            ex.printStackTrace();
            message = "Đã xảy ra lỗi. Vui lòng thử lại.";
        }

        // Nếu KHÔNG redirect (các case edit/delete/setDefault hoặc add nhưng không đến từ checkout)
        List<UserAddress> addressList = dao.getAddressesByUserId(loggedInUser.getId());
        request.setAttribute("message", message);
        request.setAttribute("addressList", addressList);
        request.getRequestDispatcher("/WEB-INF/include/view-addresses.jsp").forward(request, response);
    }

    private String safe(String v) {
        return v == null ? "" : v.trim();
    }

    private String validate(String fullName, String phone, String specificAddress) {
        if (fullName.isEmpty() || !fullName.matches("(?U)^[\\p{L}][\\p{L}\\s'\\-]*$")) {
            return "Họ tên không hợp lệ.";
        }
        if (phone.isEmpty() || !phone.matches("\\d{9,11}")) {
            return "Số điện thoại phải là 9–11 chữ số.";
        }
        if (specificAddress.isEmpty() || !specificAddress.matches("(?U)^[\\p{L}0-9\\s,\\.\\-/]+$")) {
            return "Địa chỉ không hợp lệ.";
        }
        return null;
    }

    private void redirectBack(HttpServletRequest request, HttpServletResponse response, String returnUrl)
            throws IOException {
        String ctx = request.getContextPath();
        // Hỗ trợ cả "/checkout" và URL tuyệt đối
        if (returnUrl.startsWith("http://") || returnUrl.startsWith("https://")) {
            response.sendRedirect(returnUrl);
        } else if (returnUrl.startsWith("/")) {
            response.sendRedirect(ctx + returnUrl);
        } else {
            response.sendRedirect(ctx + "/" + returnUrl);
        }
    }
}
