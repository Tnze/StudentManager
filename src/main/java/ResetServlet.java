import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class ResetServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        String user = (String) session.getAttribute("Username");
        int id = (int) session.getAttribute("ID");

        String pswd = req.getParameter("pswd");
        String pswd_new = req.getParameter("pswd_new");
        try {
            if (id != Account.login(user, pswd)) throw new Exception("User ID not match");
            Account.reset(id, pswd_new);
            resp.setStatus(204);
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().print("由于某种原因，无法重置密码");
        }
    }
}