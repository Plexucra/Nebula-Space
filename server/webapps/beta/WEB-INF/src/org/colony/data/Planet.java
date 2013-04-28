package org.colony.data;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.colony.service.PlanetService;

public class Planet
{
	public Planet( ResultSet rs) throws SQLException
	{
		setId(rs.getInt("id"));
		setX(rs.getInt("x"));
		setY(rs.getInt("y"));
		setSpezies(rs.getString("spezies"));
		setName( rs.getString("name"));
	}
	int id;
	int x;
	int y;
	String spezies;
	String name;

	public int getAnzahlNutzer()
	{
		return PlanetService.getAnzahlNutzer(this);
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
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

	public String getSpezies()
	{
		return spezies;
	}

	public void setSpezies(String spezies)
	{
		this.spezies = spezies;
	}

	public String getName()
	{
		return name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

}