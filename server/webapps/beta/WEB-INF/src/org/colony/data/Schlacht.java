package org.colony.data;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.colony.lib.ContextListener;

public class Schlacht
{
	int id;
	int anfangTick;
	int x;
	int y;
	int endeTick;
	public Schlacht(ResultSet rs) throws SQLException
	{
		setId(rs.getInt("id"));
		setX( rs.getInt("x") );
		setY( rs.getInt("y") );
		setAnfangTick(  rs.getInt("anfangTick")  );
		setEndeTick(  rs.getInt("endeTick")  );
	}
	public Schlacht(ResultSet rs, int anfangTick, int endeTick) throws SQLException
	{
		setX( rs.getInt("x") );
		setY( rs.getInt("y") );
		setAnfangTick( anfangTick );
		setEndeTick(endeTick);
	}
	
	public int getKampftick()
	{
		return ContextListener.getTicker().getTick() - anfangTick;
	}
	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public int getAnfangTick()
	{
		return anfangTick;
	}

	public void setAnfangTick(int anfangTick)
	{
		this.anfangTick = anfangTick;
	}

	public int getX()
	{
		return x;
	}

	public void setX(int x)
	{
		this.x = x;
	}

	public int getY()
	{
		return y;
	}

	public void setY(int y)
	{
		this.y = y;
	}

	public int getEndeTick()
	{
		return endeTick;
	}

	public void setEndeTick(int endeTick)
	{
		this.endeTick = endeTick;
	}
}