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
import DAO.WishlistDAO;
import jakarta.servlet.http.HttpSession;
import model.Wishlist;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import model.User;

/**
 *
 * @author Long
 */
@WebServlet(name = "AddToWishlistServlet", urlPatterns = {"/AddToWishlist"})
public class AddToWishlistServlet extends HttpServlet {

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
        processRequest(request, response);
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
        response.setContentType("application/json; charset=UTF-8");

        // Lấy userId từ session (giả sử đã đăng nhập)
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Integer userId = user.getId(); // Key này phải giống ở login

        // Đọc productId từ URL query string hoặc JSON body (tùy phía client truyền lên)
        String productIdParam = request.getParameter("productId");
        int productId = -1;
        if (productIdParam != null) {
            productId = Integer.parseInt(productIdParam);
        }

        PrintWriter out = response.getWriter();

        if (userId == null) {
            out.print("{\"success\": false, \"message\": \"Vui lòng đăng nhập để sử dụng wishlist.\"}");
            return;
        }
        if (productId <= 0) {
            out.print("{\"success\": false, \"message\": \"Thiếu hoặc sai mã sản phẩm.\"}");
            return;
        }

        try {
            WishlistDAO wishlistDAO = new WishlistDAO();
            if (wishlistDAO.isInWishlist(userId, productId)) {
                out.print("{\"success\": false, \"message\": \"Sản phẩm đã có trong danh sách yêu thích.\"}");
            } else {
                Wishlist wishlist = new Wishlist();
                wishlist.setUserId(userId);
                wishlist.setProductId(productId);
                boolean result = wishlistDAO.addToWishlist(wishlist);
                if (result) {
                    out.print("{\"success\": true, \"message\": \"Đã thêm vào danh sách yêu thích!\"}");
                } else {
                    out.print("{\"success\": false, \"message\": \"Không thể thêm vào danh sách yêu thích.\"}");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Có lỗi khi thao tác với cơ sở dữ liệu.\"}");
        }
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
