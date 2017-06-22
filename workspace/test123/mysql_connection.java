import java.sql.Connection;
import java.sql.DriverManager;

class JDBCTest {

    String url = “jdbc:mysql://172.19.5.25”;

    String user = “hive”;

    String password = “hive”;

    public static void main(String args[]) {

        try {
            Connection con;
            con = DriverManager.getConnection(url, user, password);
            System.out.println(“Success”); 
        } catch (Exception e) {
            e.printStackTrace(); 
        }
    }
}