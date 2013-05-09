package org.colony.data;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Transaktion
{

	int id;
	int ress;
	float kurs;
	long volumen;
	int nutzerIdKaeufer;
	int nutzerIdVerkaeufer;
	int tick;
	int planetId;

	public Transaktion(ResultSet rs) throws SQLException
	{
		id = rs.getInt("id");
		ress = rs.getInt("ress");
		kurs = rs.getFloat("kurs");
		volumen = rs.getLong("volumen");
		nutzerIdKaeufer = rs.getInt("nutzerIdKaeufer");
		nutzerIdVerkaeufer = rs.getInt("nutzerIdVerkaeufer");
		tick = rs.getInt("tick");
		planetId = rs.getInt("planetId");
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public int getRess()
	{
		return ress;
	}

	public void setRess(int ress)
	{
		this.ress = ress;
	}

	public float getKurs()
	{
		return kurs;
	}

	public void setKurs(float kurs)
	{
		this.kurs = kurs;
	}

	public long getVolumen()
	{
		return volumen;
	}

	public void setVolumen(long volumen)
	{
		this.volumen = volumen;
	}

	public int getNutzerIdKaeufer()
	{
		return nutzerIdKaeufer;
	}

	public void setNutzerIdKaeufer(int nutzerIdKaeufer)
	{
		this.nutzerIdKaeufer = nutzerIdKaeufer;
	}

	public int getNutzerIdVerkaeufer()
	{
		return nutzerIdVerkaeufer;
	}

	public void setNutzerIdVerkaeufer(int nutzerIdVerkaeufer)
	{
		this.nutzerIdVerkaeufer = nutzerIdVerkaeufer;
	}

	public int getTick()
	{
		return tick;
	}

	public void setTick(int tick)
	{
		this.tick = tick;
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