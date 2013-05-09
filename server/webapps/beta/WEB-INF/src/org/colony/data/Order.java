package org.colony.data;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Order
{
	int id;
	boolean kauf;
	int nutzerId;
	float kurs;
	int volumen;
	int ress;
	int planetId;

	public Order(ResultSet rs) throws SQLException
	{
		id = rs.getInt("id");
		kauf = rs.getBoolean("kauf");
		nutzerId = rs.getInt("nutzerId");
		kurs = rs.getFloat("kurs");
		volumen = rs.getInt("volumen");
		ress = rs.getInt("ress");
		planetId = rs.getInt("planetId");
	}

	public int getKosten()
	{
		return (int) Math.ceil(getKurs() * (float) getVolumen());
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public boolean isKauf()
	{
		return kauf;
	}

	public void setKauf(boolean kauf)
	{
		this.kauf = kauf;
	}

	public int getNutzerId()
	{
		return nutzerId;
	}

	public void setNutzerId(int nutzerId)
	{
		this.nutzerId = nutzerId;
	}

	public float getKurs()
	{
		return kurs;
	}

	public void setKurs(float kurs)
	{
		this.kurs = kurs;
	}

	public int getVolumen()
	{
		return volumen;
	}

	public void setVolumen(int volumen)
	{
		this.volumen = volumen;
	}

	public int getRess()
	{
		return ress;
	}

	public void setRess(int ress)
	{
		this.ress = ress;
	}

	public int getPlanetId()
	{
		return planetId;
	}

	public void setPlanetId(int planetId)
	{
		this.planetId = planetId;
	}

}