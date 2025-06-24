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
        // Map ánh xạ key từ URL sang parent_id trong DB
        Map<String, Integer> parentCategoryMap = new HashMap<>();
        parentCategoryMap.put("PC", 40);
        parentCategoryMap.put("CPU", 14);
        parentCategoryMap.put("Mainboard", 28);
        parentCategoryMap.put("RAM", 8);
        parentCategoryMap.put("Storage", 2);
        parentCategoryMap.put("GPU", 35);
        parentCategoryMap.put("PSU", 22);
        parentCategoryMap.put("Case", 4);

        String categoryKey = request.getParameter("category");
        Integer parentId = parentCategoryMap.get(categoryKey);

        List<Product> productList = new ArrayList<>();
        String errorMessage = null;

        try {
            if (parentId == null) {
                errorMessage = "Danh mục không hợp lệ.";
            } else {
                try {
                    productList = new CategoriesDAO().getProductsByParentCategoryId(parentId);
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
