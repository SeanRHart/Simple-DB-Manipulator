import java.sql.*;
import java.util.Scanner;

public class VaccineDB {
  
  public static void main(String args[]) {
    try (
      Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HW_Vaccine", "testuser", "password");
      
         Statement spjStatement = conn.createStatement(); Statement inputS = conn.createStatement();) {
         String select = "SELECT VACCINE.Manufacturer FROM VACCINE, EFFICACY WHERE VACCINE.Name = EFFICACY.VaccineName;";
         System.out.println("STATEMENT: " + select + "\n");
         ResultSet results = spjStatement.executeQuery(select);
         
         System.out.println("Vaccine Manufacturers: ");
         int rows = 0;
         String name;
         
         while (results.next()) {
           name = results.getString("Manufacturer");
           System.out.println(name);
           rows++;
         }
         System.out.println("Results (" + rows + ")");
         System.out.println();
         
         Scanner input = new Scanner(System.in);
         System.out.print("Enter your own company:\n");
         String newCompany = input.nextLine();
         System.out.print("Enter your own website:\n");
         String newSite = input.nextLine();
         
         String insert = "INSERT INTO COMPANY VALUES ('" + newCompany + "','" + newSite + "');";
         inputS.executeUpdate(insert);
         System.out.println("NEW COMPANY ADDED!!!");
         
         conn.close();
    }
    catch (SQLException ex) {
      ex.printStackTrace();
    }
    catch (Exception e) {
      System.out.println(e);
    }

  }
}