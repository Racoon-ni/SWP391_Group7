package model;

import java.util.Date;

public class Banner {
    private int bannerId;
    private int productId;   // 0 nếu không set
    private String imageUrl;
    private int status;
    private Date createdAt;

    // ✅ Link đích (tùy chọn)
    private String targetUrl;

    public int getBannerId() { return bannerId; }
    public void setBannerId(int bannerId) { this.bannerId = bannerId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getTargetUrl() { return targetUrl; }
    public void setTargetUrl(String targetUrl) { this.targetUrl = targetUrl; }
}
