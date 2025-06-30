/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author ThinhLVCE181726 <your.name at your.org>
 */
package controller;

import DAO.ProductDAO;
import model.Product;
import java.io.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;


@WebServlet("/listPC")
public class ListPCServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
        ProductDAO dao = new ProductDAO();
        try {
            List<Product> pcList = dao.getAllPC();
            req.setAttribute("pcList", pcList);
            // lỗi truy cập vào trang !!!
            req.getRequestDispatcher("/WEB-INF/include/listPC.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi hệ thống!");
        }
    }
}
