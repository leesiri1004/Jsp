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
	 
	            //DB�� ����� conn ��ü�κ��� Statement ��ü ȹ��.
	            stmt = conn.createStatement();
	 
	            //query �����
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
	 
	            //query�� ������
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
	                //�ڿ� ����
	                if(conn != null && !conn.isClosed())
	                    conn.close();
	            } catch(SQLException e){
	                e.printStackTrace();
	            }
	        }
	    }
	}
