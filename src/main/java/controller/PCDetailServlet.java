package controller;

import DAO.ProductDAO;
import DAO.RatingDAO;
import model.Product;
import model.Rating;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

/**
 * Servlet hiển thị chi tiết PC và đánh giá người dùng
 *
 * @author Thinh
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

            ProductDAO productDAO = new ProductDAO();
            Product pc = productDAO.getPCById(pcId); // lấy thông tin sản phẩm

            if (pc == null) {
                resp.sendError(404, "PC not found!");
                return;
            }

            RatingDAO ratingDAO = new RatingDAO();
            List<Rating> ratings = ratingDAO.getRatingsByProductId(pcId); // lấy danh sách đánh giá

            req.setAttribute("pc", pc);
            req.setAttribute("ratings", ratings); // gán vào attribute để hiển thị ở JSP

            // Nếu cần show thêm componentList (linh kiện), thêm tại đây
            // List<Product> components = productDAO.getPCComponents(pcId);
            // req.setAttribute("componentList", components);
            req.getRequestDispatcher("/WEB-INF/include/pc-detail.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendError(400, "Invalid PC ID format!");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Server Error!");
        }
    }
}
