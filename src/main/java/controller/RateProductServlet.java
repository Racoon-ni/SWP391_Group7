package controller;

import DAO.orderDAO;
import DAO.RatingDAO;
import model.OrderDetail;
import model.User;
import model.Rating;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/rateProduct")
public class RateProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login?msg=not_login");
            return;
        }
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            User user = (User) session.getAttribute("user");
            int userId = user.getId();

            // Lấy danh sách các sản phẩm trong đơn hàng, check rated cho từng sp
            orderDAO dao = new orderDAO();
            List<OrderDetail> orderDetails = dao.getOrderDetails(orderId, userId);

            request.setAttribute("orderDetails", orderDetails);
            request.setAttribute("orderId", orderId);

            request.getRequestDispatcher("/WEB-INF/include/rate-product.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("my-orders?msg=rating_fail");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login?msg=not_login");
            return;
        }
        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        try {
            String[] productIds = request.getParameterValues("productIds[]");
            String[] starsArr = request.getParameterValues("stars[]");
            String[] comments = request.getParameterValues("comments[]");
            String orderIdStr = request.getParameter("orderId");

            if (productIds == null || starsArr == null || comments == null || orderIdStr == null) {
                response.sendRedirect("my-orders?msg=rating_fail");
                return;
            }
            int orderId = Integer.parseInt(orderIdStr);

            RatingDAO ratingDAO = new RatingDAO();
            boolean allRatedAlready = true; // flag: tất cả sản phẩm đã đánh giá rồi?
            boolean hasRatedNew = false;    // flag: có cái nào vừa đánh giá thành công?

            for (int i = 0; i < productIds.length; i++) {
                if (starsArr[i] == null || starsArr[i].isEmpty() || comments[i] == null) {
                    continue;
                }
                int productId = Integer.parseInt(productIds[i]);
                if (ratingDAO.hasUserRatedInOrder(userId, orderId, productId)) {
                    continue; // đã đánh giá rồi thì bỏ qua, không lưu
                }

                int stars = Integer.parseInt(starsArr[i]);
                String comment = comments[i];

                if (comment == null || comment.trim().isEmpty()) {
                    continue;
                }

                Rating rating = new Rating();
                rating.setUserId(userId);
                rating.setOrderId(orderId); // Lưu cả orderId vào Rating
                rating.setProductId(productId);
                rating.setStars(stars);
                rating.setComment(comment);

                boolean success = ratingDAO.addRating(rating);
                if (success) {
                    hasRatedNew = true;
                    allRatedAlready = false;
                } else {
                    allRatedAlready = false; // Có cái chưa đánh giá nhưng lỗi khi thêm
                }
            }
            if (hasRatedNew) {
                response.sendRedirect("my-orders?msg=rating_success");
            } else if (allRatedAlready) {
                response.sendRedirect("my-orders?msg=already_rated");
            } else {
                response.sendRedirect("my-orders?msg=rating_fail");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("my-orders?msg=error");
        }
    }

}
