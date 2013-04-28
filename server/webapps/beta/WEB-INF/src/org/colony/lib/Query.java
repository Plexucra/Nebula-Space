package org.colony.lib;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Query
{
	String sql;
	Connection c = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	int currentParameterPos = 1;

	public Query(String sql)
	{
		if(Sql.get(sql)!=null) sql=Sql.get(sql);
		this.sql = sql;
	}

	public Query(String sql, Connection c)
	{
		if(Sql.get(sql)!=null) sql=Sql.get(sql);
		this.sql = sql;
		this.c = c;
	}

	public PreparedStatement getPs() throws SQLException
	{
		if (c == null)
			c = DbEngine.getConnection();
		if (ps == null)
			ps = c.prepareStatement(getSql());
		return ps;
	}

	public void addParameter(int p) throws SQLException
	{
		getPs().setInt(currentParameterPos++, p);
	}

	public void addParameter(String p) throws SQLException
	{
		getPs().setString(currentParameterPos++, p);
	}

	public void addParameter(long p) throws SQLException
	{
		getPs().setLong(currentParameterPos++, p);
	}

	public void addParameter(double p) throws SQLException
	{
		getPs().setDouble(currentParameterPos++, p);
	}

	public boolean nextResult() throws SQLException
	{
		if (getResult() != null)
		{
			return getResult().next();
		}
		return false;
	}

	public ResultSet getResult() throws SQLException
	{
		if (rs == null)
			rs = getPs().executeQuery();
		return rs;
	}

	public void close(Connection c)
	{
		try
		{
			if (rs != null)
				rs.close();
		} catch (SQLException e)
		{
			e.printStackTrace();
		}
		try
		{
			if (ps != null)
				ps.close();
		} catch (SQLException e)
		{
			e.printStackTrace();
		}
		try
		{
			if (c == null && this.c!=null)
				this.c.close();
		} catch (SQLException e)
		{
			e.printStackTrace();
		}
	}

	public void close()
	{
		try
		{
			if (rs != null)
				rs.close();
		} catch (SQLException e)
		{
			e.printStackTrace();
		}
		try
		{
			if (ps != null)
				ps.close();
		} catch (SQLException e)
		{
			e.printStackTrace();
		}
		try
		{
			if (c != null)
				c.close();
		} catch (SQLException e)
		{
			e.printStackTrace();
		}
	}

	public String getSql()
	{
		return sql;
	}

	public void setSql(String sql)
	{
		this.sql = sql;
	}

	public Connection getC()
	{
		return c;
	}

	public void setC(Connection c)
	{
		this.c = c;
	}

	public int getCurrentParameterPos()
	{
		return currentParameterPos;
	}

	public void setCurrentParameterPos(int currentParameterPos)
	{
		this.currentParameterPos = currentParameterPos;
	}

	public void setPs(PreparedStatement ps)
	{
		this.ps = ps;
	}

	public ResultSet getRs()
	{
		return rs;
	}

	public void setRs(ResultSet rs)
	{
		this.rs = rs;
	}

}