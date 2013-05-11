package org.colony.lib;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DbEngine
{
	public static void close(Connection c)
	{
		try
		{
			if(c!=null)
				c.close();
		}
		catch(SQLException ex)
		{
			ex.printStackTrace();
		}
	}
	public static String generateQsForIn(int numQs)
	{
	    StringBuffer items = new StringBuffer(numQs*5);
	    for (int i = 0; i < numQs; i++) 
	    {
	        if (i != 0) items.append(", ");
	        items.append("?");
	    }
	    return items.toString();
	}

	public static int exec(Connection c,String sql, int... p) throws SQLException
	{
		PreparedStatement ps = c.prepareStatement(Sql.get(sql));
		if(p!=null)
			for(int i =0; i< p.length; i++)
				ps.setInt(i+1, p[i]);
		System.out.println("exec: "+ps.toString());
		int result = ps.executeUpdate();
		ps.close();
		return result;
	}
	public static Connection open() throws SQLException
	{
		return getConnection();
	}
	public static Connection getConnection() throws SQLException
	{
		Connection conn = null;
		try
		{
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			
			try
			{
				conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/beta","root","ketzer82");
			}
			catch(Exception ex2)
			{
				conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/97_nebula","root","start");
			}

//			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/colony","root","start");
			conn.setAutoCommit(false);
		}
		catch(SQLException ex)
		{
			if(conn!=null)
				conn.close();
			throw ex;
		} catch (InstantiationException e)
		{
			e.printStackTrace();
			throw new SQLException(e.getMessage());
		} catch (IllegalAccessException e)
		{
			e.printStackTrace();
			throw new SQLException(e.getMessage());
		} catch (ClassNotFoundException e)
		{
			e.printStackTrace();
			throw new SQLException(e.getMessage());
		}
		return conn;
	}
}