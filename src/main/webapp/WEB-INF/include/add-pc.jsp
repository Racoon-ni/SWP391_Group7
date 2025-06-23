<%-- 
    Document   : add-pc
    Created on : Jun 20, 2025, 12:50:00 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<div class="container">
    <h1>Add new PC</h1>

    <form method="POST" action="/manage-flowers?action=create">
        <div class="form-group">
            <label>Name:</label>
            <input type="text" name="name" class="form-control" required>
        </div>
        <br/>
        <div class="form-group">
            <label>Description:</label>
            <textarea name="description" class="form-control" required></textarea>
        </div>
        <br/>
        <div class="form-group">
            <label>Price:</label>
            <input type="number" step="0.01" name="price" class="form-control" required>
        </div>
        <br/>
        <div class="form-group">
            <label>Stock</label>
            <input type="text" name="stock" class="form-control" required>
        </div>
        
        <br/>
        <div class="form-group">
            <label>Product Type</label>
            <input type="text" name="stock" class="form-control" required>
        </div>
        
        <br/>
        <div class="form-group">
            <label>Category name</label>
            <input type="text" name="stock" class="form-control" required>
        </div>


        <br/>
        <button type="submit" class="btn btn-primary">Add</button>
    </form>
</div>