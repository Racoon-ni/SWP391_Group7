/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import DAO.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;
import model.Product;
import model.User;
/**
 *
 * @author Admin
 */
@WebServlet(name="BuildToCartServlet", urlPatterns={"/BuildToCart"})
public class BuildToCartServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
      @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?msg=not_login");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<String, Product> build = (Map<String, Product>) session.getAttribute("currentBuild");
        if (build == null || build.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/BuildPC?msg=empty_build");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<String, Integer> qtyMap = (Map<String, Integer>) session.getAttribute("qtyMap");

        User u = (User) session.getAttribute("user");
        int userId = u.getId();

        CartDAO cartDAO = new CartDAO();

        try {
            for (Map.Entry<String, Product> e : build.entrySet()) {
                Product p = e.getValue();
                if (p == null) continue;
                int q = 1;
                if (qtyMap != null) q = Math.max(1, qtyMap.getOrDefault(e.getKey(), 1));
                cartDAO.addToCartWithQuantity(userId, p.getProductId(), q);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/BuildPC?msg=to_cart_failed");
            return;
        }

        // Giữ nguyên build để người dùng quay lại chỉnh tiếp (nếu muốn)
        response.sendRedirect(request.getContextPath() + "/my-carts");
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
