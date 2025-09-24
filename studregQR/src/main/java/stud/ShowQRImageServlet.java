package stud;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.*;

/**
 * Servlet implementation class ShowQRImageServlet
 */
@WebServlet("/ShowQRImageServlet")
public class ShowQRImageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ShowQRImageServlet() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String regno = request.getParameter("regno");

        if (regno == null || regno.trim().isEmpty()) {
            response.setContentType("text/plain");
            response.getWriter().write("⚠ Please provide a valid regno parameter.");
            return;
        }

        try (Connection con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:xe", "system", "system");
             PreparedStatement ps = con.prepareStatement(
                    "SELECT qr_image FROM student_qr WHERE regno=?")) {

            Class.forName("oracle.jdbc.driver.OracleDriver");
            ps.setString(1, regno);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Blob blob = rs.getBlob("qr_image");

                    if (blob != null) {
                        byte[] imageBytes = blob.getBytes(1, (int) blob.length());

                        response.setContentType("image/png");
                        try (OutputStream out = response.getOutputStream()) {
                            out.write(imageBytes);
                            out.flush();
                        }
                    } else {
                        response.setContentType("text/plain");
                        response.getWriter().write("⚠ No QR image found for RegNo: " + regno);
                    }
                } else {
                    response.setContentType("text/plain");
                    response.getWriter().write("⚠ No record found with RegNo: " + regno);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/plain");
            response.getWriter().write("❌ Error: " + e.getMessage());
        }
    }
}