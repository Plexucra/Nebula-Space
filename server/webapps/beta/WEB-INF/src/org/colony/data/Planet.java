package org.colony.data;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.colony.service.AllianzService;

public class Planet
{
	public Planet( ResultSet rs) throws SQLException
	{
		setId(rs.getInt("id"));
		setAllianzId(rs.getInt("allianzId"));
		setX(rs.getInt("x"));
		setY(rs.getInt("y"));
		setSpezies(rs.getString("spezies"));
		setName( rs.getString("name"));
		ress1Vorkommen = rs.getInt("ress1Vorkommen");
		ress2Vorkommen = rs.getInt("ress2Vorkommen");
		ress3Vorkommen = rs.getInt("ress3Vorkommen");
		ress4Vorkommen = rs.getInt("ress4Vorkommen");
		ress5Vorkommen = rs.getInt("ress5Vorkommen");
	}
	int id;
	int allianzId;
	int x;
	int y;
	String spezies;
	String name;
	int ress1Vorkommen;
	int ress2Vorkommen;
	int ress3Vorkommen;
	int ress4Vorkommen;
	int ress5Vorkommen;
	

	public Allianz getAllianz()
	{
		return AllianzService.getAllianz(allianzId);
	}

//	Deadlock problem..
//	public int getAnzahlNutzer()
//	{
//		return PlanetService.getAnzahlNutzer(this);
//	}

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

	public int getAllianzId()
	{
		return allianzId;
	}

	public void setAllianzId(int allianzId)
	{
		this.allianzId = allianzId;
	}

	public int getRess1Vorkommen()
	{
		return ress1Vorkommen;
	}

	public void setRess1Vorkommen(int ress1Vorkommen)
	{
		this.ress1Vorkommen = ress1Vorkommen;
	}

	public int getRess2Vorkommen()
	{
		return ress2Vorkommen;
	}

	public void setRess2Vorkommen(int ress2Vorkommen)
	{
		this.ress2Vorkommen = ress2Vorkommen;
	}

	public int getRess3Vorkommen()
	{
		return ress3Vorkommen;
	}

	public void setRess3Vorkommen(int ress3Vorkommen)
	{
		this.ress3Vorkommen = ress3Vorkommen;
	}

	public int getRess4Vorkommen()
	{
		return ress4Vorkommen;
	}

	public void setRess4Vorkommen(int ress4Vorkommen)
	{
		this.ress4Vorkommen = ress4Vorkommen;
	}

	public int getRess5Vorkommen()
	{
		return ress5Vorkommen;
	}

	public void setRess5Vorkommen(int ress5Vorkommen)
	{
		this.ress5Vorkommen = ress5Vorkommen;
	}

}