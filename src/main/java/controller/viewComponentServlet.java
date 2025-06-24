/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Product;

/**
 *
 * @author NghiLTTCE182357
 */
@WebServlet(name = "ViewComponentServlet", urlPatterns = {"/ViewComponentServlet"})
public class ViewComponentServlet extends HttpServlet {

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
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ViewComponentServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewComponentServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
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
        String category = request.getParameter("category"); // Lấy category từ URL

        List<Product> productList = new ArrayList<>();

        try {
            // Kiểm tra category và lấy danh sách sản phẩm từ DAO
            if ("RAM".equals(category)) {
                productList = new ProductDAO().getProductsByCategory("RAM");
            } else if ("SeriesCPU".equals(category)) {
                productList = new ProductDAO().getProductsByCategory("Series CPU");
            } else if ("TheHeCPU".equals(category)) {
                productList = new ProductDAO().getProductsByCategory("Thế hệ CPU");
            } else {
                productList = new ProductDAO().getAllComponents();
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ViewComponentServlet.class.getName()).log(Level.SEVERE, null, ex);
            // Optional: You can set an error message in request for display in JSP
            request.setAttribute("errorMessage", "Lỗi kết nối cơ sở dữ liệu. Vui lòng thử lại.");
        }

        request.setAttribute("componentList", productList);
        request.getRequestDispatcher("/WEB-INF/include/viewComponent.jsp").forward(request, response);
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
        doGet(request, response); // Gọi lại GET để xử lý chung
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
