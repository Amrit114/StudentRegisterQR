<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Student ID Card</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f7f7f7; margin:0; }
        h2 {
            text-align:center;
            background:#2c3e50;
            color:#fff;
            padding:12px;
            margin:0 0 20px 0;
            font-size:22px;
        }
        .id-card {
            width: 420px;
            height: 220px;
            border: 2px solid #333;
            border-radius: 12px;
            padding: 15px;
            margin: 30px auto;
            text-align: left;
            box-shadow: 2px 2px 10px rgba(0,0,0,0.2);
            page-break-after: always;
            background:#fff;
            display: flex;
            flex-direction: column;
        }
        .id-header {
            font-weight: bold;
            font-size: 16px;
            margin-bottom: 8px;
            background: #004080;
            color: white;
            padding: 6px;
            border-radius: 8px 8px 0 0;
            text-align: center;
        }
        .id-content {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex: 1;
            margin-top: 10px;
        }
        .id-body {
            font-size: 13px;
            line-height: 1.4;
            flex: 2;
        }
        .id-body p { margin: 4px 0; }
        .qr {
            flex: 1;
            text-align: center;
        }
        .qr img {
            width: 100px;
            height: 100px;
            border:1px solid #ccc;
            padding:5px;
            border-radius:6px;
            background:#fafafa;
        }
        .print-btn {
            margin: 20px;
            text-align: center;
        }
        .print-btn input, .print-btn button {
            background:#2c3e50;
            color:#fff;
            border:none;
            padding:8px 14px;
            margin:5px;
            border-radius:5px;
            cursor:pointer;
        }
        .print-btn input:hover, .print-btn button:hover {
            background:#1abc9c;
        }
        @media print {
            .print-btn { display: none; }
            body { background: white; }
        }
    </style>
</head>
<body>
    <!-- 🔹 Heading -->
    <h2>📌 Student Details with QR</h2>

    <div class="print-btn">
        <!-- Search Form -->
        <form method="get" style="margin-bottom:15px;">
            Enter Reg No: <input type="text" name="regno">
            <input type="submit" value="Generate ID Card">
        </form>

        <!-- Show All -->
        <form method="get" style="display:inline-block;">
            <input type="hidden" name="showAll" value="true">
            <input type="submit" value="Generate All ID Cards">
        </form>

        <br><br>
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
                // ✅ Join student_qr with qr_users to fetch cname
                ps = con.prepareStatement(
                    "SELECT s.*, u.cname FROM student_qr s " +
                    "JOIN qr_users u ON s.regno=u.regno " +
                    "WHERE s.regno=?"
                );
                ps.setString(1, regno);
            } else if ("true".equals(showAll)) {
                // ✅ Show all students with college name
                ps = con.prepareStatement(
                    "SELECT s.*, u.cname FROM student_qr s " +
                    "JOIN qr_users u ON s.regno=u.regno"
                );
            }

            if (ps != null) {
                ResultSet rs = ps.executeQuery();

                if (rs.isBeforeFirst()) {
                    while (rs.next()) {
                        String cname = rs.getString("cname"); // ✅ fetched from qr_users
    %>
                        <div class="id-card">
                            <div class="id-header"><%= cname != null ? cname : "COLLEGE NAME" %></div>
                            <div class="id-content">
                                <!-- Left: Student Details -->
                                <div class="id-body">
                                    <p><b>Reg No:</b> <%= rs.getString("regno") %></p>
                                    <p><b>Name:</b> <%= rs.getString("name") %></p>
                                    <p><b>Branch:</b> <%= rs.getString("branch") %></p>
                                    <p><b>Mobile:</b> <%= rs.getString("mobile") %></p>
                                    <p><b>Email:</b> <%= rs.getString("email") %></p>
                                </div>
                                <!-- Right: QR Code -->
                                <div class="qr">
                                    <img src="ShowQRImageServlet?regno=<%= rs.getString("regno") %>" alt="QR Code">
                                </div>
                            </div>
                        </div>
    <%
                    }
                } else {
    %>
                    <p align="center" style="color:red;">❌ No student found.</p>
    <%
                }
                rs.close();
                ps.close();
            }
            con.close();
        } catch (Exception e) {
            out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
        }
    %>

</body>
</html>