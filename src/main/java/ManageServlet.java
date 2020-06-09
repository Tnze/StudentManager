import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ManageServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        JSONObject ret = new JSONObject();
        try {
            String action = req.getParameter("action");
            if (action == null) throw new Exception("Action not set");
            switch (action) {
                case "list" -> {
                    JSONArray list = new JSONArray();
                    Manage.Student[] students = Manage.getList();
                    for (Manage.Student s : students) {
                        JSONObject stu = new JSONObject();
                        stu.put("id", s.id);
                        stu.put("name", s.name);
                        stu.put("gender", s.gender);
                        stu.put("birthday", s.birthday.toString());
                        stu.put("qq", s.qq);
                        stu.put("phone", s.phone);
                        stu.put("address", s.address);
                        list.add(stu);
                    }
                    ret.put("list", list);
                    resp.setStatus(200);
                }
                case "update" -> {
                    String data = req.getParameter("data");
                    if (data == null) throw new Exception("Cannot read data");
                    JSONObject stu = JSONObject.fromObject(data);
                    Manage.update(stu.getString("id"), (Manage.Student) JSONObject.toBean(stu.getJSONObject("data"), Manage.Student.class));
                }
                case "delete" -> {
                    String stu = req.getParameter("student");
                    if (stu == null) throw new Exception("Unknown which student");
                    Manage.delete(stu);
                }
                default -> {
                    ret.put("err", "Unknown action");
                    resp.setStatus(400);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            ret.put("err", e.getClass().getName());
            resp.setStatus(500);
        } finally {
            resp.getWriter().write(ret.toString());
        }
    }
}
