package org.colony.lib;

import java.sql.Connection;
import java.sql.DriverManager;

public class DbEngine
{
	public static Connection getConnection() throws Exception
	{
		Connection conn = null;
		try
		{
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			
			try
			{
				conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/97_nebula","97_nebula","ketzer82");
			}
			catch(Exception ex2)
			{
				conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/97_nebula","root","start");
			}

//			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/colony","root","start");
			conn.setAutoCommit(false);
		}
		catch(Exception ex)
		{
			if(conn!=null)
				conn.close();
			throw ex;
		}
		return conn;
	}
}