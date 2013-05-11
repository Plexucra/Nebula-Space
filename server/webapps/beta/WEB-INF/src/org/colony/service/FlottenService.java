package org.colony.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.colony.data.Flotte;
import org.colony.data.Geschwader;
import org.colony.data.Nutzer;
import org.colony.data.Schiffsmodell;
import org.colony.lib.Cache;
import org.colony.lib.DbEngine;
import org.colony.lib.Query;

public class FlottenService
{
	public static void transferFlottenlager(Nutzer nutzer, int planetId, int flotteId, int ress1LagerBelegung, int ress2LagerBelegung, int ress3LagerBelegung, int ress4LagerBelegung, int ress5LagerBelegung) throws Exception
	{
		Connection c = DbEngine.getConnection();
		try
		{
			transferFlottenlager(nutzer, planetId, flotteId, ress1LagerBelegung, ress2LagerBelegung, ress3LagerBelegung, ress4LagerBelegung, ress5LagerBelegung, c);
			c.commit();
		}
		catch(Exception ex)
		{
			c.rollback();
			throw ex;
		}
		finally { c.close(); }
	}
	
	public static void updateFlottenlagerKapazitaet(int flotteId, int neueKapazitaet, Connection c)
	{
		
	}
	
	public static void transferFlottenlager(Nutzer nutzer, int planetId, int flotteId, int ress1, int ress2, int ress3, int ress4, int ress5, Connection c) throws Exception
	{
		int[] neueFrachterLager = new int[] {ress1,ress2,ress3,ress4,ress5};
		if(Cache.get().getPlanet(planetId).getAllianzId() != nutzer.getAllianzId())
			throw new Exception("Sie können mit diesen Planeten kein Handel betreiben.");
		
		Flotte flotte = getFlotte(flotteId, c);
		Geschwader geschwader = null;
		for(Geschwader g : getGeschwader(flotte, c))
			if(g.getSchiffsmodell().isFrachter())
				geschwader = g;
		if(geschwader == null)
			throw new Exception("Es konnten keine Frachter in der gewählten Flotte gefunden werden");
		if(geschwader.getFassungsvermoegen() < (ress1+ress2+ress3+ress4+ress5))
			throw new Exception("Die zu ladende Rohstoffmenge übersteigt die Lagerkapazität der Frachter.");
		for(int i : neueFrachterLager)
			if(i<0)
				throw new Exception("Die Rohstofflager können keinen negativen Wert aufnehmen.");
		
		int t_ress1 = ress1-flotte.getRess1();
		int t_ress2 = ress2-flotte.getRess2();
		int t_ress3 = ress3-flotte.getRess3();
		int t_ress4 = ress4-flotte.getRess4();
		int t_ress5 = ress5-flotte.getRess5();
		if( DbEngine.exec(c, "update lager set ress1=ress1-?, ress2=ress2-?, ress3=ress3-?, ress4=ress4-?, ress5=ress5-? where ress1-? >= 0 and ress2-? >= 0 and ress3-? >= 0 and ress4-? >= 0 and ress5-? >= 0 and nutzerId = ? and planetId = ?",
				t_ress1,t_ress2,t_ress3,t_ress4,t_ress5,t_ress1,t_ress2,t_ress3,t_ress4,t_ress5, nutzer.getId(), planetId) == 0)
			throw new Exception("Die Rohstoffbestände in den Lagern des Planeten sind zu gering für diesen Transfer.");
		
		if( DbEngine.exec(c, "update flotte set ress1=?, ress2=?, ress3=?, ress4=?, ress5=? where id = ?", ress1, ress2, ress3, ress4, ress5, flotteId) == 0 )
			throw new Exception("Die Flotte "+flotteId+" könnte be-/entladen werden");
	}
	/**
	 * Liefert alle Geschwader einer Flotten bzw. alle nach Schiffmodellen gruppierten Unterflotten einer Flotte.
	 */
	public static List<Geschwader> getGeschwader(Flotte f) throws SQLException
	{
		Connection c = DbEngine.getConnection();
		try
		{
			return getGeschwader(f, c);
		}
		finally { c.close(); }
	}
	
