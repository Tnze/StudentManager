import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;


public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        String user = req.getParameter("user");
        String pswd = req.getParameter("pswd");
        try {
            int id = Account.login(user, pswd);
            HttpSession session = req.getSession();
            session.setAttribute("ID", id);
            session.setAttribute("Username", user);
            resp.setStatus(204);
        } catch (Account.AccountException e) {
            resp.setStatus(403);
            resp.getWriter().print("登录失败：" + e.getMessage());
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().print("由于服务器问题，暂时无法登录");
        }
    }
}
