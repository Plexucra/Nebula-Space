package org.colony.data;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.colony.service.SchiffsmodellService;

public class Schiffsmodell
{
	int id;
	int fabrikModellId;
	String bezeichnung;
	int sprungzeit;
	int masse;
	Map<Integer,Float> bonusListe = new HashMap<Integer,Float>();
	public Schiffsmodell(Connection c, ResultSet rs) throws SQLException
	{
		setId(rs.getInt("id"));
		setFabrikModellId(rs.getInt("fabrikModellId"));
		setBezeichnung(rs.getString("bezeichnung"));
		setSprungzeit(rs.getInt("sprungzeit"));
		setMasse(rs.getInt("masse"));
		bonusListe = SchiffsmodellService.getBonusListe(c, this);
	}
	public float getAngriffsbonus(Schiffsmodell m)
	{
		if(getBonusListe().get(m.getId())==null) return 0f;
		return getBonusListe().get(m.getId());
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
	public String getBezeichnung()
	{
		return bezeichnung;
	}
	public void setBezeichnung(String bezeichnung)
	{
		this.bezeichnung = bezeichnung;
	}

	public int getSprungzeit()
	{
		return sprungzeit;
	}
	public void setSprungzeit(int sprungzeit)
	{
		this.sprungzeit = sprungzeit;
	}
	public int getMasse()
	{
		return masse;
	}
	public void setMasse(int masse)
	{
		this.masse = masse;
	}
	public Map<Integer, Float> getBonusListe()
	{
		return bonusListe;
	}
	public void setBonusListe(Map<Integer, Float> bonusListe)
	{
		this.bonusListe = bonusListe;
	}
}