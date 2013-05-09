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
	int ress1Kosten;
	int ress2Kosten;
	int ress3Kosten;
	int ress4Kosten;
	int ress5Kosten;
	boolean frachter;

	Map<Integer, Float> bonusListe = new HashMap<Integer, Float>();

	public Schiffsmodell(Connection c, ResultSet rs) throws SQLException
	{
		setId(rs.getInt("id"));
		setFabrikModellId(rs.getInt("fabrikModellId"));
		setBezeichnung(rs.getString("bezeichnung"));
		setSprungzeit(rs.getInt("sprungzeit"));
		setMasse(rs.getInt("masse"));
		setRess1Kosten(rs.getInt("ress1Kosten"));
		setRess2Kosten(rs.getInt("ress2Kosten"));
		setRess3Kosten(rs.getInt("ress3Kosten"));
		setRess4Kosten(rs.getInt("ress4Kosten"));
		setRess5Kosten(rs.getInt("ress5Kosten"));
		setFrachter(rs.getBoolean("frachter"));
		bonusListe = SchiffsmodellService.getBonusListe(c, this);
	}

	public float getAngriffsbonus(Schiffsmodell m)
	{
		if (getBonusListe().get(m.getId()) == null)
			return 1f;
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

	public int getRess1Kosten()
	{
		return ress1Kosten;
	}

	public void setRess1Kosten(int ress1Kosten)
	{
		this.ress1Kosten = ress1Kosten;
	}

	public int getRess2Kosten()
	{
		return ress2Kosten;
	}

	public void setRess2Kosten(int ress2Kosten)
	{
		this.ress2Kosten = ress2Kosten;
	}

	public int getRess3Kosten()
	{
		return ress3Kosten;
	}

	public void setRess3Kosten(int ress3Kosten)
	{
		this.ress3Kosten = ress3Kosten;
	}

	public int getRess4Kosten()
	{
		return ress4Kosten;
	}

	public void setRess4Kosten(int ress4Kosten)
	{
		this.ress4Kosten = ress4Kosten;
	}

	public int getRess5Kosten()
	{
		return ress5Kosten;
	}

	public void setRess5Kosten(int ress5Kosten)
	{
		this.ress5Kosten = ress5Kosten;
	}

	public boolean isFrachter()
	{
		return frachter;
	}

	public void setFrachter(boolean frachter)
	{
		this.frachter = frachter;
	}
}