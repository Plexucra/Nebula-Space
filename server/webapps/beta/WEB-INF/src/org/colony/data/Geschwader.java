package org.colony.data;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.colony.lib.ContextListener;

public class Geschwader
{
	int id;
	int anzahl;
	int flotteId;
	int schiffsmodellId;
	public Geschwader(ResultSet rs) throws SQLException
	{
		setId(rs.getInt("id"));
		setAnzahl(rs.getInt("anzahl"));
		setFlotteId(rs.getInt("flotteId"));
		setSchiffsmodellId(rs.getInt("schiffsmodellId"));
	}
	public Schiffsmodell getSchiffsmodell()
	{
		return ContextListener.getService().getSchiffsmodell(getSchiffsmodellId());
	}
	public int getAnzahl()
	{
		return anzahl;
	}
	public void setAnzahl(int anzahl)
	{
		this.anzahl = anzahl;
	}
	public int getSchiffsmodellId()
	{
		return schiffsmodellId;
	}
	public void setSchiffsmodellId(int schiffsmodellId)
	{
		this.schiffsmodellId = schiffsmodellId;
	}
	public int getFlotteId()
	{
		return flotteId;
	}
	public void setFlotteId(int flotteId)
	{
		this.flotteId = flotteId;
	}
	public int getId()
	{
		return id;
	}
	public void setId(int id)
	{
		this.id = id;
	}
	
}