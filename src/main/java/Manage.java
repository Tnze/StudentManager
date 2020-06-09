import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
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
                    s.gender = rows.getString("Gender");
                    s.birthday = rows.getDate("Birthday");
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
                stmt.setString(2, s.gender);
                stmt.setDate(3, new java.sql.Date(s.birthday.getTime()));
                stmt.setString(4, s.qq);
                stmt.setString(5, s.phone);
                stmt.setString(6, s.address);
                stmt.setString(7, s.id);
                stmt.setString(8, id);
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

    static class Student {
        public String name, gender;
        public Date birthday;
        public String id, qq, phone, address;
    }
}
