/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.time.LocalDate;
import java.time.Period;
import java.util.regex.Pattern;

/**
 *
 * @author Admin
 */
public class ValidationUtils {

    private static final Pattern EMAIL
            = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    // Họ tên Unicode: chỉ chữ và khoảng trắng (không số/ký tự đặc biệt)
    private static final Pattern FULLNAME
            = Pattern.compile("^[\\p{L}]+(?:[\\p{L}\\s]+[\\p{L}])?$");

    // VN mobile: 10 số, đầu 03/05/07/08/09
    private static final Pattern VN_MOBILE
            = Pattern.compile("^0(3|5|7|8|9)\\d{8}$");

    public static boolean isValidEmail(String s) {
        return s != null && EMAIL.matcher(s).matches();
    }

    public static boolean isValidFullname(String s) {
        return s != null && FULLNAME.matcher(s.trim()).matches();
    }

    /**
     * Chuẩn hoá SĐT VN về 0xxxxxxxxx; loại bỏ dấu cách, ., -, ()
     */
    public static String normalizePhoneVN(String raw) {
        if (raw == null) {
            return null;
        }
        String s = raw.replaceAll("[\\s.\\-()]", "");
        if (s.startsWith("+84")) {
            s = "0" + s.substring(3);
        } else if (s.startsWith("84")) {
            s = "0" + s.substring(2);
        }
        return s;
    }

    /**
     * Cho phép rỗng (field tuỳ chọn); nếu có thì phải là SĐT VN hợp lệ
     */
    public static boolean isValidVNPhoneOrEmpty(String s) {
        if (s == null || s.isEmpty()) {
            return true;
        }
        return VN_MOBILE.matcher(s).matches();
    }

    /**
     * Đủ 18 tuổi
     */
    public static boolean isAdult(LocalDate dob) {
        if (dob == null) {
            return false;
        }
        return Period.between(dob, LocalDate.now()).getYears() >= 18;
    }
}
