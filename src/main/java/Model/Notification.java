package model;

import java.sql.Timestamp;

public class Notification {

    private int notificationId;
    private int userId;
    private String title;
    private String message;
    private String link;
    private boolean isRead;
    private Timestamp createdAt;

    // Constructor mặc định
    public Notification() {
    }

    // Constructor nhanh
    public Notification(int userId, String title, String message, String link) {
        this.userId = userId;
        this.title = title;
        this.message = message;
        this.link = link;
        this.isRead = false;
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }

    // Getter và Setter đầy đủ
    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean isRead) {
        this.isRead = isRead;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
