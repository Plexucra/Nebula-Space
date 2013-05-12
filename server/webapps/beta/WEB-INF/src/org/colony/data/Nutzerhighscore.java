package org.colony.data;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.colony.lib.Cache;

public class Nutzerhighscore
{
	int nutzerId;
	long anzahlGebaeude;
	long kapazitaetGebaeude;
	long flottenstaerke;
	long rohstoffbesitz;
	long kontostand;
	long forschungspunkte;
	long reputation;
	long highscore;

	public Nutzerhighscore(ResultSet rs) throws SQLException
	{
		nutzerId = rs.getInt("nutzerId");
		anzahlGebaeude = rs.getLong("anzahlGebaeude");
		kapazitaetGebaeude = rs.getLong("kapazitaetGebaeude");
		flottenstaerke = rs.getLong("flottenstaerke");
		rohstoffbesitz = rs.getLong("rohstoffbesitz");
		kontostand = rs.getLong("kontostand");
		forschungspunkte = rs.getLong("forschungspunkte");
		reputation = rs.getLong("reputation");
		highscore = rs.getLong("highscore");
	}

	public Nutzer getNutzer()
	{
		return Cache.get().getNutzer(getNutzerId());
	}

	public long getAnzahlGebaeude()
	{
		return anzahlGebaeude;
	}

	public void setAnzahlGebaeude(long anzahlGebaeude)
	{
		this.anzahlGebaeude = anzahlGebaeude;
	}

	public long getKapazitaetGebaeude()
	{
		return kapazitaetGebaeude;
	}

	public void setKapazitaetGebaeude(long kapazitaetGebaeude)
	{
		this.kapazitaetGebaeude = kapazitaetGebaeude;
	}

	public long getFlottenstaerke()
	{
		return flottenstaerke;
	}

	public void setFlottenstaerke(long flottenstaerke)
	{
		this.flottenstaerke = flottenstaerke;
	}

	public long getRohstoffbesitz()
	{
		return rohstoffbesitz;
	}

	public void setRohstoffbesitz(long rohstoffbesitz)
	{
		this.rohstoffbesitz = rohstoffbesitz;
	}

	public long getForschungspunkte()
	{
		return forschungspunkte;
	}

	public void setForschungspunkte(long forschungspunkte)
	{
		this.forschungspunkte = forschungspunkte;
	}

	public long getReputation()
	{
		return reputation;
	}

	public void setReputation(long reputation)
	{
		this.reputation = reputation;
	}

	public int getNutzerId()
	{
		return nutzerId;
	}

	public void setNutzerId(int nutzerId)
	{
		this.nutzerId = nutzerId;
	}

	public long getKontostand()
	{
		return kontostand;
	}

	public void setKontostand(long kontostand)
	{
		this.kontostand = kontostand;
	}

	public long getHighscore()
	{
		return highscore;
	}

	public void setHighscore(long highscore)
	{
		this.highscore = highscore;
	}

}