package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Order;
import repository.orderDAO;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "MyOrderServlet", urlPatterns = {"/my-orders"})
public class MyOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        orderDAO dao = new orderDAO();
        List<Order> orders = dao.getOrdersByUserId(userId);

        request.setAttribute("orders", orders);

        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/include/myOrders.jsp");
        rd.forward(request, response);
    }
}
