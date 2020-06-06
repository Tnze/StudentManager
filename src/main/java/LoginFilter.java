import javax.servlet.*;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter extends HttpFilter {
    @Override
    public void doFilter(HttpServletRequest req, HttpServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpSession s = req.getSession();
        if (s.getAttribute("ID") == null) {
            if ("GET".equals(req.getMethod()))
                resp.sendRedirect("login.jsp");
            else
                resp.sendError(401, "Please login first");
            return;
        }
        chain.doFilter(req, resp);
    }
}
