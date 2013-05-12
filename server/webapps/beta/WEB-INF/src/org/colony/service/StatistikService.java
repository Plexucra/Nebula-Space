package org.colony.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.colony.data.Nutzerhighscore;
import org.colony.lib.Query;
import org.colony.lib.S;

public class StatistikService
{
	public static final String cm = "StatistikService.";

	public static List<Nutzerhighscore> getNutzerhighscore()
	{
		List<Nutzerhighscore> results = new ArrayList<Nutzerhighscore>();
		Query q = new Query(S.concat(cm, "getNutzerhighscore"));
		try
		{
			while (q.nextResult())
				results.add(new Nutzerhighscore(q.getResult()));
		} catch (SQLException ex)
		{
			ex.printStackTrace();
		} finally
		{
			q.close();
		}
		return results;
	}
}