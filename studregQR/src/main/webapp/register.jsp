<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Registration</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f0f2f5; margin:0; }
        .container {
            max-width: 500px; margin: 50px auto; background:#fff; padding:20px;
            border-radius:8px; box-shadow:0 4px 12px rgba(0,0,0,0.1);
        }
        h2 {
            text-align:center; margin-bottom:20px;
            background:#2c3e50; color:#fff; padding:12px; border-radius:6px;
        }
        label { display:block; margin-bottom:6px; font-weight:bold; color:#333; }
        input, select {
            width:100%; padding:10px; margin-bottom:14px;
            border:1px solid #ccc; border-radius:4px; font-size:14px;
        }
        .btn {
            width:100%; padding:10px; background:#2c3e50; color:#fff;
            border:none; border-radius:6px; cursor:pointer; margin-top:8px; font-size:15px;
        }
        .btn:hover { background:#1abc9c; }
        .msg { margin:15px 0; padding:10px; border-radius:5px; text-align:center; }
        .error { background:#f8d7da; color:#721c24; }
        .success { background:#d4edda; color:#155724; }
    </style>
</head>
<body>
<div class="container">
    <h2>📌 Student Details with QR</h2>

    <form method="post">
        <label for="regno">Registration No</label>
        <input type="text" name="regno" id="regno" required>

        <label for="cname">College Name</label>
        <input type="text" name="cname" id="cname" required>

        <label for="username">Username</label>
        <input type="text" name="username" id="username" required>

        <label for="password">Password</label>
        <input type="password" name="password" id="password" required>

        <label for="role">Role</label>
        <select name="role" id="role" required>
            <option value="">-- Select Role --</option>
            <option value="Student">Student</option>
            <option value="Admin">Admin</option>
        </select>

        <!-- Register Button -->
        <button type="submit" class="btn">Register</button>
    </form>

    <!-- ✅ Themed Login Button -->
    <form action="login.jsp" method="get">
        <button type="submit" class="btn">Login</button>
    </form>

    <%
        String regno = request.getParameter("regno");
        String cname = request.getParameter("cname");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (regno != null && cname != null && username != null && password != null && role != null) {
            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","system","system");

                // ✅ Verify regno exists in student_qr
                PreparedStatement psCheck = con.prepareStatement("SELECT * FROM student_qr WHERE regno=?");
                psCheck.setString(1, regno);
                ResultSet rsCheck = psCheck.executeQuery();

                if (!rsCheck.next()) {
                    out.println("<div class='msg error'>❌ Registration No not found in student records.</div>");
                } else {
                    // ✅ Restrict only 1 Admin
                    if ("Admin".equalsIgnoreCase(role)) {
                        Statement st = con.createStatement();
                        ResultSet rsAdmin = st.executeQuery("SELECT COUNT(*) FROM qr_users WHERE role='Admin'");
                        rsAdmin.next();
                        if (rsAdmin.getInt(1) > 0) {
                            out.println("<div class='msg error'>❌ Only one Admin account is allowed.</div>");
                            con.close();
                            return;
                        }
                    }

                    // ✅ Insert user with cname
                    PreparedStatement psInsert = con.prepareStatement(
                        "INSERT INTO qr_users(username, password, regno, role, cname) VALUES(?,?,?,?,?)"
                    );
                    psInsert.setString(1, username);
                    psInsert.setString(2, password);
                    psInsert.setString(3, regno);
                    psInsert.setString(4, role);
                    psInsert.setString(5, cname);

                    int rows = psInsert.executeUpdate();
                    if (rows > 0) {
                        out.println("<div class='msg success'>✅ User registered successfully!</div>");
                    } else {
                        out.println("<div class='msg error'>❌ Registration failed.</div>");
                    }
                    psInsert.close();
                }
                con.close();
            } catch (Exception e) {
                out.println("<div class='msg error'>Error: " + e.getMessage() + "</div>");
            }
        }
    %>
</div>
</body>
</html>