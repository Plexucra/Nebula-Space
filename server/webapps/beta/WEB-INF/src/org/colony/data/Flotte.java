package org.colony.data;

import org.colony.lib.ContextListener;

public class Flotte
{
	int id;
	int x;
	int y;
	int besitzerNutzerId;
	int zielX;
	int zielY;
	int sprungAufladung;
	public Nutzer getBesitzer()
	{
		return ContextListener.getService().getNutzer(getBesitzerNutzerId());
	}
	public int getId()
	{
		return id;
	}
	public void setId(int id)
	{
		this.id = id;
	}
	public int getX()
	{
		return x;
	}
	public void setX(int x)
	{
		this.x = x;
	}
	public int getY()
	{
		return y;
	}
	public void setY(int y)
	{
		this.y = y;
	}
	public int getBesitzerNutzerId()
	{
		return besitzerNutzerId;
	}
	public void setBesitzerNutzerId(int besitzerNutzerId)
	{
		this.besitzerNutzerId = besitzerNutzerId;
	}
	public int getZielX()
	{
		return zielX;
	}
	public void setZielX(int zielX)
	{
		this.zielX = zielX;
	}
	public int getZielY()
	{
		return zielY;
	}
	public void setZielY(int zielY)
	{
		this.zielY = zielY;
	}
	public int getSprungAufladung()
	{
		return sprungAufladung;
	}
	public void setSprungAufladung(int sprungAufladung)
	{
		this.sprungAufladung = sprungAufladung;
	}
	
}