	/**
	 * Liefert alle Geschwader einer Flotten bzw. alle nach Schiffmodellen gruppierten Unterflotten einer Flotte.
	 */
	public static  List<Geschwader> getGeschwader(Flotte f, Connection c) throws SQLException
	{
		List<Geschwader> results = new ArrayList<Geschwader>();
		PreparedStatement ps = c.prepareStatement("	SELECT * from geschwader where flotteId = "+f.getId());
		ResultSet rs = ps.executeQuery(); 
		while(rs != null && rs.next()) results.add(new Geschwader(rs));
		if(rs!=null) rs.close();
		ps.close();
		return results;
	}

	/**
	 * Liefert die Flotten welche gerade im Begriff sind zu "springen".
	 */
	public static  List<Flotte> getSprungFlotten(Connection c) throws SQLException
	{
		List<Flotte> results = new ArrayList<Flotte>();
		PreparedStatement ps = c.prepareStatement("	SELECT * from flotte where sprungAufladung = 0 and zielX is not null");
		ResultSet rs = ps.executeQuery();
		while(rs != null && rs.next()) results.add(new Flotte(rs));
		if(rs!=null) rs.close();
		ps.close();
		return results;
	}

	synchronized public static void insertFlottenschiff(Connection c, Flotte f, Schiffsmodell sm) throws Exception
	{
		Geschwader zielGeschwader = null;
		for(Geschwader g : getGeschwader(f, c))
			if(g.getSchiffsmodellId() == sm.getId())
				zielGeschwader = g;
		
		if(zielGeschwader == null)
		{
			PreparedStatement ps = c.prepareStatement("insert into geschwader (`flotteId`,`schiffsmodellId`,anzahl) values (?,?,1)");
			ps.setInt(1, f.getId());
			ps.setInt(2, sm.getId());
			ps.executeUpdate();
			ps.close();
		}
		else
		{
			PreparedStatement ps = c.prepareStatement("update geschwader set anzahl = anzahl+1 where id = ?");
			ps.setInt(1, zielGeschwader.getId());
			ps.executeUpdate();
			ps.close();
		}
	}
	
	public static void destroyEmptyFlotten(Connection c)
	{
		try
		{
			Query q = new Query("FlottenService.getEmptyFlotten", c);
			while(q.nextResult())
			{
				Flotte f = new Flotte(q.getResult());
				DbEngine.exec(c, "FlottenService.deleteFlotte", f.getId());
				NachrichtService.sendSystemNachricht(c, f.getBesitzer(), NachrichtService.TYP_SCHLACHT, "<span data_typ='"+NachrichtService.TYP_SCHLACHT+"' data_x='"+f.getX()+"' data_y='"+f.getY()+"'>Eine deiner Flotten wurde bei "+f.getX()+":"+f.getY()+" zerstört.");
			}
		}
		catch(SQLException ex)
		{
			ex.printStackTrace();
		}
	}
	public static List<Flotte> getNutzerFrachterFlotten(int x, int y, Nutzer nutzer) throws Exception
	{
		Connection c = DbEngine.getConnection();
		try
		{
			return getNutzerFrachterFlotten(x, y, nutzer, c);
		} finally
		{
			c.close();
		}
	}
	public static List<Flotte> getFlotten(int x, int y) throws Exception
	{
		Connection c = DbEngine.getConnection();
		try
		{
			return getFlotten(x, y, c);
		} finally
		{
			c.close();
		}
	}

	public static List<Flotte> getFlotten(List<Integer> ids, Nutzer nutzer) throws Exception
	{
		Connection c = DbEngine.getConnection();
		try
		{
			return getFlotten(ids, nutzer, c);
		} finally
		{
			c.close();
		}
	}

	public static List<Flotte> getHeimatFlotten(Nutzer nutzer, Connection c) throws Exception
	{
		List<Flotte> results = new ArrayList<Flotte>();
		PreparedStatement ps = c.prepareStatement("	SELECT * from flotte where besitzerNutzerId = ? and x = ? and y = ? ");
		ps.setInt(1, nutzer.getId());
		ps.setInt(2, nutzer.getHeimatPlanet().getX());
		ps.setInt(3, nutzer.getHeimatPlanet().getY());
		ResultSet rs = ps.executeQuery();
		while (rs != null && rs.next())
			results.add(new Flotte(rs));
		if (rs != null)
			rs.close();
		ps.close();
		return results;
	}

