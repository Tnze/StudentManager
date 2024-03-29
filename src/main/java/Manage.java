import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;

public class Manage {
    public static Student[] getList() throws NamingException, SQLException {
        LinkedList<Student> ary = new LinkedList<>();
        Context c = new InitialContext();
        DataSource ds = (DataSource) c.lookup("java:comp/env/jdbc/students");
        try (Connection conn = ds.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement("SELECT Name,Gender,Birthday,QQ,Phone,Address,ID FROM students")) {
                ResultSet rows = stmt.executeQuery();
                while (rows.next()) {
                    Student s = new Student();
                    s.name = rows.getString("Name");
                    s.gender = rows.getInt("Gender");
                    s.birthday = rows.getLong("Birthday");
                    s.qq = rows.getString("QQ");
                    s.phone = rows.getString("Phone");
                    s.address = rows.getString("Address");
                    s.id = rows.getString("ID");
                    ary.add(s);
                }
            }
        }
        return ary.toArray(new Student[0]);
    }

    public static void update(String id, Student s) throws NamingException, SQLException {
        Context c = new InitialContext();
        DataSource ds = (DataSource) c.lookup("java:comp/env/jdbc/students");
        try (Connection conn = ds.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement("UPDATE students SET Name = ?, Gender = ?, Birthday = ?, QQ = ?, Phone = ?, Address = ?, id = ? WHERE ID = ?")) {
                stmt.setString(1, s.name);
                stmt.setInt(2, s.gender);
                stmt.setLong(3, s.birthday);
                stmt.setString(4, s.qq);
                stmt.setString(5, s.phone);
                stmt.setString(6, s.address);
                stmt.setString(7, s.id);
                stmt.setString(8, id);
                stmt.executeUpdate();
            }
        }
    }

    public static void photo(String id, InputStream photo) throws NamingException, SQLException {
        Context c = new InitialContext();
        DataSource ds = (DataSource) c.lookup("java:comp/env/jdbc/students");
        try (Connection conn = ds.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement("UPDATE students SET Photo = ? WHERE ID = ?")) {
                stmt.setBlob(1, photo);
                stmt.setString(2, id);
                stmt.executeUpdate();
            }
        }
    }

    public static void add(Student s) throws NamingException, SQLException {
        Context c = new InitialContext();
        DataSource ds = (DataSource) c.lookup("java:comp/env/jdbc/students");
        try (Connection conn = ds.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO students (Name,Gender,Birthday,QQ,Phone,Address,id) VALUES (?,?,?,?,?,?,?)")) {
                stmt.setString(1, s.name);
                stmt.setInt(2, s.gender);
                stmt.setLong(3, s.birthday);
                stmt.setString(4, s.qq);
                stmt.setString(5, s.phone);
                stmt.setString(6, s.address);
                stmt.setString(7, s.id);
                stmt.execute();
            }
        }
    }

    public static void delete(String id) throws NamingException, SQLException {
        Context c = new InitialContext();
        DataSource ds = (DataSource) c.lookup("java:comp/env/jdbc/students");
        try (Connection conn = ds.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM students WHERE ID = ?")) {
                stmt.setString(1, id);
                stmt.execute();
            }
        }
    }
}
