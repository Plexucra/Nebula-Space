package org.colony.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.colony.data.Schiffsmodell;
import org.colony.lib.Cache;
import org.colony.lib.Query;

public class SchiffsmodellService
{
	public static  Schiffsmodell getById(int id)
	{
		return Cache.get().getSchiffsmodell(id);
	}
	public static Map<Integer,Float> getBonusListe(Schiffsmodell m)
	{
		return getBonusListe(null, m);
	}
	public static Map<Integer,Float> getBonusListe(Connection c, Schiffsmodell m)
	{
		Map<Integer,Float> results = new HashMap<Integer,Float>();
		Query q = new Query("SchiffsmodellService.getBonusListe", c);
		try
		{
			q.addParameter(m.getId());
			while(q.nextResult())
				results.put( q.getResult().getInt("schiffsmodellId"), q.getResult().getFloat("bonus") );
		}
		catch (SQLException ex)
		{
			ex.printStackTrace();
		}
		finally
		{
			q.close(c);
		}
		return results;
	}
}