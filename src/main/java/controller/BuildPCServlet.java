/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.ProductDAO;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

/**
 *
 * @author Long
 */
@WebServlet(name = "BuildPCServlet", urlPatterns = {"/BuildPC"})
public class BuildPCServlet extends HttpServlet {
    private static final String[] COMPONENTS = {
        "Mainboard", "CPU", "RAM", "VGA", "SSD", "HDD", "PSU", "Case", "Tản nhiệt"
    };
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // 1) Lấy build map
        @SuppressWarnings("unchecked")
        Map<String, Product> build = (Map<String, Product>) session.getAttribute("currentBuild");
        if (build == null) {
            build = new LinkedHashMap<>();
            session.setAttribute("currentBuild", build);
        }

        // 2) Lấy skip set
        @SuppressWarnings("unchecked")
        Set<String> skipSet = (Set<String>) session.getAttribute("skippedComponents");
        if (skipSet == null) {
            skipSet = new HashSet<>();
            session.setAttribute("skippedComponents", skipSet);
        }

        // 3) Tính total
        double total = build.values().stream()
                            .filter(Objects::nonNull)
                            .mapToDouble(Product::getPrice)
                            .sum();

        // 4) Mainboard đã chọn?
        boolean mainboardSelected =
            build.containsKey("Mainboard") && build.get("Mainboard") != null;

       
        Map<String,Boolean> skipMap = new HashMap<>();
        for (String t : COMPONENTS) {
            if (skipSet.contains(t)) skipMap.put(t, true);
        }

        //  Đếm completed = selected + skipped
        int completedCount = build.size() + skipSet.size();

        //  Đưa vào request
        request.setAttribute("total", total);
        request.setAttribute("mainboardSelected", mainboardSelected);
        request.setAttribute("components", Arrays.asList(COMPONENTS));
        request.setAttribute("build", build);
        request.setAttribute("skipMap", skipMap);
        request.setAttribute("completedCount", completedCount);

        request.getRequestDispatcher("/WEB-INF/include/build-pc.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type         = request.getParameter("type");
        String productIdStr = request.getParameter("productId");
        String skip         = request.getParameter("skip");

        HttpSession session = request.getSession();

        @SuppressWarnings("unchecked")
        Map<String, Product> build = (Map<String, Product>) session.getAttribute("currentBuild");
        if (build == null) {
            build = new LinkedHashMap<>();
        }

        @SuppressWarnings("unchecked")
        Set<String> skipSet = (Set<String>) session.getAttribute("skippedComponents");
        if (skipSet == null) {
            skipSet = new HashSet<>();
        }

        if (skip != null) {
            // 1) Người dùng đánh dấu "Tôi đã có linh kiện này"
            build.remove(type);
            skipSet.add(type);

        } else if (productIdStr != null) {
            // 2) Người dùng chọn lại sản phẩm
            skipSet.remove(type);
            int pid = Integer.parseInt(productIdStr);
            Product p = new ProductDAO().getProductById(pid);

            // 3) Nếu đổi Mainboard khác hãng → clear CPU cũ
            if ("Mainboard".equals(type) && build.get("Mainboard") != null) {
                String oldMain = build.get("Mainboard").getName().toLowerCase();
                boolean oldAmd   = oldMain.contains("amd");
                boolean oldIntel = oldMain.contains("intel");
                String newMain = p.getName().toLowerCase();
                boolean newAmd   = newMain.contains("amd");
                boolean newIntel = newMain.contains("intel");
                if ((oldAmd && newIntel) || (oldIntel && newAmd)) {
                    // xóa tất cả ngoại trừ Mainboard
                    build.keySet().removeIf(k -> !"Mainboard".equals(k));
                }
            }
            build.put(type, p);
        }

        session.setAttribute("currentBuild", build);
        session.setAttribute("skippedComponents", skipSet);
        response.sendRedirect(request.getContextPath() + "/BuildPC");
    }

    @Override
    public String getServletInfo() {
        return "Servlet để build PC";
    }
}