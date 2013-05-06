package org.colony.service;

import org.colony.data.Nutzer;
import org.colony.lib.Cache;

public class NutzerService
{
	public static Nutzer getById(int id)
	{
		return Cache.get().getNutzer(id);
	}
}