import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.FileItemFactory;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import org.apache.tomcat.util.http.fileupload.servlet.ServletRequestContext;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

public class PhotoServlet extends HttpServlet {
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
                        } else resp.setStatus(204);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, e.getClass().getName());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        try {
            FileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            List<FileItem> items = upload.parseRequest(new ServletRequestContext(req));
            String id = null, fileName = null;
            InputStream photo = null;
            for (FileItem f : items) {
                if (f.isFormField()) {
                    if ("id".equals(f.getFieldName())) id = f.getString();
                } else {
                    fileName = f.getName();
                    photo = f.getInputStream();
                }
            }
            if (id == null || fileName == null || photo == null) throw new Exception("Argument not enought");
            System.out.println(id + "存入文件" + fileName);
            Manage.photo(id, photo);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
