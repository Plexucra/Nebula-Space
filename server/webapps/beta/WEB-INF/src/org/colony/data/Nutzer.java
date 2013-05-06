package org.colony.data;

import org.colony.lib.Cache;

public class Nutzer
{
	int id;
	String alias;
	String key;
	long kontostand;
	int gewinn;
//	int anzahlGebaeude = 0;
	int heimatPlanetId;
	
	public int getAllianzId()
	{
		return getHeimatPlanet().getAllianzId();
	}
	
	public Allianz getAllianz()
	{
		return getHeimatPlanet().getAllianz();
	}

	public Planet getHeimatPlanet()
	{
		return Cache.get().getPlanet(getHeimatPlanetId());
	}
	
	public int getBauplatzKosten()
	{
		return 0; // anzahlGebaeude>20?((anzahlGebaeude-20)*3000):0;
	}
	
	public int getId()
	{
		return id;
	}
	public void setId(int id)
	{
		this.id = id;
	}
	public String getAlias()
	{
		return alias;
	}
	public void setAlias(String alias)
	{
		this.alias = alias;
	}
	public String getKey()
	{
		return key;
	}
	public void setKey(String key)
	{
		this.key = key;
	}
	public int getGewinn()
	{
		return gewinn;
	}
	public void setGewinn(int gewinn)
	{
		this.gewinn = gewinn;
	}
//	public int getAnzahlGebaeude()
//	{
//		return anzahlGebaeude;
//	}
//	public void setAnzahlGebaeude(int anzahlGebaeude)
//	{
//		this.anzahlGebaeude = anzahlGebaeude;
//	}

	public int getHeimatPlanetId()
	{
		return heimatPlanetId;
	}

	public void setHeimatPlanetId(int heimatPlanetId)
	{
		this.heimatPlanetId = heimatPlanetId;
	}

	public long getKontostand()
	{
		return kontostand;
	}

	public void setKontostand(long kontostand)
	{
		this.kontostand = kontostand;
	}
}