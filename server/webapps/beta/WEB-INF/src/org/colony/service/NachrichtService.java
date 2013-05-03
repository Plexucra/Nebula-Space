package org.colony.service;

import java.sql.Connection;
import java.sql.PreparedStatement;

import org.colony.data.Nutzer;
import org.colony.lib.Sql;

public class NachrichtService
{
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
}