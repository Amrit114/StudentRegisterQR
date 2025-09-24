<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<<style>
#branchChart {
        width: 250px !important;
        height: 250px !important;
    }
</style>
<%
    String user = (String)session.getAttribute("username");
    String role = (String)session.getAttribute("role");

    if (user == null || !"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // --- Fetch branchwise student counts ---
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    StringBuilder branches = new StringBuilder("[");
    StringBuilder counts = new StringBuilder("[");

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "system");

        ps = con.prepareStatement("SELECT branch, COUNT(*) as total FROM student_qr GROUP BY branch");
        rs = ps.executeQuery();

        while (rs.next()) {
            branches.append("'").append(rs.getString("branch")).append("',");
            counts.append(rs.getInt("total")).append(",");
        }
        if (branches.length() > 1) branches.setLength(branches.length()-1); // remove last comma
        if (counts.length() > 1) counts.setLength(counts.length()-1);

        branches.append("]");
        counts.append("]");
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { margin: 0; font-family: Arial, sans-serif; }
        .sidebar {
            width: 220px; height: 100vh; position: fixed; left: 0; top: 0;
            background: #2c3e50; color: white; padding: 20px; box-sizing: border-box;
        }
        .sidebar h2 { text-align: center; margin-bottom: 20px; }
        .sidebar a {
            display: block; padding: 10px; margin: 5px 0; color: white;
            text-decoration: none; border-radius: 4px;
        }
        .sidebar a:hover { background: #34495e; }
        .content {
            margin-left: 240px; padding: 20px;
        }
        .card {
            background: #fff; padding: 20px; border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        h2 { color: #333; }
    </style>
</head>
<body>
    <!-- Sidebar Menu -->
    <div class="sidebar">
        <h3>Admin Panel</h3>
        <a href="adminDashboard.jsp">📊 Dashboard</a>
        <a href="manageStudent.jsp">👨‍🎓 Manage Students</a>
        <a href="reports.jsp">📑 Reports</a>
        <a href="printID.jsp">🖨 PrintID Card</a>
        <a href="logout.jsp">🚪 Logout</a>
    </div>

    <!-- Main Content -->
    <div class="content">
        <h2>Welcome, <%= user %></h2>
        <div class="card">
            <h3>Branchwise Student Statistics</h3>
            <canvas id="branchChart" width="400" height="200"></canvas>
        </div>
    </div>

    <script>
    const ctx = document.getElementById('branchChart').getContext('2d');
    new Chart(ctx, {
        type: 'pie',
        data: {
            labels: <%= branches.toString() %>,
            datasets: [{
                label: 'Students per Branch',
                data: <%= counts.toString() %>,
                backgroundColor: [
                    '#3498db', // Blue
                    '#e74c3c', // Red
                    '#2ecc71', // Green
                    '#f1c40f', // Yellow
                    '#9b59b6', // Purple
                    '#1abc9c', // Teal
                    '#e67e22'  // Orange
                ],
                borderColor: '#fff',
                borderWidth: 2
            }]
        },
        options: {
            responsive: false,   // Disable auto-resize
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'right' },
                title: { display: true, text: 'Students per Branch' }
            }
        }
    });
</script>
</body>
</html>