package controller;

import DAO.orderDAO;
import DAO.RatingDAO;
import model.OrderDetail;
import model.User;
import model.Rating;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.*;

@WebServlet("/rateProduct")
@MultipartConfig
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
            boolean allRatedAlready = true;
            boolean hasRatedNew = false;

            // Chuẩn hóa đường dẫn: ĐÚNG CHUẨN LUÔN LÀ /include/img (không có dấu +)
            String uploadPath = getServletContext().getRealPath("/include/img");
            System.out.println("Upload path: " + uploadPath); // Log ra để kiểm tra

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            Collection<Part> parts = request.getParts();

            for (int i = 0; i < productIds.length; i++) {
                if (starsArr[i] == null || starsArr[i].isEmpty() || comments[i] == null) {
                    continue;
                }
                int productId = Integer.parseInt(productIds[i]);
                if (ratingDAO.hasUserRatedInOrder(userId, orderId, productId)) {
                    continue;
                }

                int stars = Integer.parseInt(starsArr[i]);
                String comment = comments[i];

                if (comment == null || comment.trim().isEmpty()) {
                    continue;
                }

                // XỬ LÝ ẢNH UPLOAD: Tên input = "images_" + productId
                List<String> imageUrls = new ArrayList<>();
                String inputName = "images_" + productId;
                for (Part part : parts) {
                    if (part.getName().equals(inputName) && part.getSize() > 0) {
                        String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                        String cleanFileName = fileName.replaceAll("[^a-zA-Z0-9._-]", "_");
                        String uniqueFileName = System.currentTimeMillis() + "_" + cleanFileName;
                        String filePath = uploadPath + File.separator + uniqueFileName;
                        part.write(filePath);
                        System.out.println("File saved: " + filePath); // Log kiểm tra đường dẫn
                        imageUrls.add("include/img/" + uniqueFileName);
                    }
                }

                Rating rating = new Rating();
                rating.setUserId(userId);
                rating.setOrderId(orderId);
                rating.setProductId(productId);
                rating.setStars(stars);
                rating.setComment(comment);
                rating.setImageUrls(imageUrls);

                boolean success = ratingDAO.addRating(rating);
                if (success) {
                    hasRatedNew = true;
                    allRatedAlready = false;
                } else {
                    allRatedAlready = false;
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
