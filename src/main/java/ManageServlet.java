import com.mysql.cj.xdevapi.JsonArray;
import com.mysql.cj.xdevapi.JsonValue;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;

public class ManageServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        JSONObject ret = new JSONObject();
        try {
            String action = req.getParameter("action");
            if (action == null) throw new Exception("Action not set");
            switch (action) {
                case "list" -> {
                    JSONArray list = new JSONArray();
                    Manager.Student[] students = Manager.getList();
                    for (Manager.Student s : students) {
                        JSONObject stu = new JSONObject();
                        // TODO: setup fields
                        list.put(stu);
                    }
                    ret.put("list", list);
                }
                case "delete" -> resp.setStatus(501);
                default -> {
                    resp.setStatus(400);
                    ret.put("err", "Unknown action");
                }
            }
        } catch (Exception e) {
            resp.setStatus(500);
            System.err.println(Arrays.toString(e.getStackTrace()));
            ret.put("err", e.getClass().getName());
        } finally {
            resp.getWriter().write(ret.toString());
        }
    }
}
