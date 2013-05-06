package org.colony.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.colony.data.Allianz;
import org.colony.lib.Cache;
import org.colony.lib.Query;
import org.colony.lib.S;

public class AllianzService
{
	public static final String cm = "AllianzService.";
	public static Allianz getAllianz(int id)
	{
		return Cache.get().getAllianz(id);
	}
	public static List<Allianz> getAllianzen()
	{
		return getAllianzen(null);
	}
	public static List<Allianz> getAllianzen(Connection c)
	{
		List<Allianz> results = new ArrayList<Allianz>();
		Query q = new Query(S.concat(cm,"getAllianzen"), c);
		try
		{
			while (q.nextResult())
				results.add(new Allianz(q.getResult()));
		} catch (SQLException ex)
		{
			ex.printStackTrace();
		} finally
		{
			q.close(c);
		}
		return results;
	}
}