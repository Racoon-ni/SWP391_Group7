package controller;

import DAO.CategoriesDAO;
import model.Category;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Product;

@WebServlet(name = "ViewComponentServlet", urlPatterns = {"/ViewComponent"})
public class ViewComponentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Map ánh xạ key từ URL sang category_id trong DB
        Map<String, Integer> categoryMap = new HashMap<>();
        categoryMap.put("PC", 1);
        categoryMap.put("CPU", 2);
        categoryMap.put("RAM", 3);
        categoryMap.put("Mainboard", 4);
        categoryMap.put("VGA", 5);
        categoryMap.put("SSD", 6);
        categoryMap.put("HDD", 7);
        categoryMap.put("PSU", 8);
        categoryMap.put("Case", 9);
        categoryMap.put("Tản nhiệt", 10);
        categoryMap.put("Màn hình", 11);
        categoryMap.put("Bàn phím", 12);
        categoryMap.put("Chuột", 13);

        String categoryKey = request.getParameter("category");
        Integer categoryId = categoryMap.get(categoryKey);

        List<Product> productList = new ArrayList<>();
        String errorMessage = null;

        try {
            if (categoryId == null) {
                errorMessage = "Danh mục không hợp lệ.";
            } else {
                try {
                    productList = new CategoriesDAO().getProductsByCategoryId(categoryId);
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(ViewComponentServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ViewComponentServlet.class.getName()).log(Level.SEVERE, null, ex);
            errorMessage = "Lỗi khi truy xuất dữ liệu: " + ex.getMessage();
        }

        request.setAttribute("componentList", productList);
        request.setAttribute("category", categoryKey);
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/WEB-INF/include/viewComponent.jsp").forward(request, response);
    }
}


