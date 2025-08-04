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
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Long
 */
@WebServlet(name = "SelectComponentServlet", urlPatterns = {"/SelectComponent"})
public class SelectComponentServlet extends HttpServlet {

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

    }
    private final ProductDAO dao = new ProductDAO();

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
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String type = req.getParameter("type");
        if (type == null) {
            resp.sendRedirect(req.getContextPath() + "/BuildPC");
            return;
        }

        // Lấy Mainboard đã chọn để lọc CPU/RAM
        HttpSession session = req.getSession();
        @SuppressWarnings("unchecked")
        Map<String, Product> build = (Map<String, Product>) session.getAttribute("currentBuild");
        Product main = (build != null) ? build.get("Mainboard") : null;

        List<Product> list = null;
        if ("CPU".equals(type) && main != null) {
            list = new ArrayList<>();
            List<Product> all = null;
            try {
                all = dao.getProductsByCategory("CPU");
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(SelectComponentServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            String info = (main.getName() + " " + main.getDescription()).toLowerCase();
            for (Product cpu : all) {
                String nm = cpu.getName().toLowerCase();
                if ((info.contains("amd") && nm.contains("amd"))
                        || (info.contains("intel") && nm.contains("intel"))) {
                    list.add(cpu);
                }
            }
        } else if ("ram".equals(type) && main != null) {
            list = new ArrayList<>();
            List<Product> all = null;
            try {
                all = dao.getProductsByCategory("ram");
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(SelectComponentServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            String info = (main.getName() + " " + main.getDescription()).toLowerCase();
            for (Product ram : all) {
                String nm = ram.getName().toLowerCase();
                // Lọc theo DDR4/DDR5 dựa trên description mainboard
                if ((info.contains("ddr4") && nm.contains("ddr4"))
                        || (info.contains("ddr5") && nm.contains("ddr5"))) {
                    list.add(ram);
                }
            }
        } else {
            try {
                // load toàn bộ loại
                list = dao.getProductsByCategory(type);
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(SelectComponentServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        req.setAttribute("list", list);
        req.setAttribute("type", type);
        req.getRequestDispatcher("/WEB-INF/include/select-component.jsp")
                .forward(req, resp);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Tương tự BuildPCServlet.doPost, nhưng chỉ add rồi redirect
        String type = req.getParameter("type");
        String pid = req.getParameter("productId");

        if (type != null && pid != null) {
            int id = Integer.parseInt(pid);
            Product p = dao.getProductById(id);
            HttpSession session = req.getSession();
            @SuppressWarnings("unchecked")
            Map<String, Product> build = (Map<String, Product>) session.getAttribute("currentBuild");
            if (build == null) {
                build = new LinkedHashMap<>();
            }
            build.put(type, p);
            session.setAttribute("currentBuild", build);
        }
        resp.sendRedirect(req.getContextPath() + "/BuildPC");
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
