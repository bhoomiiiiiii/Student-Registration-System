<%@ page contentType="text/html;charset=UTF-8" import="java.util.*,com.mycompany.assignment.student" %>
<%!
    String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;");
    }
%>
<%
    student editS = (student) request.getAttribute("editStudent");
    List<student> list = (List<student>) request.getAttribute("students");
    Integer total = (Integer) request.getAttribute("total");
    String q = (String) request.getAttribute("q");
    if (total == null) total = 0;
    if (q == null) q = "";

    String[] courses = {"B.Tech CSE", "B.Tech IT", "BCA", "MCA"};
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Registration</title>
    <style>
        * { box-sizing: border-box; font-family: 'Segoe UI', Arial, sans-serif; }
        body { margin: 0; padding: 30px 15px; background: linear-gradient(135deg, #667eea, #764ba2); min-height: 100vh; }
        .container { max-width: 900px; margin: auto; }
        h2 { text-align: center; color: #fff; font-size: 32px; margin-bottom: 20px; }
        .stats { text-align: center; margin-bottom: 25px; }
        .badge { display: inline-block; background: rgba(255,255,255,0.2); color: #fff; padding: 8px 22px; border-radius: 30px; font-size: 16px; }
        .card { background: #fff; padding: 25px; border-radius: 14px; box-shadow: 0 8px 25px rgba(0,0,0,0.2); margin-bottom: 25px; }
        .card h3 { margin-top: 0; color: #444; }
        .form-row { display: flex; flex-wrap: wrap; gap: 12px; }
        input[type="text"], input[type="email"], select { flex: 1; min-width: 180px; padding: 11px 14px; border: 1.5px solid #ddd; border-radius: 8px; font-size: 15px; outline: none; transition: 0.3s; }
        input:focus, select:focus { border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,0.2); }
        .btn { padding: 11px 24px; border: none; border-radius: 8px; font-size: 15px; cursor: pointer; text-decoration: none; color: #fff; display: inline-block; transition: 0.3s; }
        .btn-primary { background: #667eea; }
        .btn-primary:hover { background: #5568d3; }
        .btn-grey { background: #8a8fa3; }
        .btn-grey:hover { background: #6f7488; }
        .header-row { display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px; margin-bottom: 15px; }
        .header-row h3 { margin: 0; }
        .search-form { display: flex; gap: 8px; flex-wrap: wrap; }
        .search-form input[type="text"] { min-width: 220px; }
        table { width: 100%; border-collapse: collapse; overflow: hidden; border-radius: 10px; }
        th { background: #667eea; color: #fff; padding: 13px; text-align: left; }
        td { padding: 12px 13px; border-bottom: 1px solid #eee; color: #333; }
        tr:nth-child(even) td { background: #f7f8ff; }
        tr:hover td { background: #eceeff; }
        .action-btn { padding: 6px 14px; border-radius: 6px; text-decoration: none; font-size: 14px; color: #fff; transition: 0.3s; }
        .edit-btn { background: #f5a623; }
        .edit-btn:hover { background: #d98e10; }
        .delete-btn { background: #ff5c5c; }
        .delete-btn:hover { background: #e03e3e; }
        .empty { text-align: center; color: #888; padding: 20px; }
    </style>
</head>
<body>
<div class="container">

    <h2>🎓 Student Registration</h2>

    <div class="stats">
        <span class="badge">Total Students: <b><%= total %></b></span>
    </div>

    <div class="card">
        <h3><%= editS != null ? "Edit Student" : "Register New Student" %></h3>
        <form action="students" method="post">
            <input type="hidden" name="id" value="<%= editS != null ? editS.getId() : 0 %>">
            <div class="form-row">
                <input type="text" name="name" placeholder="Full Name"
                       value="<%= editS != null ? esc(editS.getName()) : "" %>" required>
                <input type="email" name="email" placeholder="Email"
                       value="<%= editS != null ? esc(editS.getEmail()) : "" %>" required>
                <select name="course">
                    <% for (String c : courses) { %>
                    <option <%= (editS != null && c.equals(editS.getCourse())) ? "selected" : "" %>><%= c %></option>
                    <% } %>
                </select>
                <input type="submit" class="btn btn-primary"
                       value="<%= editS != null ? "Update" : "Register" %>">
                <% if (editS != null) { %>
                <a href="students" class="btn btn-grey">Cancel</a>
                <% } %>
            </div>
        </form>
    </div>

    <div class="card">
        <div class="header-row">
            <h3>Registered Students</h3>
            <form action="students" method="get" class="search-form">
                <input type="text" name="q" placeholder="Search name, email or course" value="<%= esc(q) %>">
                <input type="submit" class="btn btn-primary" value="Search">
                <a href="students" class="btn btn-grey">Reset</a>
            </form>
        </div>

        <table>
            <tr><th>ID</th><th>Name</th><th>Email</th><th>Course</th><th>Actions</th></tr>
            <%
                if (list != null && !list.isEmpty()) {
                    for (student s : list) {
            %>
            <tr>
                <td><%= s.getId() %></td>
                <td><%= esc(s.getName()) %></td>
                <td><%= esc(s.getEmail()) %></td>
                <td><%= esc(s.getCourse()) %></td>
                <td>
                    <a class="action-btn edit-btn" href="students?action=edit&id=<%= s.getId() %>">Edit</a>
                    <a class="action-btn delete-btn" href="students?action=delete&id=<%= s.getId() %>"
                       onclick="return confirm('Delete this student?')">Delete</a>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr><td colspan="5" class="empty">No students found.</td></tr>
            <% } %>
        </table>
    </div>

</div>
</body>
</html>