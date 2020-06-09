import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class Photo extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String id = req.getParameter("id");
            if (id == null) throw new Exception("Unknown id");
            Context c = new InitialContext();
            DataSource ds = (DataSource) c.lookup("java:comp/env/jdbc/students");
            try (Connection conn = ds.getConnection()) {
                try (PreparedStatement stmt = conn.prepareStatement("SELECT Photo FROM students WHERE ID = ?")) {
                    stmt.setString(1, id);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        Blob photo = rs.getBlob(1);
                        if (photo != null) {
                            resp.setContentType("image/png");
                            photo.getBinaryStream().transferTo(resp.getOutputStream());
                            resp.setStatus(200);
                        }
                    }
                    resp.sendError(404);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, e.getClass().getName());
        }
    }
}
