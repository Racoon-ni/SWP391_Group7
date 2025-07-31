package controller;

import DAO.AdminStaffSalesDAO;
import com.sun.rowset.internal.Row;
import model.AdminStaffSalesStats;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.awt.Font;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import javafx.scene.control.Cell;

@WebServlet("/adminstaff-/sales-export")
public class AdminStaffSalesExportExcelServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy tham số kiểu export: "day" hoặc "month"
        String type = request.getParameter("type");
        if (type == null || (!type.equals("day") && !type.equals("month"))) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h3>❌ Lỗi: Thiếu hoặc sai tham số 'type'.</h3>");
            return;
        }

        AdminStaffSalesDAO dao = new AdminStaffSalesDAO();
        List<AdminStaffSalesStats> statsList;

        String filename;
        String sheetName;
        String[] headers;

        if ("day".equals(type)) {
            statsList = dao.getLast7DaysRevenue();
            filename = "DoanhThu_7NgayGanNhat.xlsx";
            sheetName = "7Ngay";
            headers = new String[]{"Ngày", "Doanh thu (VNĐ)"};
        } else {
            statsList = dao.getLast6MonthsRevenue();
            filename = "DoanhThu_6ThangGanNhat.xlsx";
            sheetName = "6Thang";
            headers = new String[]{"Tháng/Năm", "Doanh thu (VNĐ)"};
        }

        // Tạo workbook và sheet
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet(sheetName);

        // Style tiêu đề (in đậm)
        CellStyle headerStyle = workbook.createCellStyle();
        Font boldFont = workbook.createFont();
        boldFont.setBold(true);
        headerStyle.setFont(boldFont);

        // Style cho số tiền (format tiền Việt Nam)
        CellStyle currencyStyle = workbook.createCellStyle();
        DataFormat format = workbook.createDataFormat();
        currencyStyle.setDataFormat(format.getFormat("#,##0 \"₫\""));

        // Ghi hàng tiêu đề
        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        // Ghi dữ liệu
        int rowIdx = 1;
        for (AdminStaffSalesStats stat : statsList) {
            Row row = sheet.createRow(rowIdx++);

            // Cột 1: Ngày hoặc Tháng/Năm
            if ("day".equals(type)) {
                row.createCell(0).setCellValue(stat.getDate().toString());
            } else {
                row.createCell(0).setCellValue(stat.getMonth() + "/" + stat.getYear());
            }

            // Cột 2: Doanh thu (định dạng tiền)
            Cell revenueCell = row.createCell(1);
            revenueCell.setCellValue(stat.getRevenue());
            revenueCell.setCellStyle(currencyStyle);
        }

        // Tự động căn lề cột
        sheet.autoSizeColumn(0);
        sheet.autoSizeColumn(1);

        // Trả file về client
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        try (OutputStream out = response.getOutputStream()) {
            workbook.write(out);
        } finally {
            workbook.close();
        }
    }
}
