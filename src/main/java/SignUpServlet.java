import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


public class SignUpServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        String user = req.getParameter("user");
        String pswd = req.getParameter("pswd");
        try {
            Account.register(user, pswd);
            resp.setStatus(204);
        } catch (Account.AccountException e) {
            resp.setStatus(403);
            resp.getWriter().print(e.getMessage());
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().print("由于服务器问题，暂时无法重置");
        }
    }
}
