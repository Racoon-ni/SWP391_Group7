package controller;

import DAO.CategoriesDAO;
import DAO.ProductDAO;
import model.Product;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Category;

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

        List<Category> categoryList = new ArrayList<>();

        try {
            if (parentId != null) {
                categoryList = new CategoriesDAO().getChildCategories(parentId);
            } 
        } catch (Exception ex) {
            Logger.getLogger(ViewComponentServlet.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Lỗi khi truy xuất dữ liệu.");
        }

        request.setAttribute("componentList", categoryList);
        request.setAttribute("category", categoryKey);
        request.getRequestDispatcher("/WEB-INF/include/viewComponent.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Hiển thị danh sách sản phẩm theo category cha bằng parent_id.";
    }
}
