package org.colony.lib;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class Ticker extends Thread
{
	int duration = 5000;
	long dtLastTick = 0;
	int tick = -1;
	Service service;
	public Ticker() throws Exception
	{
		service = new Service();
	}


//	List<Gebaeude> getSektorGebaeude(Connection c, Sektor s) throws SQLException
//	{
//		List<Gebaeude> list = new ArrayList<Gebaeude>();
//		PreparedStatement ps = c.prepareStatement("select * from v_grundstueck_detail where sektorId = ?");
//		ps.setInt(1, s.getId());
//		ResultSet rs = ps.executeQuery();
//		while(rs != null && rs.next())
//		{
//			Gebaeude g = new Gebaeude();
//			g.setSektor(s);
//			g.setId(rs.getInt("gebaeudeId"));
//			g.setModellId(rs.getInt("modellId"));
//			g.setBesitzerNutzerId(rs.getInt("besitzerNutzerId"));
//			g.setAlter(rs.getInt("alter"));
//			g.setEinnahmen(rs.getInt("einnahmen"));
//			g.setAusgaben(rs.getInt("ausgaben"));
//			g.setAuslastung(rs.getInt("auslastung"));
//			g.setKapazitaet(rs.getInt("kapazitaet"));
//			g.setEffizienz(rs.getInt("effizienz"));
//			g.setGrundstueckId(rs.getInt("id"));
//			g.setGrundstueckX(rs.getInt("x"));
//			g.setGrundstueckY(rs.getInt("y"));
//			g.setTypId(rs.getInt("typId"));
//			g.setTiefe(rs.getInt("tiefe"));
//			g.setBreite(rs.getInt("breite"));
//			g.setProduktId(rs.getInt("produktId"));
//			list.add(g);
//		}
//		if(rs!=null) rs.close();
//		ps.close();
//		return list;
//	}
	
//	List<Sektor> getSektoren(Connection c) throws SQLException
//	{
//		List<Sektor> list = new ArrayList<Sektor>();
//		PreparedStatement ps = c.prepareStatement("select * from sektor");
//		ResultSet rs = ps.executeQuery();
//		while(rs != null && rs.next())
//		{
//			Sektor s = new Sektor();
//			s.setBewohner(rs.getInt("bewohner"));
//			s.setId(rs.getInt("id"));
//			s.setPlanetId(rs.getInt("planetId"));
//			s.setX(rs.getInt("x"));
//			s.setY(rs.getInt("y"));
//			list.add(s);
//		}
//		if(rs!=null) rs.close();
//		ps.close();
//		return list;
//	}
	
	void tick() throws Exception
	{
		long tickStart = System.currentTimeMillis();
		getService().updateTick();
		if(getService().debug) System.out.println("tick (Dauer: "+(System.currentTimeMillis() -tickStart)+")" );
	}

	boolean shouldTick() throws Exception
	{
		if (tick == -1)
		{
			// init werte
			Connection c = DbEngine.getConnection();
			try
			{
				PreparedStatement ps = c.prepareStatement("select * from engine");
				ResultSet rs = ps.executeQuery();
				if (rs != null && rs.next())
				{
					duration = rs.getInt("tickDuration");
					dtLastTick = rs.getDate("dtLastTick").getTime();
					tick = rs.getInt("tick");
				}
			} finally
			{
				c.close();
			}
		}

		if (dtLastTick + duration < System.currentTimeMillis())
		{
			// Lass es ticken..
			Connection c = DbEngine.getConnection();
			try
			{
				tick++;
				dtLastTick = System.currentTimeMillis();
				PreparedStatement ps = c.prepareStatement("select `init` from engine");
				ResultSet rs = ps.executeQuery();
				if (rs != null && rs.next())
				{
					if(rs.getBoolean("init"))
						service = new Service();
					rs.close();
				}
				ps.close();
				ps = c.prepareStatement("update engine set dtLastTick=?,tick=?,`init`=false");
				ps.setDate(1, new Date(dtLastTick));
				ps.setInt(2, tick);
				ps.executeUpdate();
				c.commit();
			}
			finally
			{
				c.close();
			}
			return true;
		}
		return false;
	}

	@Override
	public void run()
	{

		while (isAlive() && !isInterrupted())
		{
			try
			{
				if (shouldTick())
					tick();
				sleep(1000);
			} catch (InterruptedException e)
			{
				interrupt();
				break;
			} catch (Exception e)
			{
				e.printStackTrace();
			}
		}
	}

	public void setDuration(int duration)
	{
		this.duration = duration;
	}

	public void setDtLastTick(long dtLastTick)
	{
		this.dtLastTick = dtLastTick;
	}

	public void setTick(int tick)
	{
		this.tick = tick;
	}
	public Service getService()
	{
		return service;
	}
	public void setService(Service service)
	{
		this.service = service;
	}
	public int getDuration()
	{
		return duration;
	}
	public long getDtLastTick()
	{
		return dtLastTick;
	}
	public int getTick()
	{
		return tick;
	}
}