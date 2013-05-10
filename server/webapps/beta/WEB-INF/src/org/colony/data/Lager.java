package org.colony.data;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Lager
{
	int id;
	int planetId;
	int nutzerId;
	long ress1;
	long ress2;
	long ress3;
	long ress4;
	long ress5;

	public Lager(ResultSet rs) throws SQLException
	{
		id = rs.getInt("id");
		planetId = rs.getInt("planetId");
		nutzerId = rs.getInt("nutzerId");
		ress1 = rs.getLong("ress1");
		ress2 = rs.getLong("ress2");
		ress3 = rs.getLong("ress3");
		ress4 = rs.getLong("ress4");
		ress5 = rs.getLong("ress5");
	}
	public long getRess(int i)
	{
		if(i==1) return getRess1();
		if(i==2) return getRess2();
		if(i==3) return getRess3();
		if(i==4) return getRess4();
		if(i==5) return getRess5();
		return 0;
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public int getPlanetId()
	{
		return planetId;
	}

	public void setPlanetId(int planetId)
	{
		this.planetId = planetId;
	}

	public int getNutzerId()
	{
		return nutzerId;
	}

	public void setNutzerId(int nutzerId)
	{
		this.nutzerId = nutzerId;
	}

	public long getRess1()
	{
		return ress1;
	}

	public void setRess1(long ress1)
	{
		this.ress1 = ress1;
	}

	public long getRess2()
	{
		return ress2;
	}

	public void setRess2(long ress2)
	{
		this.ress2 = ress2;
	}

	public long getRess3()
	{
		return ress3;
	}

	public void setRess3(long ress3)
	{
		this.ress3 = ress3;
	}

	public long getRess4()
	{
		return ress4;
	}

	public void setRess4(long ress4)
	{
		this.ress4 = ress4;
	}

	public long getRess5()
	{
		return ress5;
	}

	public void setRess5(long ress5)
	{
		this.ress5 = ress5;
	}

}