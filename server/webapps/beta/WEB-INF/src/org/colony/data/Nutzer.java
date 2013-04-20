package org.colony.data;

public class Nutzer
{
	int id;
	String alias;
	String key;
	int kontostand;
	int gewinn;
	int anzahlGebaeude = 0;
	int heimatplanetId;
	
	public int getBauplatzKosten()
	{
		return anzahlGebaeude*10000;
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
	public int getKontostand()
	{
		return kontostand;
	}
	public void setKontostand(int kontostand)
	{
		this.kontostand = kontostand;
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
	public int getAnzahlGebaeude()
	{
		return anzahlGebaeude;
	}
	public void setAnzahlGebaeude(int anzahlGebaeude)
	{
		this.anzahlGebaeude = anzahlGebaeude;
	}
}