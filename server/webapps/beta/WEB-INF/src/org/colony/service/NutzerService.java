package org.colony.service;

import org.colony.data.Nutzer;
import org.colony.lib.S;

public class NutzerService
{
	public static Nutzer getById(int id)
	{
		return S.s().getNutzer(id);
	}
}