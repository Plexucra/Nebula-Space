package org.colony.service;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.http.HttpSession;

import org.colony.data.Nutzer;
import org.colony.data.Planet;
import org.colony.lib.Cache;
import org.colony.lib.DbEngine;
import org.colony.lib.Query;

public class NutzerService
{
	public static Nutzer getById(int id)
	{
		return Cache.get().getNutzer(id);
	}
	public static Nutzer getNutzerByKey(String key) throws Exception
	{
		for(Nutzer n :  Cache.get().getNutzer().values())
			if(key.equals(n.getKey()))
				return n;
		return null;
	}
	public static Nutzer getNutzer(HttpSession session)
	{
		return Cache.get().getNutzer((Integer)session.getAttribute("userId"));
	}

	synchronized public static String insertNutzer(Nutzer nutzer) throws Exception
	{
		Connection c = null;
		try
		{
			c = DbEngine.getConnection();
			PreparedStatement ps;
//			
//			int planetId = 0;
//			ps = c.prepareStatement("SELECT count(heimatPlanetId) as anzahlNutzer, heimatPlanetId FROM nutzer group by heimatPlanetId order by anzahlNutzer limit 1");
//			ResultSet rs = ps.executeQuery();
//			if(rs!=null && rs.next())
//			{
//				planetId = rs.getInt("heimatPlanetId");
//				rs.close();
//			}
//			ps.close();
			
			ps = c.prepareStatement("insert into nutzer (`key`,`alias`,heimatPlanetId) values (?,?,?)");
			ps.setString(1, nutzer.getKey());
			ps.setString(2, nutzer.getAlias());
			ps.setInt(3, nutzer.getHeimatPlanetId());
			ps.executeUpdate();
			ps.close();
			
			int nutzerId = Query.selectInt(".getLastInsertId", c);
			for(Planet p : Cache.get().getPlaneten().values())
				DbEngine.exec(c, "NutzerService.insertLager", nutzerId, p.getId());
			
			c.commit();
			Cache.get().loadNutzer(c);

			//Damit man stehts was zum anbauen hat..
//			if(GebaeudeService.getGebaeude( Cache.get().getPlanet(nutzer.getHeimatPlanetId()), 0, 0, c)==null)
//				GebaeudeService.insertGebaeude(getNutzerByKey(nutzer.getKey()), 0, 0, 1);
		}
		catch(Exception ex)
		{
			c.rollback();
			throw ex;
		}
		finally { c.close(); }
		return null;
	}
}