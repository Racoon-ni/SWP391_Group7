package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

import model.Banner;
import DAO.BannerDAO;

@WebServlet("/manage-banner")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ManageBannerServlet extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "assets" + File.separator + "images";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        BannerDAO bannerDAO = new BannerDAO();
        req.setAttribute("banners", bannerDAO.getAllBanners());
        req.getRequestDispatcher("/WEB-INF/include/banner.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("upload".equals(action)) {
            handleFileUpload(req, resp);
        } else if ("updateStatus".equals(action)) {
            handleStatusUpdate(req, resp);
        } else {
            resp.sendRedirect("manage-banner?error=true");
        }
    }

    private void handleFileUpload(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Part filePart = req.getPart("bannerFile");
            String fileName = filePart != null ? Paths.get(filePart.getSubmittedFileName()).getFileName().toString() : null;

            if (filePart == null || fileName == null || fileName.isEmpty()) {
                resp.sendRedirect("manage-banner?uploaded=false");
                return;
            }

            String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            if (!isValidImageType(fileExtension)) {
                resp.sendRedirect("manage-banner?uploaded=false&error=invalidtype");
                return;
            }

            // ✅ Lấy Product ID (tùy chọn)
            Integer productId = null;
            String productIdStr = req.getParameter("productId");
            if (productIdStr != null && !productIdStr.trim().isEmpty()) {
                try {
                    int pid = Integer.parseInt(productIdStr.trim());
                    if (pid > 0) productId = pid;
                } catch (NumberFormatException ignored) {}
            }

            // ✅ Lấy link đích (tùy chọn)
            String linkUrl = req.getParameter("linkUrl");
            if (linkUrl != null) linkUrl = linkUrl.trim();
            if (linkUrl != null && linkUrl.isEmpty()) linkUrl = null;

            // Lưu file
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);

            // Tạo đối tượng Banner
            Banner banner = new Banner();
            banner.setImageUrl("/assets/images/" + uniqueFileName);
            banner.setStatus(Integer.parseInt(req.getParameter("status")));
            if (productId != null) banner.setProductId(productId);
            if (linkUrl != null) banner.setTargetUrl(linkUrl);

            // Lưu DB
            BannerDAO bannerDAO = new BannerDAO();
            boolean success = bannerDAO.insertBanner(banner);

            if (success) {
                resp.sendRedirect("manage-banner?uploaded=true");
            } else {
                // Rollback file nếu insert thất bại
                File uploadedFile = new File(filePath);
                if (uploadedFile.exists()) uploadedFile.delete();
                resp.sendRedirect("manage-banner?uploaded=false");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("manage-banner?uploaded=false");
        }
    }

    private boolean isValidImageType(String extension) {
        String[] validTypes = {".jpg", ".jpeg", ".png", ".gif", ".webp"};
        for (String type : validTypes) if (type.equals(extension)) return true;
        return false;
    }

    private void handleStatusUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int bannerId = Integer.parseInt(req.getParameter("bannerId"));
            int status = Integer.parseInt(req.getParameter("status"));

            Banner banner = new Banner();
            banner.setBannerId(bannerId);
            banner.setStatus(status);

            BannerDAO bannerDAO = new BannerDAO();
            boolean success = bannerDAO.updateBannerStatus(banner);

            resp.sendRedirect("manage-banner?" + (success ? "updated=true" : "updated=false"));
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("manage-banner?error=true");
        }
    }
}
