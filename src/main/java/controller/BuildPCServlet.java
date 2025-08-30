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

        // 1) Build map
        @SuppressWarnings("unchecked")
        Map<String, Product> build = (Map<String, Product>) session.getAttribute("currentBuild");
        if (build == null) {
            build = new LinkedHashMap<>();
            session.setAttribute("currentBuild", build);
        }

        // 2) Skip set
        @SuppressWarnings("unchecked")
        Set<String> skipSet = (Set<String>) session.getAttribute("skippedComponents");
        if (skipSet == null) {
            skipSet = new HashSet<>();
            session.setAttribute("skippedComponents", skipSet);
        }

        // 3) Qty map (mặc định 1)
        @SuppressWarnings("unchecked")
        Map<String, Integer> qtyMap = (Map<String, Integer>) session.getAttribute("qtyMap");
        if (qtyMap == null) {
            qtyMap = new HashMap<>();
            for (String t : COMPONENTS) {
                qtyMap.put(t, 1);
            }
            session.setAttribute("qtyMap", qtyMap);
        }

        // 4) Tính tổng theo số lượng
        double total = 0;
        for (Map.Entry<String, Product> e : build.entrySet()) {
            Product p = e.getValue();
            if (p == null) {
                continue;
            }
            int q = Math.max(1, qtyMap.getOrDefault(e.getKey(), 1));
            total += p.getPrice() * q;
        }

        // 5) Mainboard đã chọn?
        boolean mainboardSelected = build.containsKey("Mainboard") && build.get("Mainboard") != null;

        // 6) skipMap cho JSP
        Map<String, Boolean> skipMap = new HashMap<>();
        for (String t : COMPONENTS) {
            if (skipSet.contains(t)) {
                skipMap.put(t, true);
            }
        }

        // 7) completed count = số đã chọn + đã skip
        int completedCount = build.size() + skipSet.size();

        // 8) set attribute
        request.setAttribute("total", total);
        request.setAttribute("mainboardSelected", mainboardSelected);
        request.setAttribute("components", Arrays.asList(COMPONENTS));
        request.setAttribute("build", build);
        request.setAttribute("skipMap", skipMap);
        request.setAttribute("completedCount", completedCount);
        request.setAttribute("qtyMap", qtyMap);

        request.getRequestDispatcher("/WEB-INF/include/build-pc.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type");
        String productIdStr = request.getParameter("productId");
        String skip = request.getParameter("skip");
        String qtyStr = request.getParameter("qty");     // dùng chung nếu sau này mở rộng
        String ramQtyStr = request.getParameter("ramQty");  // form riêng cho RAM

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

        @SuppressWarnings("unchecked")
        Map<String, Integer> qtyMap = (Map<String, Integer>) session.getAttribute("qtyMap");
        if (qtyMap == null) {
            qtyMap = new HashMap<>();
            session.setAttribute("qtyMap", qtyMap);
        }

        // 1) Cập nhật số lượng (ưu tiên RAM)
        if (ramQtyStr != null && "RAM".equalsIgnoreCase(type)) {
            try {
                int q = Integer.parseInt(ramQtyStr);
                if (q < 1) {
                    q = 1;
                }
                qtyMap.put("RAM", q);
            } catch (NumberFormatException ignored) {
            }
        } else if (qtyStr != null && type != null) {
            try {
                int q = Integer.parseInt(qtyStr);
                if (q < 1) {
                    q = 1;
                }
                qtyMap.put(type, q);
            } catch (NumberFormatException ignored) {
            }
        } // 2) Skip linh kiện
        else if (skip != null && type != null) {
            build.remove(type);
            skipSet.add(type);
        } // 3) Chọn/đổi sản phẩm
        else if (productIdStr != null && type != null) {
            skipSet.remove(type);
            int pid = Integer.parseInt(productIdStr);
            Product p = new ProductDAO().getProductById(pid);

            // Nếu đổi Mainboard khác hãng → clear tất cả trừ Mainboard + reset qty
            if ("Mainboard".equals(type) && build.get("Mainboard") != null) {
                String oldMain = build.get("Mainboard").getName().toLowerCase();
                boolean oldAmd = oldMain.contains("amd");
                boolean oldIntel = oldMain.contains("intel");
                String newMain = p.getName().toLowerCase();
                boolean newAmd = newMain.contains("amd");
                boolean newIntel = newMain.contains("intel");
                if ((oldAmd && newIntel) || (oldIntel && newAmd)) {
                    build.keySet().removeIf(k -> !"Mainboard".equals(k));
                    for (String k : COMPONENTS) {
                        qtyMap.put(k, 1);
                    }
                }
            }
            build.put(type, p);
            if ("RAM".equals(type)) {
                qtyMap.putIfAbsent("RAM", 1);
            }
        }

        session.setAttribute("currentBuild", build);
        session.setAttribute("skippedComponents", skipSet);
        session.setAttribute("qtyMap", qtyMap);

        response.sendRedirect(request.getContextPath() + "/BuildPC");
    }

    @Override
    public String getServletInfo() {
        return "Servlet để build PC";
    }
}
