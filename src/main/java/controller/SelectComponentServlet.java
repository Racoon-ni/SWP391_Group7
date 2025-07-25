/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import DAO.ProductDAO;
import DAO.CategoryDAO;
import model.Product;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.util.*;

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
        String type = request.getParameter("type"); // Loại linh kiện
        if (type == null) {
            type = "Mainboard";
        }

        // Lấy mainboard hiện tại
        HttpSession session = request.getSession();
        Map<String, Product> build = (Map<String, Product>) session.getAttribute("currentBuild");
        Product selectedMain = (build != null) ? build.get("Mainboard") : null;

        List<Product> list = new ArrayList<>();
        try {
            ProductDAO dao = new ProductDAO();
            // Nếu chọn CPU thì lọc theo loại mainboard
            if (type.equals("CPU") && selectedMain != null) {
                List<Product> allCPU = dao.getProductsByCategory("CPU");
                // Lấy cả name và description để chắc chắn bắt được AMD/Intel
                String mainInfo = (selectedMain.getName() + " " + selectedMain.getDescription()).toLowerCase();
                for (Product cpu : allCPU) {
                    String cpuName = cpu.getName().toLowerCase();
                    if ((mainInfo.contains("amd") && cpuName.contains("amd"))
                            || (mainInfo.contains("intel") && cpuName.contains("intel"))) {
                        list.add(cpu);
                    }
                }
            } else {
                list = dao.getProductsByCategory(type);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("list", list);
        request.setAttribute("type", type);
        request.getRequestDispatcher("/WEB-INF/include/select-component.jsp").forward(request, response);
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
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
