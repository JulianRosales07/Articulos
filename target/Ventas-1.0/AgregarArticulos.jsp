<%-- 
    Document   : AgregarArticulos.jsp
    Created on : 2/10/2024, 8:09:25 a. m.
    Author     : Julian
--%>

<%@page import="java.sql.PreparedStatement"%>
<%@page import="mundo.Conexion"%>
<%@page import="java.sql.Connection"%>
<%@include file="lib/header.jsp" %>
<link rel="stylesheet" type="text/css" href="Estilos/style2.css">
<div class="text-center text-success">
    <h1>Agregar Art�culo</h1>
</div>
<div class="container">
    <div class="row">
        <div class="col-md-4 mx-auto">
            <div class="card card-body">
                <!-- Formulario para agregar art�culos -->
                <form action="#" method="POST">
                    <div class="mb-3">
                        <label for="nombre" class="form-label">Nombre:</label>
                        <input type="text" class="form-control" id="nombre" name="nombre" placeholder="Nombre" required>
                    </div>
                    <div class="mb-3">
                        <label for="descripcion" class="form-label">Descripci�n:</label>
                        <input type="text" class="form-control" id="descripcion" name="descripcion" placeholder="Descripci�n" required>
                    </div>
                    <div class="mb-3">
                        <label for="precio" class="form-label">Precio:</label>
                        <input type="number" step="0.01" class="form-control" id="precio" name="precio" placeholder="Precio" required>
                    </div>
                    
                    <div class="text-center" style="margin-top: 10px;">
                        <a class="btn btn-secondary" href="index.jsp">Cancelar</a>
                        <button type="submit" class="btn btn-primary" name="enviar">Agregar</button>
                    </div>
                </form>

                <!-- L�gica para agregar art�culos en la base de datos -->
                <%
                if(request.getParameter("enviar") != null) {
                    // Capturar los datos del formulario
                    String nombre = request.getParameter("nombre");
                    String descripcion = request.getParameter("descripcion");
                    String precio = request.getParameter("precio");

                    try {
                        // Crear instancia de la conexi�n
                        Conexion conexion = new Conexion();
                        Connection con = null;
                        PreparedStatement ps = null;

                        con = conexion.getConnection();
                        
                        // Preparar la consulta de inserci�n
                        String query = "INSERT INTO articulos(nombre, descripcion, precio) VALUES(?, ?, ?)";
                        ps = con.prepareStatement(query);
                        
                        // Configurar los valores en la consulta preparada
                        ps.setString(1, nombre);
                        ps.setString(2, descripcion);
                        ps.setDouble(3, Double.parseDouble(precio));
                        
                        // Ejecutar la consulta
                        int resultado = ps.executeUpdate();

                        if (resultado > 0) {
                            out.println("<div class='alert alert-success text-center' role='alert'>Art�culo agregado exitosamente</div>");
                        } else {
                            out.println("<div class='alert alert-danger text-center' role='alert'>Error al agregar el art�culo</div>");
                        }

                        // Redirigir a la p�gina de inicio despu�s de agregar el registro
                        request.getRequestDispatcher("index.jsp").forward(request, response);
                        
                    } catch (Exception e) {
                        out.print("<div class='alert alert-danger text-center' role='alert'>" + e + "</div>");
                    }
                }
                %>
            </div>
        </div>
    </div>
</div>

<%@include file="lib/footer.jsp" %>
 %>