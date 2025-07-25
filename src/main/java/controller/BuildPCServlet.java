/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.ProductDAO;
import DAO.CategoryDAO;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

/**
 *
 * @author Long
 */
@WebServlet(name = "BuildPCServlet", urlPatterns = {"/BuildPC"})
public class BuildPCServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        // Danh sách các loại linh kiện cần build

    }
    private static final String[] COMPONENTS = {
        "Mainboard", "CPU", "RAM", "VGA", "SSD", "HDD", "PSU", "Case", "Tản nhiệt"
    };
// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Lấy build hiện tại từ session (Map<String, Product>)
        Map<String, Product> build = (Map<String, Product>) session.getAttribute("currentBuild");
        if (build == null) {
            build = new LinkedHashMap<>();
            session.setAttribute("currentBuild", build);
        }

        // Tổng tiền
        double total = 0;
        for (Product p : build.values()) {
            if (p != null) {
                total += p.getPrice();
            }
        }
        request.setAttribute("total", total);

        // Mainboard đã chọn chưa?
        boolean mainboardSelected = build.containsKey("Mainboard") && build.get("Mainboard") != null;

        request.setAttribute("mainboardSelected", mainboardSelected);
        request.setAttribute("components", COMPONENTS);
        request.setAttribute("build", build);

        request.getRequestDispatcher("/WEB-INF/include/build-pc.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    // Khi chọn linh kiện -> lưu vào build (session), redirect về build-pc
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");      // Loại linh kiện
        String productIdStr = request.getParameter("productId");

        if (type != null && productIdStr != null) {
            int productId = Integer.parseInt(productIdStr);
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(productId);

            // Lưu vào session
            HttpSession session = request.getSession();
            Map<String, Product> build = (Map<String, Product>) session.getAttribute("currentBuild");
            if (build == null) build = new LinkedHashMap<>();
            build.put(type, product);
            session.setAttribute("currentBuild", build);
        }
        response.sendRedirect(request.getContextPath() + "/BuildPC");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
