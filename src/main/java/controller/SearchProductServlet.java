/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.ProductDAO;
import model.Product;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;
/**
 *
 * @author ThinhLVCE181726 <your.name at your.org>
 */

@WebServlet("/search")
public class SearchProductServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");

        ProductDAO productDAO = new ProductDAO();
        List<Product> resultList = productDAO.searchProducts(keyword);

        // Đây là tên attribute mà viewComponent.jsp đang sử dụng!
        request.setAttribute("componentList", resultList);

        // Hiển thị tiêu đề kết quả tìm kiếm trên trang
        request.setAttribute("category", "Kết quả tìm kiếm cho: " + keyword);

        // Nếu không có sản phẩm, có thể gửi thông báo cho view hiển thị
        if (resultList == null || resultList.isEmpty()) {
            request.setAttribute("errorMessage", "Không tìm thấy sản phẩm phù hợp.");
        }

        // Forward về viewComponent.jsp để dùng giao diện đồng bộ!
        request.getRequestDispatcher("/WEB-INF/include/viewComponent.jsp").forward(request, response);
    }
}