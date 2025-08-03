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
import DAO.RatingDAO;
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
        ProductDAO productDAO = new ProductDAO();
        RatingDAO ratingDAO = new RatingDAO();

        try {
            List<Product> pcList = productDAO.getAllPC();

            // Lấy map rating trung bình và số lượt
            Map<Integer, Double> avgStars = ratingDAO.getAverageStars();
            Map<Integer, Integer> ratingCounts = ratingDAO.getRatingCounts();

            // Gán vào từng sản phẩm
            for (Product pc : pcList) {
                int pid = pc.getProductId();
                pc.setAvgStars(avgStars.getOrDefault(pid, 0.0));
                pc.setTotalRatings(ratingCounts.getOrDefault(pid, 0));
            }

            req.setAttribute("pcList", pcList);
            req.getRequestDispatcher("/WEB-INF/include/listPC.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi hệ thống!");
        }
    }
}
