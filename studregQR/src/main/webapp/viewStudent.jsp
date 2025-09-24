<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>View Student with QR</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            display: flex;
        }
        /* Sidebar */
        .sidebar {
            width: 220px;
            background: #2c3e50;
            color: #fff;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            padding-top: 20px;
        }
        .sidebar h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #ecf0f1;
        }
        .sidebar a {
            display: block;
            padding: 12px 20px;
            color: #ecf0f1;
            text-decoration: none;
            border-bottom: 1px solid #34495e;
        }
        .sidebar a:hover { background: #1abc9c; }

        /* Main Content */
        .content { margin-left: 220px; padding: 20px; flex: 1; }
        table { border-collapse: collapse; margin: 20px auto; width: 90%; }
        td, th { border: 1px solid #333; padding: 8px; text-align: center; }
        h2 { text-align: center; }
        .form-section { text-align: center; margin: 20px; }
        .no-print { margin: 20px; text-align: center; }

        @media print {
            .no-print, .sidebar { display: none; } 
            .content { margin: 0; }
        }

        /* QR hover + modal */
        .qr-img { cursor: pointer; transition: transform 0.3s ease; }
        .qr-img:hover { transform: scale(1.3); z-index: 10; }
        .qr-modal {
            display: none; position: fixed; z-index: 1000;
            left: 0; top: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.8); justify-content: center; align-items: center;
        }
        .qr-modal img {
            max-width: 70%; max-height: 70%;
            border: 5px solid #fff; border-radius: 10px; box-shadow: 0px 0px 20px #000;
        }
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

    <!-- Main Content -->
    <div class="content">
        <h2>📌 Student Details with QR Code</h2>

        <div class="form-section no-print">
            <!-- Search by Reg No -->
            <form method="get" style="display:inline-block; margin-right:20px;">
                Enter Reg No: <input type="text" name="regno">
                <input type="submit" value="Search">
            </form>

            <!-- Show All -->
            <form method="get" style="display:inline-block;">
                <input type="hidden" name="showAll" value="true">
                <input type="submit" value="Show All Students">
            </form>

            <!-- Print Button -->
            <button onclick="window.print()">🖨 Print</button>
        </div>

        <%
            String regno = request.getParameter("regno");
            String showAll = request.getParameter("showAll");

            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                Connection con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:xe", "system", "system");

                PreparedStatement ps = null;
                if (regno != null && !regno.trim().isEmpty()) {
                    ps = con.prepareStatement("SELECT * FROM student_qr WHERE regno=?");
                    ps.setString(1, regno);
                } else if ("true".equals(showAll)) {
                    ps = con.prepareStatement("SELECT * FROM student_qr");
                }

                if (ps != null) {
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
                                             class="qr-img" width="100" 
                                             onclick="openQR(this.src)">
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
                    rs.close(); ps.close();
                }
                con.close();
            } catch (Exception e) {
                out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>

    <!-- Modal Structure -->
    <div id="qrModal" class="qr-modal" onclick="closeQR()">
        <img id="qrModalImg" src="">
    </div>

    <script>
        function openQR(src) {
            const modal = document.getElementById('qrModal');
            const modalImg = document.getElementById('qrModalImg');
            modal.style.display = "flex";
            modalImg.src = src;
        }
        function closeQR() {
            document.getElementById('qrModal').style.display = "none";
        }
    </script>
</body>
</html>