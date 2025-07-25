package controller;

import DAO.CartDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import model.User;
//Clear
@WebServlet(name = "ClearCartServlet", urlPatterns = {"/clearCart"})
public class ClearCartServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy userId từ session
        HttpSession session = request.getSession(false); // Không tạo mới nếu chưa có session
        if (session == null || session.getAttribute("user") == null) {
            // Nếu chưa đăng nhập, chuyển hướng về trang login
            response.sendRedirect("login?msg=not_login");
            return;
        }

        User user = (User) session.getAttribute("user"); // Lấy đối tượng User từ session
        Integer userId = user.getId();  // Lấy user_id từ đối tượng User

        // Debug log để kiểm tra userId
        System.out.println("User ID in session: " + userId);  // Kiểm tra userId trong session

        try {
            // Xóa tất cả các sản phẩm trong giỏ hàng của người dùng
            CartDAO cartDAO = new CartDAO();
            cartDAO.clearCartByUserId(userId);  // Truyền userId để xóa giỏ hàng của người dùng

            // Sau khi xóa, chuyển hướng về trang giỏ hàng để thấy kết quả mới
            response.sendRedirect(request.getContextPath() + "/my-carts");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/my-carts?error=exception");
        }
    }
}
