package org.colony.data;

import java.util.HashMap;
import java.util.Map;

public class Produkt
{
	int id;
	String bezeichnung;
	boolean endprodukt;
	Map<Integer,Produkt> benoetigtProdukte = new HashMap<Integer, Produkt>();

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

	public boolean isEndprodukt()
	{
		return endprodukt;
	}

	public void setEndprodukt(boolean endprodukt)
	{
		this.endprodukt = endprodukt;
	}

	public Map<Integer, Produkt> getBenoetigtProdukte()
	{
		return benoetigtProdukte;
	}

	public void setBenoetigtProdukte(Map<Integer, Produkt> benoetigtProdukte)
	{
		this.benoetigtProdukte = benoetigtProdukte;
	}
}