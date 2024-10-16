<%-- 
    Document   : editar
    Created on : 6/10/2024, 5:27:24 p. m.
    Author     : julian
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement" %>
<%@ page import="mundo.Conexion" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Editar Artículo</title>
    </head>
    <body>
        <h1>Actualizar Artículo</h1>

<%
    // Obtener los valores enviados por el formulario de edición
    String id = request.getParameter("id");
    String nombre = request.getParameter("nombre");
    String descripcion = request.getParameter("descripcion");
    String precio = request.getParameter("precio");

    Connection con = null;
    PreparedStatement ps = null;
    Conexion conexion = new Conexion();
    
    try {
        // Conectar a la base de datos y preparar la consulta de actualización
        con = conexion.getConnection();
        String sql = "UPDATE articulos SET nombre=?, descripcion=?, precio=? WHERE id=?";
        ps = con.prepareStatement(sql);
        ps.setString(1, nombre);
        ps.setString(2, descripcion);
        ps.setString(3, precio);
        ps.setString(4, id);
        
        // Ejecutar la actualización
        int result = ps.executeUpdate();

        // Redirigir de nuevo al index.jsp para ver los cambios reflejados
        response.sendRedirect("index.jsp");

    } catch (Exception e) {
        out.println("Error al actualizar el artículo: " + e.getMessage());
    } finally {
        try {
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (Exception e) {
            out.println("Error al cerrar la conexión: " + e.getMessage());
        }
    }
%>

    </body>
</html>
