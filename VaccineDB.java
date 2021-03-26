import java.sql.*;
import java.util.Scanner;

public class VaccineDB {
  
  public static void main(String args[]) {
    try (
      Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HW_Vaccine", "testuser", "password"); //Attempts to connect with DB
      
         Statement spjStatement = conn.createStatement(); Statement inputS = conn.createStatement();) { // Creates two new statements
         String select = "SELECT VACCINE.Manufacturer FROM VACCINE, EFFICACY WHERE VACCINE.Name = EFFICACY.VaccineName;"; // SQL Select statement
         System.out.println("STATEMENT: " + select + "\n"); // prints statement
         ResultSet results = spjStatement.executeQuery(select); // returns query results in results
         
         System.out.println("Vaccine Manufacturers: ");
         int rows = 0;
         String name;
         
         while (results.next()) { // prints results
           name = results.getString("Manufacturer");
           System.out.println(name);
           rows++;
         }
         System.out.println("Results (" + rows + ")"); //returns result count
         System.out.println();
         
         Scanner input = new Scanner(System.in); // new input scanner
         System.out.print("Enter your own company:\n"); //user enters own company
         String newCompany = input.nextLine(); // grabs user input
         System.out.print("Enter your own website:\n"); //user enters own website
         String newSite = input.nextLine(); // grabs user input
         
         String insert = "INSERT INTO COMPANY VALUES ('" + newCompany + "','" + newSite + "');"; // SQL update statement
         inputS.executeUpdate(insert); //executes
         System.out.println("NEW COMPANY ADDED!!!"); // Yayy new company added!!!
         
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