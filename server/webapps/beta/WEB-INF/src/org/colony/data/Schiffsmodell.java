package org.colony.data;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Schiffsmodell
{
	int id;
	int fabrikModellId;
	int schildPunkte;
	int panzerPunkte;
	String bezeichnung;
	int schildWaffenPunkte;
	int panzerWaffenPunkte;
	int sprungzeit;
	public Schiffsmodell(ResultSet rs) throws SQLException
	{
		setId(rs.getInt("id"));
		setFabrikModellId(rs.getInt("fabrikModellId"));
		setSchildPunkte(rs.getInt("schildPunkte"));
		setPanzerPunkte(rs.getInt("panzerPunkte"));
		setBezeichnung(rs.getString("bezeichnung"));
		setSchildWaffenPunkte(rs.getInt("schildWaffenPunkte"));
		setPanzerWaffenPunkte(rs.getInt("panzerWaffenPunkte"));
		setSprungzeit(rs.getInt("sprungzeit"));
	}
	public int getId()
	{
		return id;
	}
	public void setId(int id)
	{
		this.id = id;
	}
	public int getFabrikModellId()
	{
		return fabrikModellId;
	}
	public void setFabrikModellId(int fabrikModellId)
	{
		this.fabrikModellId = fabrikModellId;
	}
	public int getSchildPunkte()
	{
		return schildPunkte;
	}
	public void setSchildPunkte(int schildPunkte)
	{
		this.schildPunkte = schildPunkte;
	}
	public int getPanzerPunkte()
	{
		return panzerPunkte;
	}
	public void setPanzerPunkte(int panzerPunkte)
	{
		this.panzerPunkte = panzerPunkte;
	}
	public String getBezeichnung()
	{
		return bezeichnung;
	}
	public void setBezeichnung(String bezeichnung)
	{
		this.bezeichnung = bezeichnung;
	}
	public int getSchildWaffenPunkte()
	{
		return schildWaffenPunkte;
	}
	public void setSchildWaffenPunkte(int schildWaffenPunkte)
	{
		this.schildWaffenPunkte = schildWaffenPunkte;
	}
	public int getPanzerWaffenPunkte()
	{
		return panzerWaffenPunkte;
	}
	public void setPanzerWaffenPunkte(int panzerWaffenPunkte)
	{
		this.panzerWaffenPunkte = panzerWaffenPunkte;
	}
	public int getSprungzeit()
	{
		return sprungzeit;
	}
	public void setSprungzeit(int sprungzeit)
	{
		this.sprungzeit = sprungzeit;
	}
}