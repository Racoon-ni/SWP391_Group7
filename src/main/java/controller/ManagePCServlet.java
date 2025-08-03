/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CategoryDAO;
import DAO.ProductAttributeDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import model.PC;
import DAO.pcDAO;
import java.util.List;
import java.util.Map;
import model.Category;
import model.ProductAttribute;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import model.User;

/**
 *
 * @author Huynh Trong Nguyen - CE190356
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
@WebServlet(name = "ManagePCServlet", urlPatterns = {"/manage-pc"})
public class ManagePCServlet extends HttpServlet {

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
        String view = request.getParameter("view");
        HttpSession session = request.getSession(false);

        if (session != null) {

            User user = (User) session.getAttribute("user");
            Boolean isLogged = (Boolean) session.getAttribute("logged");

            if (isLogged != null && isLogged) {

                if (user != null && (user.getRole().equalsIgnoreCase("Admin") || user.getRole().equalsIgnoreCase("Staff"))) {

                    if (view == null || view.isEmpty() || view.equalsIgnoreCase("list")) {

                        pcDAO p = new pcDAO();
                        ArrayList<PC> pcList = p.getAllPCs();
                        request.setAttribute("pcList", pcList);
                        request.getRequestDispatcher("/WEB-INF/include/pc-list.jsp").forward(request, response);
                        return;

                    } else if (view.equalsIgnoreCase("add")) {

                        ProductAttributeDAO pa = new ProductAttributeDAO();
                        ArrayList<ProductAttribute> pAttList = pa.getAttributes(1);
                        Map<String, List<String>> attrValueOptions = pa.getAttrValueOptions(1);
                        request.setAttribute("pAttList", pAttList);
                        request.setAttribute("attrValueOptions", attrValueOptions);
                        request.getRequestDispatcher("/WEB-INF/include/add-pc.jsp").forward(request, response);
                        return;

                    } else if (view.equalsIgnoreCase("edit")) {

                        int id = Integer.parseInt(request.getParameter("id"));
                        pcDAO p = new pcDAO();
                        PC pc = p.getPCById(id);
                        ProductAttributeDAO pa = new ProductAttributeDAO();
                        ArrayList<ProductAttribute> pAttList = pa.getAttributeByProductId(id);
                        Map<String, List<String>> attrValueOptions = pa.getAttrValueOptions(pc.getCategory().getCategoryId());
                        request.setAttribute("pc", pc);
                        request.setAttribute("pAttList", pAttList);
                        request.setAttribute("attrValueOptions", attrValueOptions);
                        request.getRequestDispatcher("/WEB-INF/include/edit-pc.jsp").forward(request, response);
                        return;

                    } else if (view.equalsIgnoreCase("details")) {

                        int id = Integer.parseInt(request.getParameter("id"));
                        pcDAO p = new pcDAO();
                        ProductAttributeDAO pa = new ProductAttributeDAO();
                        PC pc = p.getPCById(id);
                        ArrayList<ProductAttribute> pAttList = pa.getAttributeByProductId(id);
                        request.setAttribute("pc", pc);
                        request.setAttribute("pAttList", pAttList);
                        request.getRequestDispatcher("/WEB-INF/include/admin-pc-details.jsp").forward(request, response);
                        return;

                    } else {
                        request.getRequestDispatcher("/WEB-INF/include/pc-list.jsp").forward(request, response);
                        return;
                    }

                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
                }

            }
        }

        response.sendRedirect(request.getContextPath() + "/home");

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

        String act = request.getParameter("action");
        pcDAO p = new pcDAO();
        CategoryDAO c = new CategoryDAO();
        ProductAttributeDAO paDAO = new ProductAttributeDAO();
        List<String> errors = new ArrayList<>();
        if (act != null) {
            switch (act) {
                case "create":
                    String name = request.getParameter("name");
                    String description = request.getParameter("description");
                    String priceStr = request.getParameter("price");
                    String stockStr = request.getParameter("stock");
                    int cateId = 1;

                    if (name == null || name.trim().isEmpty()) {
                        errors.add("Product name is required.");
                    }

                    if (description == null || description.trim().isEmpty()) {
                        errors.add("Description is required.");
                    }

                    double price = 0;
                    try {
                        price = Double.parseDouble(priceStr);
                        if (price <= 0) {
                            errors.add("Price must be a positive number.");
                        }
                    } catch (NumberFormatException e) {
                        errors.add("Invalid price format.");
                    }

                    int stock = 0;
                    try {
                        stock = Integer.parseInt(stockStr);
                        if (stock < 0) {
                            errors.add("Stock must be 0 or more.");
                        }
                    } catch (NumberFormatException e) {
                        errors.add("Invalid stock format.");
                    }

                    Category category = c.getCategoryById(cateId);
                    if (category == null) {
                        errors.add("Invalid category ID.");
                    }

                    Part imagePart = request.getPart("image");
                    String imageFileName = "";
                    if (imagePart != null && imagePart.getSize() > 0) {
                        String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                        String extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
                        if (!extension.matches("jpg|jpeg|png|gif")) {
                            errors.add("Only image files (.jpg, .jpeg, .png, .gif) are allowed.");
                        }

                        if (errors.isEmpty()) {
                            String uploadPath = getServletContext().getRealPath("/img");
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) {
                                uploadDir.mkdir();
                            }

                            imagePart.write(uploadPath + File.separator + fileName);
                            imageFileName = "./img/" + fileName;
                        }
                    } else {
                        errors.add("Please upload an image.");
                    }

                    if (!errors.isEmpty()) {
                        request.setAttribute("errors", errors);
                        request.getRequestDispatcher("/WEB-INF/include/add-pc.jsp").forward(request, response);
                    } else {

                        // 1. Insert PC and get new product_id
                        int productId = p.addPC(new PC(0, name, description, price, stock, imageFileName, category, true));

                        if (productId != -1) {
                            // 2. Get list of attributes for this category
                            ArrayList<ProductAttribute> pAttList = paDAO.getAttributes(cateId);

                            for (ProductAttribute attr : pAttList) {
                                int attrId = attr.getAttribute().getId();
                                String value = request.getParameter("attr_" + attrId);

                                if (value != null && !value.trim().isEmpty()) {
                                    paDAO.addProductAttributeValue(productId, attrId, value);
                                }
                            }

                            response.sendRedirect(request.getContextPath() + "/manage-pc");
                        } else {
                            request.setAttribute("error", "Add PC failed");
                            request.getRequestDispatcher("add-pc.jsp").forward(request, response);
                        }
                    }

                    break;

                case "edit":

                    int id = Integer.parseInt(request.getParameter("id"));
                    name = request.getParameter("name");
                    description = request.getParameter("description");
                    priceStr = request.getParameter("price");
                    stockStr = request.getParameter("stock");
                    String statusStr = request.getParameter("status");

                    // Name validation
                    if (name == null || name.trim().isEmpty()) {
                        errors.add("Name cannot be empty.");
                    }

                    if (description == null || description.trim().isEmpty()) {
                        errors.add("Description is required.");
                    }

                    // Price validation
                    price = 0;
                    try {
                        price = Double.parseDouble(priceStr);
                        if (price < 0) {
                            errors.add("Price must be greater than 0.");
                        }
                    } catch (NumberFormatException e) {
                        errors.add("Invalid price format.");
                    }

                    // Stock validation
                    stock = 0;
                    try {
                        stock = Integer.parseInt(stockStr);
                        if (stock < 0) {
                            errors.add("Stock cannot be negative.");
                        }
                    } catch (NumberFormatException e) {
                        errors.add("Invalid stock format.");
                    }

                    // Status validation
                    Boolean status = Boolean.parseBoolean(statusStr); // optional strict check
                    if (!statusStr.equals("true") && !statusStr.equals("false")) {
                        errors.add("Invalid status value.");
                    }

                    // Image validation
                    imagePart = request.getPart("image");
                    imageFileName = "";

                    if (imagePart != null && imagePart.getSize() > 0) {
                        // A new image has been uploaded
                        String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                        String extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();

                        if (!extension.matches("jpg|jpeg|png|gif")) {
                            errors.add("Only image files (.jpg, .jpeg, .png, .gif) are allowed.");
                        }

                        if (errors.isEmpty()) {
                            String uploadPath = getServletContext().getRealPath("/img");
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) {
                                uploadDir.mkdir();
                            }

                            imagePart.write(uploadPath + File.separator + fileName);
                            imageFileName = "./img/" + fileName;
                        }
                    } else {
                        // No new image uploaded — use the old one
                        imageFileName = request.getParameter("oldImageUrl");

                        if (imageFileName == null || imageFileName.trim().isEmpty()) {
                            errors.add("Please upload an image.");
                        }
                    }

                    // Update attributes
                    ArrayList<ProductAttribute> pAttList = paDAO.getAttributeByProductId(id);
                    for (ProductAttribute pAtt : pAttList) {
                        int attrId = pAtt.getAttribute().getId();
                        String newValue = request.getParameter("attr_" + attrId);
                        if (newValue != null && !newValue.trim().isEmpty()) {
                            paDAO.updateProductAttributeValue(id, attrId, newValue);
                        } else {
                            errors.add("Attribute value for " + pAtt.getAttribute().getName() + " cannot be empty.");
                        }
                    }

                    // Optional final check before DB update
                    if (!errors.isEmpty()) {
                        request.setAttribute("errors", errors);
                        request.getRequestDispatcher("/WEB-INF/include/edit-pc.jsp").forward(request, response);
                        return;
                    }

                    // Update product
                    if (p.updatePC(new PC(id, name, description, price, stock, imageFileName, c.getCategoryById(1), status)) == 1) {
                        response.sendRedirect(request.getContextPath() + "/manage-pc");
                    }

                    break;
                case "delete": // not validate yet
                    id = Integer.parseInt(request.getParameter("id"));

                    if (paDAO.delete(id) == 1) {
                        response.sendRedirect(request.getContextPath() + "/manage-pc");
                    }

                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/manage-pc");
                    break;
            }

        } else {
            response.sendRedirect(request.getContextPath() + "/manage-pc");
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
