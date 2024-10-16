<%-- 
    Document   : index
    Created on : 2/10/2024, 8:15:16 a. m.
    Author     : Julian
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="lib/header.jsp" %>
<link rel="stylesheet" type="text/css" href="Estilos/style.css">
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page import="mundo.Conexion" %>

<%
    // Instancia de la clase Conexion para conectarse a la base de datos
    Conexion conexion = new Conexion();
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String buscarId = request.getParameter("buscar"); // Obtener el valor del input 'buscar'

    int currentPage = 1; // Página actual
    int recordsPerPage = 30; // Registros por página

    // Si hay un parámetro 'page' en la URL, actualizar la página actual
    if (request.getParameter("page") != null) {
        currentPage = Integer.parseInt(request.getParameter("page"));
    }

    int offset = (currentPage - 1) * recordsPerPage; // Calcular el offset
    int totalRecords = 0; // Total de registros (lo usaremos para la paginación)
%>

<div class="text-center">
    <h1 class="text-primary">Lista de Artículos</h1>
</div>

<div class="row" style="margin-top: 20px; margin-left: 20px">
    <div class="col-auto">
        <a href="AgregarArticulos.jsp" class="btn btn-success">Agregar Artículo</a>
    </div>
    <div class="col-auto ms-auto">
        <!-- Formulario para el campo de búsqueda -->
        <form method="GET" action="index.jsp" class="d-flex" style="margin-right: 60px">
            <input type="text" class="form-control" id="buscar" name="buscar" placeholder="Buscar por ID"
                   style="width: 200px; border: 1px solid black;" value="<%= (buscarId != null) ? buscarId : "" %>">
            <button type="submit" class="btn btn-success ms-1">Buscar</button>
        </form>
    </div>
</div>

<table class="table mt-3">
    <thead>
        <tr>
            <th scope="col">ID</th>
            <th scope="col">Nombre</th>
            <th scope="col">Descripcion</th>
            <th scope="col">Precio</th>
            <th scope="col">Acciones</th>
        </tr>
    </thead>
    <tbody>
        <% 
            try {
                // Obtener la conexión a la base de datos
                con = conexion.getConnection();

                String countQuery = "SELECT COUNT(*) FROM articulos";
                ps = con.prepareStatement(countQuery);
                rs = ps.executeQuery();
                
                if (rs.next()) {
                    totalRecords = rs.getInt(1); // Obtener el total de registros
                }

                rs.close();
                ps.close();

                // Consulta SQL que filtra por ID si se proporciona un valor de búsqueda
                String query = "SELECT * FROM articulos";
                if (buscarId != null && !buscarId.isEmpty()) {
                    query += " WHERE id = ?";
                }

                query += " LIMIT ? OFFSET ?"; // Agregar LIMIT y OFFSET para la paginación

                ps = con.prepareStatement(query);

                if (buscarId != null && !buscarId.isEmpty()) {
                    ps.setString(1, buscarId);
                    ps.setInt(2, recordsPerPage);
                    ps.setInt(3, offset);
                } else {
                    ps.setInt(1, recordsPerPage);
                    ps.setInt(2, offset);
                }

                // Ejecutar la consulta y obtener los resultados
                rs = ps.executeQuery();

                // Mostrar los resultados en la tabla
                while (rs.next()) {
        %>
        <tr>
            <th scope="row"><%= rs.getString("id") %></th>
            <td><%= rs.getString("nombre") %></td>
            <td><%= rs.getString("descripcion") %></td>
            <td><%= rs.getString("precio") %></td>
            <td>
                <!-- Botón para editar el artículo -->
                <a class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#exampleModal"
                   data-id="<%= rs.getString("id") %>"
                   data-nombre="<%= rs.getString("nombre") %>"
                   data-descripcion="<%= rs.getString("descripcion") %>"
                   data-precio="<%= rs.getString("precio") %>">
                    <i class="fa-solid fa-marker"></i>
                </a>
                <!-- Botón para eliminar el artículo -->
                <a class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#exampleModal2"
                   data-id="<%= rs.getString("id") %>">
                   <i class="fa fa-trash"></i>
                </a>
            </td>
        </tr>
        <%
                }

            } catch (Exception e) {
                out.println("Error de conexión: " + e.getMessage());
            } finally {
                // Cerrar los recursos para evitar fugas de memoria
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                } catch (Exception e) {
                    out.println("Error al cerrar la conexión: " + e.getMessage());
                }
            }
        %>
    </tbody>
</table>

<!-- Paginación -->
<div class="pagination">
    <ul class="pagination">
        <% 
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            for (int i = 1; i <= totalPages; i++) {
        %>
        <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
            <a class="page-link" href="index.jsp?page=<%= i %>"><%= i %></a>
        </li>
        <% } %>
    </ul>
</div>

<%@ include file="lib/footer.jsp" %>

<!-- Modal para eliminar artículo -->
<div class="modal fade" id="exampleModal2" tabindex="-1" aria-labelledby="exampleModalLabel2" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel2">Eliminar Artículo</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>¿Estás seguro de que deseas eliminar este artículo?</p>
                <form id="deleteForm" method="POST" action="borrar.jsp">
                    <input type="hidden" name="id" id="delete-id">
                    <button type="submit" class="btn btn-danger">Eliminar</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal para editar artículo -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Editar Artículo</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editForm" method="POST" action="editar.jsp">
                    <input type="hidden" name="id" id="edit-id">
                    
                    <div class="mb-3">
                        <label for="edit-nombre" class="form-label">Nombre</label>
                        <input type="text" class="form-control" id="edit-nombre" name="nombre" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="edit-descripcion" class="form-label">Descripción</label>
                        <input type="text" class="form-control" id="edit-descripcion" name="descripcion" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="edit-precio" class="form-label">Precio</label>
                        <input type="number" class="form-control" id="edit-precio" name="precio" required>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Guardar cambios</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Scripts de JavaScript -->
<script>
    // Para pasar los datos del artículo seleccionado al modal de edición
    var editModal = document.getElementById('exampleModal');
    editModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var id = button.getAttribute('data-id');
        var nombre = button.getAttribute('data-nombre');
        var descripcion = button.getAttribute('data-descripcion');
        var precio = button.getAttribute('data-precio');

        var modalIdInput = editModal.querySelector('#edit-id');
        var modalNombreInput = editModal.querySelector('#edit-nombre');
        var modalDescripcionInput = editModal.querySelector('#edit-descripcion');
        var modalPrecioInput = editModal.querySelector('#edit-precio');

        modalIdInput.value = id;
        modalNombreInput.value = nombre;
        modalDescripcionInput.value = descripcion;
        modalPrecioInput.value = precio;
    });

    // Para pasar el id del artículo seleccionado al modal de eliminación
    var deleteModal = document.getElementById('exampleModal2');
    deleteModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var id = button.getAttribute('data-id');
        var modalIdInput = deleteModal.querySelector('#delete-id');
        modalIdInput.value = id;
    });
</script>
