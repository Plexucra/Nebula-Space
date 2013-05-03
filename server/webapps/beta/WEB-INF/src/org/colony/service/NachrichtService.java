package org.colony.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.colony.data.Nachricht;
import org.colony.data.Nutzer;
import org.colony.lib.Query;
import org.colony.lib.S;
import org.colony.lib.Sql;

public class NachrichtService
{
	public static final String cm = "NachrichtService.";
	public static final int TYP_SCHLACHT = 3;
	public static final int TYP_NACHRICHT = 1;

	public static void sendNachricht(Connection c, Nutzer sender, Nutzer empfaenger, int typ, String betreff, String text)
	{
		try
		{
			if (sender == null)
			{
				sender = new Nutzer();
				sender.setId(0);
				sender.setAlias("System");
			}
			PreparedStatement ps = c.prepareStatement(Sql.get("NachrichtService.sendNachricht"));
			ps.setInt(1, sender.getId());
			ps.setInt(2, empfaenger.getId());
			ps.setInt(3, typ);
			ps.setString(4, betreff);
			ps.setString(5, text);
			ps.executeUpdate();
			ps.close();
		} catch (Exception ex)
		{
			ex.printStackTrace();
		}
	}

	public static void sendSystemNachricht(Connection c, Nutzer empfaenger, int typ, String text)
	{
		sendNachricht(c, null, empfaenger, typ, null, text);
	}

	public static List<Nachricht> getUngeleseneSystemNachrichten(int nutzerId)
	{
		List<Nachricht> results = new ArrayList<Nachricht>();
		Query q = new Query(S.concat(cm, "getUngeleseneSystemNachrichten"));
		try
		{
			q.addParameter(nutzerId);
			while (q.nextResult())
				results.add(new Nachricht(q.getResult()));
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