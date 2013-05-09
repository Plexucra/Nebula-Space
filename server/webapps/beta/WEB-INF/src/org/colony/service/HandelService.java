package org.colony.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


import org.colony.data.Nutzer;
import org.colony.data.Order;
import org.colony.data.Planet;
import org.colony.data.Transaktion;
import org.colony.lib.Cache;
import org.colony.lib.DbEngine;
import org.colony.lib.Query;
import org.colony.lib.S;

public class HandelService
{
	public static final String ress1Name = "Alkalimetalle";
	public static final String ress2Name = "Edelmetalle";
	public static final String ress3Name = "Seltenerdmetalle";
	public static final String ress4Name = "Tetrele";
	public static final String ress5Name = "Elerium";
	
	public static String getRessName(int i)
	{
		if(i==1) return ress1Name;
		if(i==2) return ress2Name;
		if(i==3) return ress3Name;
		if(i==4) return ress4Name;
		if(i==5) return ress5Name;
		return "";
	}
	synchronized public static void mergeOrdersToTransaktionen(Connection c) throws SQLException
	{
		c.commit();
		for(int n=0; n<5000; n++)
		{
			boolean found = false;
			for(Planet p : Cache.get().getPlaneten().values())
			{
				for(int i=1; i<=5; i++)
				{
					Order kauforder = getBesteKauforder(i, p.getId(), c);
					Order verkauforder = getBesteVerkauforder(i, p.getId(), c);
					if( kauforder!=null && verkauforder!=null && kauforder.getKurs() >= verkauforder.getKurs() )
					{
						try
						{
							found = true;
							float kurs = (kauforder.getKurs()+verkauforder.getKurs())/2;
							int volumen = kauforder.getVolumen();
							if(verkauforder.getVolumen()<volumen) volumen=verkauforder.getVolumen();
							PreparedStatement ps = c.prepareStatement("insert into transaktion (ress, kurs, volumen, nutzerIdKaeufer, nutzerIdVerkaeufer, tick, planetId) values (?,?,?,?,?,?,?) ");
							ps.setInt(1, i);
							ps.setFloat(2, kurs);
							ps.setInt(3, volumen);
							ps.setInt(4, kauforder.getNutzerId());
							ps.setInt(5, verkauforder.getNutzerId());
							ps.setInt(6, S.getTick());
							ps.setInt(7, p.getId());
							ps.executeUpdate();
							
							DbEngine.exec(c, S.concat( "update lager set ress",String.valueOf(i),"=ress",String.valueOf(i),"+? where nutzerId = ? and planetId=?"), volumen, kauforder.getNutzerId(), p.getId());

							DbEngine.exec(c, "update `order` set volumen = volumen - ? where id = ?", volumen, kauforder.getId());
							DbEngine.exec(c, "update `order` set volumen = volumen - ? where id = ?", volumen, verkauforder.getId());
							int kosten = (int) Math.ceil( ((float)volumen) * kurs );
							DbEngine.exec(c, "update nutzer set kontostand = kontostand + ? where id = ?", kosten , verkauforder.getNutzerId());
							DbEngine.exec(c, "update nutzer set kontostand = kontostand - ? where id = ?", kosten , kauforder.getNutzerId());
							DbEngine.exec(c, "delete from `order` where volumen = 0");
							
							c.commit();
						}
						catch(SQLException ex)
						{
							c.rollback();
							throw ex;
						}
					}
				}
			}
			if(!found)
				break;
		}
		c.commit();
	}
	public static Order getBesteKauforder(int ress, int planetId)
	{
		Connection c = null;
		try
		{
			c = DbEngine.open();
			return getBesteKauforder(ress, planetId,c);
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally
		{
			DbEngine.close(c);
		}
		return null;
	}
	public static Order getBesteVerkauforder(int ress, int planetId)
	{
		Connection c = null;
		try
		{
			c = DbEngine.open();
			return getBesteVerkauforder(ress, planetId,c);
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally
		{
			DbEngine.close(c);
		}
		return null;
	}
	public static List<Order> getNutzerOrders(Nutzer nutzer)
	{
		Connection c = null;
		try
		{
			c = DbEngine.open();
			return getNutzerOrders(c, nutzer);
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally
		{
			DbEngine.close(c);
		}
		return null;
	}

	public static List<Transaktion> getLetzteTransaktionen(Nutzer nutzer)
	{
		Connection c = null;
		try
		{
			c = DbEngine.open();
			return getLetzteTransaktionen(nutzer,c);
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally
		{
			DbEngine.close(c);
		}
		return null;
	}

	public static List<Transaktion> getLetzteTransaktionen(int planetId)
	{
		Connection c = null;
		try
		{
			c = DbEngine.open();
			return getLetzteTransaktionen(planetId,c);
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally
		{
			DbEngine.close(c);
		}
		return null;
	}
	public static List<Order> getNutzerOrders(Connection c, Nutzer nutzer) throws SQLException
	{
		List<Order> results = new ArrayList<Order>();
		Query q = new Query("select * from `order` where nutzerId = ? order by kauf,planetId,kurs,volumen", c);
		q.addParameter(nutzer.getId());
		while(q.nextResult())
			results.add( new Order(q.getResult()));
		return results;
	}
	public static Order getBesteKauforder(int ress, int planetId, Connection c) throws SQLException
	{
		Query q = new Query("select * from `order` where kauf=1 and planetId = ? and ress = ? order by kurs desc limit 1", c);
		q.addParameter(planetId);
		q.addParameter(ress);
		if(q.nextResult())
			return new Order(q.getResult());
		return null;
	}
	public static Order getBesteVerkauforder(int ress, int planetId, Connection c) throws SQLException
	{
		Query q = new Query("select * from `order` where kauf=0 and planetId = ? and ress = ? order by kurs limit 1", c);
		q.addParameter(planetId);
		q.addParameter(ress);
		if(q.nextResult())
			return new Order(q.getResult());
		return null;
	}
	public static List<Transaktion> getLetzteTransaktionen(int planetId, Connection c) throws SQLException
	{
		List<Transaktion> results = new ArrayList<Transaktion>(5);
		Query q = new Query("SELECT * FROM (SELECT * FROM transaktion as t2 order by tick desc) as t1 where planetId = ? group by t1.planetId, t1.ress", c);
		q.addParameter(planetId);
		while(q.nextResult())
			results.add( new Transaktion(q.getResult()));
		return results;

		
	}
	public static List<Transaktion> getLetzteTransaktionen(Nutzer nutzer, Connection c) throws SQLException
	{
		List<Transaktion> results = new ArrayList<Transaktion>(5);
		Query q = new Query("SELECT * FROM transaktion where nutzerIdKaeufer = ? or nutzerIdVerkaeufer=? order by tick desc limit 100", c);
		q.addParameter(nutzer.getId());
		q.addParameter(nutzer.getId());
		while(q.nextResult())
			results.add( new Transaktion(q.getResult()));
		return results;

		
	}
	
	synchronized public static void insertStaatlicheOrders(Connection c) throws SQLException
	{
		for(Planet p : Cache.get().getPlaneten().values())
		{
			for(int ress=1; ress<=5; ress++)
			{
				Order o = getBesteKauforder(ress, p.getId(), c);
				float kurs = 1;
				if(o!=null) kurs = o.getKurs();
				// Wenn kein Bedarf besteht dann Order um 1% der normalen Förderung erhöhen.
				if(o!=null || DbEngine.exec(c, "update `order` set volumen=volumen+? where planetId = ? and ress=? and nutzerId = 0 limit 1",(int)Math.ceil((float)p.getRessVorkommen(ress)/100f), p.getId(), ress) == 0)
				{
					PreparedStatement ps = c.prepareStatement("insert into `order` (kauf,nutzerId,kurs,volumen,ress, planetId) values (?,?,?,?,?,?)");
					ps.setBoolean(1, false);
					ps.setInt(2, 0);
					ps.setFloat(3, kurs);
					ps.setInt(4, p.getRessVorkommen(ress));
					ps.setInt(5, ress);
					ps.setInt(6, p.getId());
					ps.executeUpdate();
				}
				c.commit();
			}
		}
		c.commit();
	}
	
	
	synchronized public static void deleteOrder(Nutzer nutzer, int orderId) throws Exception
	{
		Connection c = null;
		try
		{
			c = DbEngine.open();
			c.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
			c.commit();
			Query q = new Query("select * from `order` where id=? and nutzerId = ?",c);
			q.addParameter(orderId);
			q.addParameter(nutzer.getId());
			
			Order o = null;
			if(q.nextResult())
				o = new Order(q.getResult());
			if(o==null || DbEngine.exec(c, "delete from `order` where id=? and nutzerId = ?", orderId, nutzer.getId())==0)
				throw new Exception("Ihre Order konnte nicht mehr gefunden und daher auch nicht mehr gelöscht werden.");
			
			if(o.isKauf())
			{
				DbEngine.exec(c, "update nutzer set kontostand=kontostand+? where id = ?", o.getKosten(), nutzer.getId());
				Cache.get().getNutzer(nutzer.getId()).increaseKontostand(o.getKosten());
			}
			else
			{
				DbEngine.exec(c, S.concat( "update lager set ress",String.valueOf(o.getRess()),"=ress",String.valueOf(o.getRess()),"+? where nutzerId = ? and planetId=?"), o.getVolumen(), nutzer.getId(), o.getPlanetId());
			}
			c.commit();
		}
		catch(Exception ex)
		{
			c.rollback();
			throw ex;
		}
		finally
		{
			DbEngine.close(c);
		}
	}
	
	synchronized public static void insertOrder(Nutzer nutzer, boolean kauf, float kurs, int volumen, int ress, int planetId) throws Exception
	{
		Connection c = null;
		try
		{
			c = DbEngine.getConnection();

			if(kauf)
			{
				int kosten = (int) Math.ceil(kurs*((float)volumen));
				if(DbEngine.exec(c, "update nutzer set kontostand=kontostand-? where kontostand >= ? and id = ?", kosten,kosten,nutzer.getId())==0)
				{
					throw new Exception("Ihr Kontostand ist für diese Transaktion zu gering");
				}
				Cache.get().getNutzer(nutzer.getId()).decreaseKontostand(kosten);
			}
			else
			{
				if(DbEngine.exec(c, S.concat( "update lager set ress",String.valueOf(ress),"=ress",String.valueOf(ress),"-? where ress",String.valueOf(ress),">=? and nutzerId = ? and planetId=?"), volumen, volumen, nutzer.getId(), planetId) == 0)
					throw new Exception("Ihre Lager fässt nicht ausreichen der zu verkaufenden Rohstoffe.");
			}
			PreparedStatement ps = c.prepareStatement("insert into `order` (kauf,nutzerId,kurs,volumen,ress, planetId) values (?,?,?,?,?,?)");
			ps.setBoolean(1, kauf);
			ps.setInt(2, nutzer.getId());
			ps.setFloat(3, kurs);
			ps.setInt(4, volumen);
			ps.setInt(5, ress);
			ps.setInt(6, planetId);
			ps.executeUpdate();
			c.commit();
		}
		catch(Exception ex)
		{
			c.rollback();
			throw ex;
		}
		finally
		{
			if(c!=null) c.close();
		}
	}
}