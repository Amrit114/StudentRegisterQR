<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.io.*,javax.imageio.ImageIO" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="com.google.zxing.BarcodeFormat" %>
<%@ page import="com.google.zxing.qrcode.QRCodeWriter" %>
<%@ page import="com.google.zxing.WriterException" %>
<%@ page import="com.google.zxing.common.BitMatrix" %>


<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>QR Generator & Store</title>
</head>
<body>
<%
    // --- Step 1: Get form inputs ---
    String regno   = request.getParameter("id");   // from inputForm.jsp name="id"
    String name    = request.getParameter("n");    // from inputForm.jsp name="n"
    String branch  = request.getParameter("branch");
    String mobile  = request.getParameter("mobile");
    String email   = request.getParameter("email");

    // --- Step 2: Build QR data text ---
    String qrData = "RegNo: " + regno +
                    " | Name: " + name +
                    " | Branch: " + branch +
                    " | Mobile: " + mobile +
                    " | Email: " + email;

    int size = 250;
    QRCodeWriter qrCodeWriter = new QRCodeWriter();
    BitMatrix bitMatrix = null;
    try {
        bitMatrix = qrCodeWriter.encode(qrData, BarcodeFormat.QR_CODE, size, size);
    } catch (WriterException e) {
        e.printStackTrace();
    }

    // --- Step 3: Convert to image ---
    BufferedImage qrImage = new BufferedImage(size, size, BufferedImage.TYPE_INT_RGB);
    for (int x = 0; x < size; x++) {
        for (int y = 0; y < size; y++) {
            qrImage.setRGB(x, y, bitMatrix.get(x, y) ? 0xFF000000 : 0xFFFFFFFF);
        }
    }

    // Convert image to byte array (for Oracle BLOB)
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    ImageIO.write(qrImage, "png", baos);
    byte[] qrBytes = baos.toByteArray();

    // --- Step 4: Insert into Oracle DB ---
    Connection con = null;
    PreparedStatement ps = null;
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:xe", "system", "system");

        String sql = "INSERT INTO student_qr (regno, name, branch, mobile, email, qr_data, qr_image) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        ps = con.prepareStatement(sql);
        ps.setString(1, regno);
        ps.setString(2, name);
        ps.setString(3, branch);
        ps.setString(4, mobile);
        ps.setString(5, email);
        ps.setString(6, qrData);
        ps.setBytes(7, qrBytes);

        int rows = ps.executeUpdate();
        if (rows > 0) {
            out.println("<h3> Student QR Code stored in Oracle DB successfully!</h3>");
        } else {
            out.println("<h3> Failed to store QR in DB</h3>");
        }
    } catch (SQLIntegrityConstraintViolationException e) {
        out.println("<h3> Duplicate Entry: A record with RegNo " + regno + " already exists.</h3>");
    } catch (Exception e) {
        out.println("DB Error: " + e.getMessage());
        e.printStackTrace();
    } finally {
        if (ps != null) try { ps.close(); } catch(Exception ex) {}
        if (con != null) try { con.close(); } catch(Exception ex) {}
    }

    // --- Step 5: Display QR image ---
    String base64 = java.util.Base64.getEncoder().encodeToString(qrBytes);
%>
    <h3>Generated QR Code for <%= name %>:</h3>
    <img src="data:image/png;base64,<%=base64%>" alt="QR Code" />
    <br><br>
    <a href="inputForm.jsp"> Add Another Student</a>
</body>
</html>