package org.colony.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.colony.data.Gebaeude;
import org.colony.data.Nutzer;
import org.colony.data.Planet;
import org.colony.lib.Cache;
import org.colony.lib.DbEngine;

public class GebaeudeService
{
	
	public static void updateGebaeude(Connection c, List<Gebaeude> gebs) throws SQLException
	{
		for(Gebaeude g : gebs)
		{
			PreparedStatement ps = c.prepareStatement("update gebaeude set auslastung = ?, ausgaben = ?, einnahmen = ?, `effizienz` = ? where id = ?");
			ps.setInt(1, g.getAuslastung());
			ps.setInt(2, g.getAusgaben());
			ps.setInt(3, g.getEinnahmen());
			ps.setFloat(4, g.getEffizienz());
			ps.setInt(5, g.getId());
			ps.executeUpdate();
			ps.close();
		}
	}


	public static void destroyGebaeude(Nutzer nutzer, int x, int y) throws Exception
	{
		Connection c = DbEngine.getConnection();
		try
		{
			Gebaeude g = getGebaeude( nutzer.getHeimatPlanet(), x, y, c);
			if(g==null) throw new Exception("Das zu zerstörende Gebäude konnte nicht gefunden werden.");

			if(g.getBesitzer().getId()!=nutzer.getId())
				throw new Exception("Das zu löschende Gebäude ist nicht Ihr Eigentum.");
			
			PreparedStatement ps = c.prepareStatement("delete from gebaeude where id = ?");
			ps.setInt(1, g.getId());
			ps.executeUpdate();
			ps.close();
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
	
	
	public static Gebaeude getGebaeude(Planet p, int x, int y) throws SQLException
	{
		Connection c = DbEngine.getConnection();
		try
		{
			return getGebaeude(p, x, y, c);
		}
		finally { c.close(); }
	}
	public static Gebaeude getGebaeude(Planet p, int x, int y, Connection c) throws SQLException
	{
		Gebaeude results = null;
		PreparedStatement ps;
		ResultSet rs;
		// ----------------------------------------------------------------------------------------------------
		// ----------------------------------------- Gebäude -----------------------------------
		// ----------------------------------------------------------------------------------------------------
		StringBuffer sb = new StringBuffer(200);
		sb.append("	select gebaeude.id as id, `alter`, ausgaben, auslastung, gebaeude.besitzerNutzerId as besitzerNutzerId, ");
		sb.append("	effizienz, einnahmen, grundstueck.id as grundstueckId, ");
		sb.append("	grundstueck.x as grundstueckX, ");
		sb.append("	grundstueck.y as grundstueckY, ");
		sb.append("	grundstueck.planetId as planetId, ");
		sb.append("	gebaeude.modellId as modellId, ");
		sb.append("	grundstueck.planetId as planetId ");
		sb.append("	from gebaeude ");
		sb.append("	join modell on (modell.id = gebaeude.modellId) ");
		sb.append("	join grundstueck on (grundstueck.gebaeudeId = gebaeude.id) ");
		sb.append("	where grundstueck.x = ?");
		sb.append("	and grundstueck.y = ?");
		sb.append("	and planetId = ?");
		ps = c.prepareStatement(sb.toString());
		ps.setInt(1, x);
		ps.setInt(2, y);
		ps.setInt(3, p.getId());

		rs = ps.executeQuery();
		if(rs != null && rs.next())
		{
			Gebaeude g = new Gebaeude(rs);
			results = g;
		}
		if(rs!=null) rs.close();
		ps.close();
		return results;
	}
	
	public static List<Gebaeude> getGebaeude(Planet s) throws Exception
	{
		List<Gebaeude> results = new ArrayList<Gebaeude>();
		Connection c = DbEngine.getConnection();
		try
		{
			PreparedStatement ps;
			ResultSet rs;
			// ----------------------------------------------------------------------------------------------------
			// ----------------------------------------- Gebäude -----------------------------------
			// ----------------------------------------------------------------------------------------------------
			StringBuffer sb = new StringBuffer(200);
			sb.append("	select gebaeude.id as id, `alter`, ausgaben, auslastung, gebaeude.besitzerNutzerId as besitzerNutzerId, ");
			sb.append("	effizienz, einnahmen, grundstueck.id as grundstueckId, ");
			sb.append("	grundstueck.x as grundstueckX, ");
			sb.append("	grundstueck.y as grundstueckY, ");
			sb.append("	gebaeude.modellId as modellId, ");
			sb.append("	grundstueck.planetId as planetId ");
			sb.append("	from gebaeude ");
			sb.append("	join modell on (modell.id = gebaeude.modellId) ");
			sb.append("	join grundstueck on (grundstueck.gebaeudeId = gebaeude.id) ");
			sb.append("	where planetId = ?");
			ps = c.prepareStatement(sb.toString());
			
			ps.setInt(1, s.getId());
			rs = ps.executeQuery();
			while(rs != null && rs.next())
			{
				Gebaeude g = new Gebaeude(rs);
				results.add(g);
			}
			if(rs!=null) rs.close();
			ps.close();
		}
		finally { c.close(); }
		return results;
	}
	public static Gebaeude getGebaeude(int id) throws Exception
	{
		Gebaeude g=null;
		Connection c = DbEngine.getConnection();
		try
		{
			PreparedStatement ps;
			ResultSet rs;
			// ----------------------------------------------------------------------------------------------------
			// ----------------------------------------- Gebäude -----------------------------------
			// ----------------------------------------------------------------------------------------------------
			StringBuffer sb = new StringBuffer(200);
			sb.append("	select gebaeude.id as id, `alter`, ausgaben, auslastung, gebaeude.besitzerNutzerId as besitzerNutzerId, ");
			sb.append("	effizienz, einnahmen, grundstueck.id as grundstueckId, ");
			sb.append("	grundstueck.x as grundstueckX, ");
			sb.append("	grundstueck.y as grundstueckY, ");
			sb.append("	gebaeude.modellId as modellId, ");
			sb.append("	grundstueck.planetId as planetId ");
			sb.append("	from gebaeude ");
			sb.append("	join modell on (modell.id = gebaeude.modellId) ");
			sb.append("	join grundstueck on (grundstueck.gebaeudeId = gebaeude.id) ");
			sb.append("	where gebaeude.id = ?");
			
			ps = c.prepareStatement(sb.toString());
			ps.setInt(1, id);
			rs = ps.executeQuery();
			if (rs != null && rs.next())
			{
				g = new Gebaeude(rs);
				rs.close();
			}
			ps.close();
		}
		finally { c.close(); }
		return g;
	}
	
	
	
	
	
	synchronized public static void insertGebaeude(Nutzer nutzer, int x, int y, int modellId) throws Exception
	{
		Connection c = null;
		try
		{
			c = DbEngine.getConnection();
			Gebaeude g = getGebaeude(nutzer.getHeimatPlanet(), x,y,c);
			int kosten =  Cache.get().getModell(modellId).getBaukosten();
			if(g==null) kosten += nutzer.getBauplatzKosten();
			if(kosten > nutzer.getKontostand())
				throw new Exception("Nicht genug Geld für diese Investition");
			if(g!=null)
			{
				if(g.getBesitzer().getId()!=nutzer.getId())
					throw new Exception("Das neu zu bebauende Gebäude ist nicht Ihr Eigentum.");
				
				PreparedStatement ps = c.prepareStatement("update gebaeude set modellId=?, besitzerNutzerId=?, `alter`=? where id = ?");
				ps.setInt(1, modellId);
				ps.setInt(2, nutzer.getId());
				ps.setInt(3, -1 *  Cache.get().getModell(modellId).getBauzeit() );
				ps.setInt(4, g.getId());
				ps.executeUpdate();
				ps.close();
				
				ps = c.prepareStatement("update nutzer set kontostand=kontostand-? where id = ?");
				ps.setInt(1, kosten);
				ps.setInt(2, nutzer.getId());
				ps.executeUpdate();
				ps.close();
				
				c.commit();
				nutzer.setKontostand(nutzer.getKontostand()-kosten);
			}
			else
			{
				PreparedStatement ps = c.prepareStatement("INSERT INTO gebaeude (modellId, besitzerNutzerId, `alter`) VALUES (?, ?, ?)");
				ps.setInt(1, modellId);
				ps.setInt(2, nutzer.getId());
				ps.setInt(3, -1 *  Cache.get().getModell(modellId).getBauzeit() );
				ps.executeUpdate();
				ps.close();
	
				ps = c.prepareStatement("INSERT INTO grundstueck (gebaeudeId, planetId, x, y) VALUES (LAST_INSERT_ID(), ?, ?, ?)");
				ps.setInt(1, nutzer.getHeimatPlanetId());
				ps.setInt(2, x);
				ps.setInt(3, y);
				ps.executeUpdate();
				ps.close();
				
				ps = c.prepareStatement("update nutzer set kontostand=kontostand-? where id = ?");
				ps.setInt(1, kosten);
				ps.setInt(2, nutzer.getId());
				ps.executeUpdate();
				ps.close();
				
				c.commit();
				nutzer.setKontostand(nutzer.getKontostand()-kosten);
//				nutzer.setAnzahlGebaeude(nutzer.getAnzahlGebaeude()+1);
			}
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
	
	public static List<Gebaeude> getRelevanteGebaeude(Gebaeude forG) throws Exception
	{
		return getRelevanteGebaeude(forG.getPlanet());
	}
	public static List<Gebaeude> getRelevanteGebaeude(Planet s) throws Exception
	{
		List<Gebaeude> results = new ArrayList<Gebaeude>();
		Connection c = DbEngine.getConnection();
		try
		{
			
			PreparedStatement ps;
			ResultSet rs;
			// ----------------------------------------------------------------------------------------------------
			// ----------------------------------------- Gebäude -----------------------------------
			// ----------------------------------------------------------------------------------------------------
			StringBuffer sb = new StringBuffer(200);
			sb.append("	select gebaeude.id as id, `alter`, ausgaben, auslastung, gebaeude.besitzerNutzerId as besitzerNutzerId, ");
			sb.append("	effizienz, einnahmen, grundstueck.id as grundstueckId, ");
			sb.append("	grundstueck.x as grundstueckX, ");
			sb.append("	grundstueck.y as grundstueckY, ");
			sb.append("	gebaeude.modellId as modellId, ");
			sb.append("	grundstueck.planetId as planetId ");
			sb.append("	from gebaeude ");
			sb.append("	join modell on (modell.id = gebaeude.modellId) ");
			sb.append("	join grundstueck on (grundstueck.gebaeudeId = gebaeude.id) ");
			sb.append("	where `alter` >= 0 and grundstueck.planetId = ? ");
			ps = c.prepareStatement(sb.toString());
			ps.setInt(1, s.getId());

			rs = ps.executeQuery();
			while(rs != null && rs.next())
			{
				Gebaeude g = new Gebaeude(rs);
				results.add(g);
			}
			if(rs!=null) rs.close();
			ps.close();
		}
		finally { c.close(); }
		return results;	
	}
	public static List<Gebaeude> getNutzerGebaeude(Nutzer n) throws Exception
	{
		List<Gebaeude> results = new ArrayList<Gebaeude>();
		Connection c = DbEngine.getConnection();
		try
		{
			PreparedStatement ps;
			ResultSet rs;
			StringBuffer sb = new StringBuffer(200);
			sb.append("	select gebaeude.id as id, `alter`, ausgaben, auslastung, gebaeude.besitzerNutzerId as besitzerNutzerId, ");
			sb.append("	effizienz, einnahmen, grundstueck.id as grundstueckId, ");
			sb.append("	grundstueck.x as grundstueckX, ");
			sb.append("	grundstueck.y as grundstueckY, ");
			sb.append("	gebaeude.modellId as modellId, ");
			sb.append("	grundstueck.planetId as planetId ");
			sb.append("	from gebaeude ");
			sb.append("	join modell on (modell.id = gebaeude.modellId) ");
			sb.append("	join grundstueck on (grundstueck.gebaeudeId = gebaeude.id) ");
			sb.append("	where gebaeude.besitzerNutzerId = ? order by (cast(einnahmen AS SIGNED)-cast(ausgaben AS SIGNED)) ");
			ps = c.prepareStatement(sb.toString());
			ps.setInt(1, n.getId());

			rs = ps.executeQuery();
			while(rs != null && rs.next())
			{
				Gebaeude g = new Gebaeude(rs);
				results.add(g);
			}
			if(rs!=null) rs.close();
			ps.close();
		}
		finally { c.close(); }
		return results;	
	}

}