<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    String regno = request.getParameter("regno");
    if (regno != null && !regno.trim().isEmpty()) {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:xe", "system", "system");

            PreparedStatement ps = con.prepareStatement(
                "SELECT regno, name, branch, mobile, email FROM student_qr WHERE regno=?");
            ps.setString(1, regno);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
%>
                <div id="cardArea">
                    <h3 align="center">Student ID Card</h3>
                    <p><b>Registration No:</b> <%= rs.getString("regno") %></p>
                    <p><b>Name:</b> <%= rs.getString("name") %></p>
                    <p><b>Branch:</b> <%= rs.getString("branch") %></p>
                    <p><b>Mobile:</b> <%= rs.getString("mobile") %></p>
                    <p><b>Email:</b> <%= rs.getString("email") %></p>
                    <p><b>QR Code:</b><br>
                        <img src="ShowQRImageServlet?regno=<%= rs.getString("regno") %>" width="120">
                    </p>
                </div>
                <button id="printBtn" onclick="printCard()">🖨 Print</button>

                <script>
                    function printCard() {
                        var divContents = document.getElementById("cardArea").innerHTML;
                        var w = window.open('', '', 'height=600,width=400');
                        w.document.write('<html><head><title>Print ID Card</title></head><body>');
                        w.document.write(divContents);
                        w.document.write('</body></html>');
                        w.document.close();
                        w.print();
                    }
                </script>
<%
            } else {
                out.println("<p style='color:red;'>❌ No student found for RegNo " + regno + "</p>");
            }
            con.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        }
    } else {
        out.println("<p style='color:red;'>❌ Invalid QR Code</p>");
    }
%>