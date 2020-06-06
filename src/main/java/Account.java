import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.io.ByteArrayInputStream;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.*;
import java.util.Arrays;

public class Account {
    private static final String MAC_NAME = "HmacSHA512";

    public static int login(String user, String password) throws NamingException, SQLException, AccountException, NoSuchAlgorithmException, InvalidKeyException {
        Context c = new InitialContext();
        DataSource ds = (DataSource) c.lookup("java:comp/env/jdbc/students");
        try (Connection conn = ds.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement("SELECT ID,Pswd,PswdKey FROM users WHERE User = ?")) {
                stmt.setString(1, user);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    int ID = rs.getInt("ID");
                    Blob Pswd = rs.getBlob("Pswd");
                    Blob PswdKey = rs.getBlob("PswdKey");
                    // Calculate encrypted password
                    byte[] pswd = Pswd.getBytes(1, (int) Pswd.length());
                    byte[] pswdKey = PswdKey.getBytes(1, (int) PswdKey.length());
                    byte[] input = hmac(password.getBytes(), pswdKey);
                    // Check if password is allowed
                    if (Arrays.equals(input, pswd)) return ID;
                }
            }
        }
        throw new AccountException("账号或密码错误");
    }

    public static void reset(int user, String password) throws NoSuchAlgorithmException, NamingException, SQLException, InvalidKeyException {
        // Generate new password salt.
        byte[] key = new byte[512];
        new SecureRandom().nextBytes(key);
        byte[] pswd = hmac(password.getBytes(), key);
        // Update database
        Context c = new InitialContext();
        DataSource ds = (DataSource) c.lookup("java:comp/env/jdbc/students");
        try (Connection conn = ds.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement("UPDATE users SET Pswd = ?,PswdKey = ? WHERE ID = ?")) {
                stmt.setBlob(1, new ByteArrayInputStream(pswd));
                stmt.setBlob(2, new ByteArrayInputStream(key));
                stmt.setInt(3, user);
                stmt.executeUpdate();
            }
        }
    }

    public static void register(String user, String password) throws NoSuchAlgorithmException, NamingException, SQLException, InvalidKeyException, AccountException {
        // Generate new password salt.
        byte[] key = new byte[512];
        new SecureRandom().nextBytes(key);
        byte[] pswd = hmac(password.getBytes(), key);
        // Update database
        Context c = new InitialContext();
        DataSource ds = (DataSource) c.lookup("java:comp/env/jdbc/students");
        try (Connection conn = ds.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO users (User,Pswd,PswdKey) VALUES (?,?,?)")) {
                stmt.setString(1, user);
                stmt.setBlob(2, new ByteArrayInputStream(pswd));
                stmt.setBlob(3, new ByteArrayInputStream(key));
                stmt.execute();
            } catch (SQLIntegrityConstraintViolationException e) {
                throw new AccountException("用户名已存在");
            }
        }
    }

    private static byte[] hmac(byte[] text, byte[] key) throws NoSuchAlgorithmException, InvalidKeyException {
        SecretKey secretKey = new SecretKeySpec(key, MAC_NAME);
        Mac mac = Mac.getInstance(MAC_NAME);
        mac.init(secretKey);
        return mac.doFinal(text);
    }

    static class AccountException extends Exception {
        public AccountException(String message) {
            super(message);
        }
    }
}
