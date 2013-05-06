package org.colony.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.colony.data.Planet;
import org.colony.lib.Cache;
import org.colony.lib.Query;

public class PlanetService
{
	public static List<Planet> getPlaneten()
	{
		List<Planet> result = new ArrayList<Planet>();
		for(Planet p : Cache.get().getPlaneten().values())
			result.add(p);
		return result;
	}
	public static List<Planet> getPlaneten(Connection c)
	{
		List<Planet> results = new ArrayList<Planet>();
		Query q = new Query("PlanetService.getPlaneten", c);
		try
		{
			while (q.nextResult())
				results.add(new Planet(q.getResult()));
		} catch (SQLException ex)
		{
			ex.printStackTrace();
		} finally
		{
			q.close(c);
		}
		return results;
	}
	
	public static int getAnzahlNutzer(Planet p)
	{
		Query q = new Query("PlanetService.getAnzahlNutzer");
		try
		{
			q.addParameter(p.getId());
			if(q.nextResult())
				return q.getResult().getInt(1);
		} catch (SQLException ex)
		{
			ex.printStackTrace();
		} finally
		{
			q.close();
		}
		return 0;
	}
	
}