	public static List<Flotte> getFlotten(List<Integer> ids, Nutzer nutzer, Connection c) throws Exception
	{
		List<Flotte> results = new ArrayList<Flotte>();
		PreparedStatement ps = c.prepareStatement("	SELECT * from flotte where besitzerNutzerId = ? and id in (" + DbEngine.generateQsForIn(ids.size()) + ")");
		ps.setInt(1, nutzer.getId());
		for (int i = 0; i < ids.size(); i++)
			ps.setInt(2 + i, ids.get(i));
		ResultSet rs = ps.executeQuery();
		while (rs != null && rs.next())
			results.add(new Flotte(rs));
		if (rs != null)
			rs.close();
		ps.close();
		return results;
	}

	public static List<Flotte> getFlotten(Nutzer nutzer) throws Exception
	{
		Connection c = DbEngine.getConnection();
		try
		{
			return getFlotten(nutzer, c);
		} finally
		{
			c.close();
		}
	}

	public static List<Flotte> getFlotten(Nutzer nutzer, Connection c) throws Exception
	{
		List<Flotte> results = new ArrayList<Flotte>();
		PreparedStatement ps = c.prepareStatement("	SELECT * from flotte where besitzerNutzerId = ?");
		ps.setInt(1, nutzer.getId());
		ResultSet rs = ps.executeQuery();
		while (rs != null && rs.next())
			results.add(new Flotte(rs));
		if (rs != null)
			rs.close();
		ps.close();
		return results;
	}

	public static Flotte getFlotte(int flotteId, Connection c) throws Exception
	{
		Flotte result = null;
		Query q = new Query("select * from flotte where id = ?",c);
		q.addParameter(flotteId);
		if(q.nextResult())
			result = new Flotte(q.getResult());
		q.closeQuery();
		
		if(result == null)
			throw new Exception("Die angeforderte Flotte "+flotteId+" konnte nicht gefunden werden");
		return result;
	}

	public static void updateFlotten(List<Integer> ids, Nutzer nutzer, int zielX, int zielY) throws Exception
	{
		Connection c = DbEngine.getConnection();
		try
		{
			updateFlotten(ids, nutzer, zielX, zielY, c);
			c.commit();
		} finally
		{
			c.close();
		}
	}

	public static void updateFlotten(List<Integer> ids, Nutzer nutzer, int zielX, int zielY, Connection c) throws Exception
	{
		PreparedStatement ps = c.prepareStatement("update flotte set sprungAufladung=30, zielX = ?, zielY = ? where besitzerNutzerId = ? and id in (" + DbEngine.generateQsForIn(ids.size()) + ")");
		ps.setInt(1, zielX);
		ps.setInt(2, zielY);
		ps.setInt(3, nutzer.getId());
		for (int i = 0; i < ids.size(); i++)
			ps.setInt(4 + i, ids.get(i));
//		System.out.println(ps.toString() + "\n\n x:" + nutzer.getId());
		ps.executeUpdate();
		ps.close();
	}

	
	public static List<Flotte> getNutzerFrachterFlotten(int x, int y, Nutzer nutzer, Connection c) throws SQLException
	{
		List<Flotte> results = new ArrayList<Flotte>();
		PreparedStatement ps = c.prepareStatement("select * from flotte as fl join ( SELECT distinct(tf.id) as flotteId from flotte as tf join geschwader on (geschwader.flotteId = tf.id) join schiffsmodell on (schiffsmodell.id = geschwader.schiffsmodellId) where frachter = 1 and tf.x=? and tf.y=? and tf.besitzerNutzerId = ?) as t on (t.flotteId=fl.id)");
		ps.setInt(1, x);
		ps.setInt(2, y);
		ps.setInt(3, nutzer.getId());
		ResultSet rs = ps.executeQuery();
		while (rs != null && rs.next())
			results.add(new Flotte(rs));
		if (rs != null)
			rs.close();
		ps.close();
		return results;
	}
	public static List<Flotte> getFlotten(int x, int y, Connection c) throws SQLException
	{
		List<Flotte> results = new ArrayList<Flotte>();
		PreparedStatement ps = c.prepareStatement("	SELECT * from flotte where x = ? and y = ?");
		ps.setInt(1, x);
		ps.setInt(2, y);
		ResultSet rs = ps.executeQuery();
		while (rs != null && rs.next())
			results.add(new Flotte(rs));
		if (rs != null)
			rs.close();
		ps.close();
		return results;
	}

}