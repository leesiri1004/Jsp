package sub1;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class create {
	    public static void main(String[] args){
	        Connection conn = null;
	        Statement stmt = null;
	 
	    	String host = "jdbc:mysql://192.168.10.114:3306/lse";
	    	String user = "lse";
	    	String pass = "1234";
	 
	        try{
	            Class.forName("com.mysql.jdbc.Driver");
	 
	            conn = DriverManager.getConnection(host, user, pass);
	 
	            System.out.println("Successfully Connected!");
	 
	            //DB와 연결된 conn 객체로부터 Statement 객체 획득.
	            stmt = conn.createStatement();
	 
	            //query 만들기
	            StringBuilder sb = new StringBuilder();
	            String sql = sb.append("CREATE TABLE `Employee`( ")
	                    .append("`uid` VARCHAR(10) PRIMARY KEY, ")
	                    .append("`name` VARCHAR(10), ")
	                    .append("`gender` TINYINT, ")
	                    .append("`hp` CHAR(13), ")
	                    .append("`email` VARCHAR(25), ")
	                    .append("`pos` VARCHAR(10), ")
	                    .append("`dep` TINYINT, ")
	                    .append("`rdate` DATETIME")
	                    .append(");").toString();
	 
	            //query문 날리기
	            stmt.execute(sql);
	        }
	 
	        catch(ClassNotFoundException e){
	            e.printStackTrace();
	        }
	        catch(SQLException e){
	            e.printStackTrace();
	        }
	        finally{
	            try{
	                //자원 해제
	                if(conn != null && !conn.isClosed())
	                    conn.close();
	            } catch(SQLException e){
	                e.printStackTrace();
	            }
	        }
	    }
	}
