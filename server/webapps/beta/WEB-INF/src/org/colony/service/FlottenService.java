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
import org.colony.lib.DbEngine;
import org.colony.lib.Query;

public class FlottenService
{
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
		PreparedStatement ps = c.prepareStatement("	SELECT   id,  besitzerNutzerId, zielX,  zielY, x, y, sprungAufladung from flotte where sprungAufladung = 0 and zielX is not null");
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
//		System.out.println("t1:" + ps.toString());
//		System.out.println("t2:" + results);
//		System.out.println("t3:" + results.size());
		return results;
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