package controller;

import DAO.UserAddressDAO;
import model.UserAddress;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewAddressServlet", urlPatterns = {"/ViewAddress"})
public class ViewAddressServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("user");

        if (loggedInUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        UserAddressDAO dao = new UserAddressDAO();
        List<UserAddress> addressList = dao.getAddressesByUserId(loggedInUser.getId());

        request.setAttribute("addressList", addressList);
        request.getRequestDispatcher("/WEB-INF/include/view-addresses.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("user");

        if (loggedInUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        UserAddressDAO dao = new UserAddressDAO();

        if ("add".equals(action)) {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String specificAddress = request.getParameter("specificAddress");
            boolean isDefault = request.getParameter("defaultAddress") != null;

            UserAddress address = new UserAddress();
            address.setUserId(loggedInUser.getId());
            address.setFullName(fullName);
            address.setPhone(phone);
            address.setSpecificAddress(specificAddress);
            address.setDefaultAddress(isDefault);

            if (isDefault) {
                dao.clearDefaultAddress(loggedInUser.getId());
            }

            dao.addAddress(address);
            request.setAttribute("message", "Đã thêm địa chỉ mới!");

        } else if ("delete".equals(action)) {
            try {
                int addressId = Integer.parseInt(request.getParameter("addressId"));
                dao.deleteAddress(addressId);
                request.setAttribute("message", "Xóa địa chỉ thành công!");
            } catch (Exception e) {
                request.setAttribute("message", "Lỗi khi xóa địa chỉ!");
            }

        } else if ("setDefault".equals(action)) {
            try {
                int addressId = Integer.parseInt(request.getParameter("addressId"));
                boolean success = dao.setOnlyOneDefaultAddress(loggedInUser.getId(), addressId);
                if (success) {
                    request.setAttribute("message", "Đã cập nhật địa chỉ mặc định!");
                } else {
                    request.setAttribute("message", "Địa chỉ đã là mặc định.");
                }
            } catch (Exception e) {
                request.setAttribute("message", "Lỗi khi đặt mặc định!");
            }
        }

        // Load lại danh sách địa chỉ
        List<UserAddress> addressList = dao.getAddressesByUserId(loggedInUser.getId());
        request.setAttribute("addressList", addressList);

        request.getRequestDispatcher("/WEB-INF/include/view-addresses.jsp").forward(request, response);
    }
}
