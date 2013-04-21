package org.colony.data;

import org.colony.lib.ContextListener;

public class Gebaeude
{
	Planet planet;
	int id;
	Modell modell;
//	int besitzerNutzerId;
	Nutzer besitzer;
	int alter;
	int einnahmen;
	int ausgaben;
	int auslastung;
	float effizienz;
	int grundstueckId;
	int grundstueckX;
	int grundstueckY;

	public int getWartungskostenanteil()
	{
		return ContextListener.getService().getWartungskostenanteil(this);
	}
	
	public int getArbeitskostenanteil()
	{
		return ContextListener.getService().getArbeitskostenanteil(this);
	}


	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public Modell getModell()
	{
		return modell;
	}

	public void setModell(Modell modell)
	{
		this.modell = modell;
	}

	public int getAlter()
	{
		return alter;
	}

	public void setAlter(int alter)
	{
		this.alter = alter;
	}

	public int getEinnahmen()
	{
		return einnahmen;
	}

	public void setEinnahmen(int einnahmen)
	{
		this.einnahmen = einnahmen;
	}

	public int getAusgaben()
	{
		return ausgaben;
	}

	public void setAusgaben(int ausgaben)
	{
		this.ausgaben = ausgaben;
	}

	public int getAuslastung()
	{
		return auslastung;
	}

	public void setAuslastung(int auslastung)
	{
		this.auslastung = auslastung;
	}

	public float getEffizienz()
	{
		return effizienz;
	}

	public void setEffizienz(float effizienz)
	{
		this.effizienz = effizienz;
	}

	public int getGrundstueckId()
	{
		return grundstueckId;
	}

	public void setGrundstueckId(int grundstueckId)
	{
		this.grundstueckId = grundstueckId;
	}

	public int getGrundstueckX()
	{
		return grundstueckX;
	}

	public void setGrundstueckX(int grundstueckX)
	{
		this.grundstueckX = grundstueckX;
	}

	public int getGrundstueckY()
	{
		return grundstueckY;
	}

	public void setGrundstueckY(int grundstueckY)
	{
		this.grundstueckY = grundstueckY;
	}

	public Nutzer getBesitzer()
	{
		return besitzer;
	}

	public void setBesitzer(Nutzer besitzer)
	{
		this.besitzer = besitzer;
	}

	public Planet getPlanet()
	{
		return planet;
	}

	public void setPlanet(Planet planet)
	{
		this.planet = planet;
	}
}