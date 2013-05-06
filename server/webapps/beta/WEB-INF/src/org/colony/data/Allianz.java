package org.colony.data;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Allianz
{
	int id;
	String bezeichnung;

	public Allianz(ResultSet rs) throws SQLException
	{
		id = rs.getInt("id");
		bezeichnung = rs.getString("bezeichnung");
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public String getBezeichnung()
	{
		return bezeichnung;
	}

	public void setBezeichnung(String bezeichnung)
	{
		this.bezeichnung = bezeichnung;
	}
}