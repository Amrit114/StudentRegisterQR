<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>View Student with QR</title>
    <style>
        body { margin:0; font-family: Arial, sans-serif; display:flex; }
        /* Sidebar */
        .sidebar { width:220px; background:#2c3e50; color:#fff; height:100vh; position:fixed; left:0; top:0; padding-top:20px; }
        .sidebar h2 { text-align:center; margin-bottom:20px; color:#ecf0f1; }
        .sidebar a { display:block; padding:12px 20px; color:#ecf0f1; text-decoration:none; border-bottom:1px solid #34495e; }
        .sidebar a:hover { background:#1abc9c; }

        /* Main */
        .content { margin-left:220px; padding:20px; flex:1; }
        table { border-collapse:collapse; margin:20px auto; width:95%; }
        td, th { border:1px solid #333; padding:8px; text-align:center; }
        h2 { text-align:center; background:#2c3e50; color:#fff; padding:12px; margin:0 0 20px 0; font-size:22px; }
        .form-section { text-align:center; margin:20px; }
        .no-print { margin:20px; text-align:center; }
        button { cursor:pointer; padding:6px 10px; border:none; border-radius:4px; }
        .btn-del { background:#e74c3c; color:#fff; }
        .btn-del:hover { background:#c0392b; }
        .btn-edit { background:#3498db; color:#fff; }
        .btn-edit:hover { background:#2980b9; }

        @media print { .no-print, .sidebar { display:none; } .content{margin:0;} }

        /* QR */
        .qr-img { cursor:pointer; transition:transform 0.3s ease; }
        .qr-img:hover { transform:scale(1.3); z-index:10; }
        .qr-modal { display:none; position:fixed; z-index:1000; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,0.8); justify-content:center; align-items:center; }
        .qr-modal img { max-width:70%; max-height:70%; border:5px solid #fff; border-radius:10px; box-shadow:0px 0px 20px #000; }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar no-print">
        <h2>📊 Dashboard</h2>
        <a href="home.jsp">🏠 Home</a>
        <a href="reg.jsp">📝 Register Student</a>
        <a href="viewStudent.jsp">👨‍🎓 View Students</a>
        <a href="readQR.jsp">📷 Scan QR</a>
        <a href="logout.jsp">🚪 Logout</a>
    </div>

    <div class="content">
        <h2>📌 Student Details with QR Code</h2>

        <div class="form-section no-print">
            <form method="get" style="display:inline-block; margin-right:20px;">
                Enter Reg No: <input type="text" name="regno">
                <input type="submit" value="Search">
            </form>
            <button onclick="window.print()">🖨 Print</button>
        </div>

        <%
            String regno = request.getParameter("regno");
            String deleteId = request.getParameter("deleteId");

            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                Connection con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:xe", "system", "system");

                // Handle delete
                if (deleteId != null && !deleteId.trim().isEmpty()) {
                    PreparedStatement del = con.prepareStatement("DELETE FROM student_qr WHERE regno=?");
                    del.setString(1, deleteId);
                    int rows = del.executeUpdate();
                    del.close();
                    out.println("<p style='color:green;text-align:center;'>✔ Student " + deleteId + " deleted.</p>");
                }

                // ✅ Default: show all records if no search
                PreparedStatement ps = null;
                if (regno != null && !regno.trim().isEmpty()) {
                    ps = con.prepareStatement("SELECT * FROM student_qr WHERE regno=?");
                    ps.setString(1, regno);
                } else {
                    ps = con.prepareStatement("SELECT * FROM student_qr ORDER BY regno");
                }

                ResultSet rs = ps.executeQuery();
                if (rs.isBeforeFirst()) {
        %>
                    <div id="printArea">
                        <table>
                            <tr>
                                <th>Reg No</th>
                                <th>Name</th>
                                <th>Branch</th>
                                <th>Mobile</th>
                                <th>Email</th>
                                <th>QR Code</th>
                                <th class="no-print">Action</th>
                            </tr>
                            <%
                                while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getString("regno") %></td>
                                <td><%= rs.getString("name") %></td>
                                <td><%= rs.getString("branch") %></td>
                                <td><%= rs.getString("mobile") %></td>
                                <td><%= rs.getString("email") %></td>
                                <td>
                                    <img src="ShowQRImageServlet?regno=<%= rs.getString("regno") %>" 
                                         class="qr-img" width="100" onclick="openQR(this.src)">
                                </td>
                                <td class="no-print">
                                    <form action="editStudent.jsp" method="get" style="display:inline-block; margin-right:5px;">
                                        <input type="hidden" name="regno" value="<%= rs.getString("regno") %>">
                                        <button type="submit" class="btn-edit">✏ Edit</button>
                                    </form>

                                    <form method="post" style="display:inline-block;" 
                                          onsubmit="return confirm('Delete student <%= rs.getString("regno") %>?');">
                                        <input type="hidden" name="deleteId" value="<%= rs.getString("regno") %>">
                                        <button type="submit" class="btn-del">🗑 Delete</button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                        </table>
                    </div>
        <%
                } else {
        %>
                    <p align="center" style="color:red;">❌ No student found.</p>
        <%
                }
                rs.close(); ps.close(); con.close();
            } catch (Exception e) {
                out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>

    <!-- QR Modal -->
    <div id="qrModal" class="qr-modal" onclick="closeQR()">
        <img id="qrModalImg" src="">
    </div>

    <script>
        function openQR(src) {
            document.getElementById('qrModal').style.display = "flex";
            document.getElementById('qrModalImg').src = src;
        }
        function closeQR() {
            document.getElementById('qrModal').style.display = "none";
        }
    </script>
</body>
</html>