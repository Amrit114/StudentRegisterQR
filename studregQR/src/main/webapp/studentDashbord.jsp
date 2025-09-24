<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%@ page language="java" import="java.sql.*" %>
<%
    String regno = request.getParameter("regno");
    String user = (String)session.getAttribute("username");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    Connection con = null;
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:xe", "system", "system");

        PreparedStatement ps = con.prepareStatement(
            "SELECT name, branch, email FROM student_qr WHERE regno=?");
        ps.setString(1, regno);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
%>
            <h2>Welcome <%= rs.getString("name") %></h2>
            <p><b>RegNo:</b> <%= regno %></p>
            <p><b>Branch:</b> <%= rs.getString("branch") %></p>
            <p><b>Email:</b> <%= rs.getString("email") %></p>
            <a href="logout.jsp">Logout</a>
<%
        }
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    } finally { if (con!=null) con.close(); }
%>

</body>
</html>