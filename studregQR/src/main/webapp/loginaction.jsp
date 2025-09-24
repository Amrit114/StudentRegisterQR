<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%@ page import="java.sql.*" %>
        <%
            String uname = request.getParameter("username");
            String pass = request.getParameter("password");

            if (uname != null && pass != null) {
                try {
                    Class.forName("oracle.jdbc.driver.OracleDriver");
                    Connection con = DriverManager.getConnection(
                        "jdbc:oracle:thin:@localhost:1521:xe", "system", "system");

                    PreparedStatement ps = con.prepareStatement(
                        "SELECT role, username FROM qr_users WHERE username=? AND password=?");
                    ps.setString(1, uname);
                    ps.setString(2, pass);
                    ResultSet rs = ps.executeQuery();
                   String regno="100";
                    if (rs.next()) {
                        String role = rs.getString("role");
                      
                        session.setAttribute("username", uname);
                        session.setAttribute("role", role);
                      
                        if ("ADMIN".equalsIgnoreCase(role)) {
                            response.sendRedirect("adminDashbord.jsp");
                        } else if ("STUDENT".equalsIgnoreCase(role)) {
                            response.sendRedirect("studentDashbord.jsp?regno=" + regno);
                        }
                    } else {
                        out.println("<p class='error'> Invalid username or password</p>");
                    }
                    con.close();
                } catch (Exception e) {
                    out.println("<p class='error'>DB Error: " + e.getMessage() + "</p>");
                }
            }
        %>

</body>
</html>