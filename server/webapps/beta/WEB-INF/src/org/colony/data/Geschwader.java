package org.colony.data;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.colony.lib.ContextListener;

public class Geschwader implements Serializable
{
	private static final long serialVersionUID = 1L;
	int id;
	int anzahl;
	int flotteId;
	int schiffsmodellId;
	//nur mittel zum zweck und nicht immer befüllt..
	int nutzerId;


	public Geschwader()
	{
	}
	public Geschwader(ResultSet rs) throws SQLException
	{
		setId(rs.getInt("id"));
		setAnzahl(rs.getInt("anzahl"));
		setFlotteId(rs.getInt("flotteId"));
		setSchiffsmodellId(rs.getInt("schiffsmodellId"));
	}
	public Geschwader(int anzahl, int schiffsmodellId)
	{
		this.anzahl = anzahl;
		this.schiffsmodellId = schiffsmodellId;
	}
	public double getMasse()
	{
		return getSchiffsmodell().getMasse()*anzahl;
	}
	public Geschwader clone()
	{
		Geschwader result = new Geschwader();
		result.setId(id);
		result.setAnzahl(anzahl);
		result.setFlotteId(flotteId);
		result.setSchiffsmodellId(schiffsmodellId);
		return result;
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
	public int getNutzerId()
	{
		return nutzerId;
	}
	public void setNutzerId(int nutzerId)
	{
		this.nutzerId = nutzerId;
	}
	
}