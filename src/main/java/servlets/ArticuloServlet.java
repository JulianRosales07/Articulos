/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;


import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import mundo.Conexion;


/**
 *
 * @author julia
 */
@WebServlet("/ArticuloServlet")
public class ArticuloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String buscarId = request.getParameter("buscar");
        Conexion conexion = new Conexion();
        try (Connection con = (Connection) conexion.getConnection()) {
            PreparedStatement ps;
            if (buscarId != null && !buscarId.isEmpty()) {
                ps = con.prepareStatement("SELECT * FROM articulos WHERE id = ?");
                ps.setString(1, buscarId);
            } else {
                ps = con.prepareStatement("SELECT * FROM articulos");
            }

            ResultSet rs = ps.executeQuery();
            request.setAttribute("articulos", rs);
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al conectar con la base de datos: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}
