<%-- 
    Document   : borrar
    Created on : 6/10/2024, 5:27:39 p. m.
    Author     : julian
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement" %>
<%@ page import="mundo.Conexion" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Eliminar Artículo</title>
    </head>
    <body>
        <h1>Eliminar Artículo</h1>
<%
    String id = request.getParameter("id");

    if (id != null) {
        try {
            Conexion conexion = new Conexion();
            Connection con = conexion.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM articulos WHERE id = ?");
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();

            // Redirigir al index.jsp después de eliminar
            response.sendRedirect("index.jsp");
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    } else {
        out.println("ID no proporcionado.");
    }
%>

    </body>
</html>