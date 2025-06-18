package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name="MyOrderServlet", urlPatterns={"/my-orders"})
public class MyOrderServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/include/myOrders.jsp");
        rd.forward(request, response);
    }
}
