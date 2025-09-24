<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page language="java" %>

<%
    String regno = request.getParameter("regno");
    String msg = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Handle form submission
        regno = request.getParameter("regno");
        String name = request.getParameter("name");
        String branch = request.getParameter("branch");
        String mobile = request.getParameter("mobile");
        String email = request.getParameter("email");

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:xe","system","system");

            PreparedStatement ps = con.prepareStatement(
                "UPDATE student_qr SET name=?, branch=?, mobile=?, email=? WHERE regno=?");
            ps.setString(1, name);
            ps.setString(2, branch);
            ps.setString(3, mobile);
            ps.setString(4, email);
            ps.setString(5, regno);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                msg = "✔ Student details updated successfully!";
            } else {
                msg = "❌ Update failed!";
            }

            ps.close();
            con.close();
        } catch(Exception e) {
            msg = "Error: " + e.getMessage();
        }
    }

    // Fetch student data to prefill form
    String name = "", branch = "", mobile = "", email = "";
    if (regno != null) {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:xe","system","system");

            PreparedStatement ps = con.prepareStatement("SELECT * FROM student_qr WHERE regno=?");
            ps.setString(1, regno);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
                branch = rs.getString("branch");
                mobile = rs.getString("mobile");
                email = rs.getString("email");
            }
            rs.close();
            ps.close();
            con.close();
        } catch(Exception e) {
            msg = "Error fetching data: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Edit Student — QR Management</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f7f7f7; }
        .container { max-width: 600px; margin: 40px auto; background:#fff; padding:20px; border-radius:8px; box-shadow:0 2px 6px rgba(0,0,0,0.1); }
        h2 { text-align:center; margin-bottom:20px; }
        label { display:block; margin-bottom:6px; font-weight:600; }
        input[type="text"], input[type="email"], select {
            width:100%; padding:8px 10px; border:1px solid #ccc; border-radius:4px; margin-bottom:12px;
        }
        .actions { margin-top:16px; text-align:right; }
        button { padding:10px 16px; border:0; background:#007bff; color:#fff; border-radius:6px; cursor:pointer; }
        button.secondary { background:#6c757d; margin-right:8px; }
        .msg { font-weight:bold; margin-bottom:12px; color:green; }
        .error { color:red; font-weight:bold; margin-bottom:12px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Edit Student Details</h2>

        <% if(!msg.isEmpty()){ %>
            <p class="<%= msg.startsWith("✔") ? "msg" : "error" %>"><%= msg %></p>
        <% } %>

        <% if (regno != null && !regno.isEmpty()) { %>
        <form method="post">
            <input type="hidden" name="regno" value="<%= regno %>">

            <label>Registration No</label>
            <input type="text" value="<%= regno %>" disabled>

            <label>Name *</label>
            <input type="text" name="name" value="<%= name %>" required>

            <label>Branch</label>
            <select name="branch">
                <option value="">-- Select Branch --</option>
                <option value="CSE" <%= "CSE".equals(branch)?"selected":"" %>>CSE</option>
                <option value="ECE" <%= "ECE".equals(branch)?"selected":"" %>>ECE</option>
                <option value="ME"  <%= "ME".equals(branch)?"selected":"" %>>ME</option>
                <option value="CE"  <%= "CE".equals(branch)?"selected":"" %>>CE</option>
                <option value="EE"  <%= "EE".equals(branch)?"selected":"" %>>EE</option>
                <option value="OTHER" <%= "OTHER".equals(branch)?"selected":"" %>>OTHER</option>
            </select>

            <label>Mobile</label>
            <input type="text" name="mobile" value="<%= mobile %>">

            <label>Email</label>
            <input type="email" name="email" value="<%= email %>">

            <div class="actions">
                <button type="submit">Update Student</button>
                <button type="button" class="secondary" onclick="window.location='viewStudent.jsp'">Cancel</button>
            </div>
        </form>
        <% } else { %>
            <p class="error">❌ No student selected to edit!</p>
        <% } %>
    </div>
</body>
</html>