package org.colony.data;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.colony.service.NutzerService;
import org.colony.service.SchiffsmodellService;

public class Kampf
{
	int id;
	int schlachtId;
	int anzahlAufgebot;
	int anzahlUeberlebend;
	int schiffsmodellId;
	int nutzerId;
	int tick;

	public Kampf(ResultSet rs) throws SQLException
	{
		id = rs.getInt("id");
		schlachtId = rs.getInt("schlachtId");
		anzahlAufgebot = rs.getInt("anzahlAufgebot");
		anzahlUeberlebend = rs.getInt("anzahlUeberlebend");
		schiffsmodellId = rs.getInt("schiffsmodellId");
		nutzerId = rs.getInt("nutzerId");
		tick = rs.getInt("tick");
	}
	
	public Nutzer getNutzer()
	{
		return NutzerService.getById(getNutzerId());
	}
	public Schiffsmodell getSchiffsmodell()
	{
		return SchiffsmodellService.getById(getSchiffsmodellId());
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public int getSchlachtId()
	{
		return schlachtId;
	}

	public void setSchlachtId(int schlachtId)
	{
		this.schlachtId = schlachtId;
	}

	public int getAnzahlUeberlebend()
	{
		return anzahlUeberlebend;
	}

	public void setAnzahlUeberlebend(int anzahlUeberlebend)
	{
		this.anzahlUeberlebend = anzahlUeberlebend;
	}

	public int getSchiffsmodellId()
	{
		return schiffsmodellId;
	}

	public void setSchiffsmodellId(int schiffsmodellId)
	{
		this.schiffsmodellId = schiffsmodellId;
	}

	public int getNutzerId()
	{
		return nutzerId;
	}

	public void setNutzerId(int nutzerId)
	{
		this.nutzerId = nutzerId;
	}

	public int getTick()
	{
		return tick;
	}

	public void setTick(int tick)
	{
		this.tick = tick;
	}

	public int getAnzahlAufgebot()
	{
		return anzahlAufgebot;
	}

	public void setAnzahlAufgebot(int anzahlAufgebot)
	{
		this.anzahlAufgebot = anzahlAufgebot;
	}
}