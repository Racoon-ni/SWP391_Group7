/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.ProductDAO;
import model.Product;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
/**
 *
 * @author ThinhLVCE181726 <your.name at your.org>
 */
@WebServlet(name = "PcDetailServlet", urlPatterns = {"/pcDetail"})
public class PCDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
        String pcIdStr = req.getParameter("pcId");
        if (pcIdStr == null) {
            resp.sendError(400, "PC ID is required!");
            return;
        }
        try {
            int pcId = Integer.parseInt(pcIdStr);
            ProductDAO dao = new ProductDAO();
            Product pc = dao.getPCById(pcId); // phương thức lấy chi tiết 1 PC từ DB
            if (pc == null) {
                resp.sendError(404, "PC not found!");
                return;
            }
            req.setAttribute("pc", pc);
            // Nếu muốn show linh kiện thành phần (nếu là PC build sẵn), lấy thêm ở đây, ví dụ:
            // List<Product> componentList = dao.getPCComponents(pcId);
            // req.setAttribute("componentList", componentList);

            req.getRequestDispatcher("/WEB-INF/include/pc-detail.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Server Error!");
        }
    }
}