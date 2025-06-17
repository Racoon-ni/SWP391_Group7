package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;

@WebServlet(name = "OrderDetailsServlet", urlPatterns = {"/order-details"})
public class OrderDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Gửi về trang chi tiết đơn hàng trong WEB-INF
        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/include/orderDetails.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response); // Dùng chung xử lý với GET
    }

    @Override
    public String getServletInfo() {
        return "Hiển thị chi tiết đơn hàng";
    }
}
