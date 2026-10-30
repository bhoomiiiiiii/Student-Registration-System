package com.mycompany.assignment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/students")
public class studentservlet extends HttpServlet {

    private static final List<student> studentList = new ArrayList<>();
    private static int nextId = 1;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        // DELETE
        if ("delete".equals(action)) {
            int id = toInt(req.getParameter("id"));
            studentList.removeIf(s -> s.getId() == id);
            res.sendRedirect("students");
            return;
        }

        // EDIT
        if ("edit".equals(action)) {
            int id = toInt(req.getParameter("id"));
            for (student s : studentList) {
                if (s.getId() == id) {
                    req.setAttribute("editStudent", s);
                    break;
                }
            }
        }

        // SEARCH
        String q = req.getParameter("q");
        List<student> result = new ArrayList<>();
        if (q == null || q.trim().isEmpty()) {
            result.addAll(studentList);
        } else {
            String key = q.trim().toLowerCase();
            for (student s : studentList) {
                if (s.getName().toLowerCase().contains(key)
                        || s.getEmail().toLowerCase().contains(key)
                        || s.getCourse().toLowerCase().contains(key)) {
                    result.add(s);
                }
            }
        }

        req.setAttribute("students", result);
        req.setAttribute("total", studentList.size());
        req.setAttribute("q", q == null ? "" : q);
        req.getRequestDispatcher("index.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        int id = toInt(req.getParameter("id"));
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String course = req.getParameter("course");

        if (name != null && !name.trim().isEmpty()
                && email != null && !email.trim().isEmpty()) {

            if (id == 0) {
                // ADD
                studentList.add(new student(nextId++, name.trim(), email.trim(), course));
            } else {
                // UPDATE
                for (student s : studentList) {
                    if (s.getId() == id) {
                        s.setName(name.trim());
                        s.setEmail(email.trim());
                        s.setCourse(course);
                        break;
                    }
                }
            }
        }
        res.sendRedirect("students");
    }

    private int toInt(String v) {
        try {
            return Integer.parseInt(v);
        } catch (Exception e) {
            return 0;
        }
    }
}