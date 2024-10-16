/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mundo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author julian
 */
public class Conexion {

public static final String URL="jdbc:mysql://localhost:3306/ventas?autoReconnet=true&useSSL=false";
    private final String USER = "root";
    private final String PASSWORD = "1193";

    public Connection getConnection() {
        Connection con = null;
        try {
            // Cargar el driver de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Establecer la conexión
            con = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            e.printStackTrace(); // Imprime el error de SQL
        } catch (ClassNotFoundException e) {
            e.printStackTrace(); // Imprime el error si el driver no se encuentra
        }
        return con; // Devuelve la conexión (puede ser null si hubo un error)
    }
}