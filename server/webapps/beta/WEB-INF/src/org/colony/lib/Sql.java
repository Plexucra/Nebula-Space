package org.colony.lib;

import java.util.HashMap;
import java.util.Map;

public class Sql
{
	static Map<String,String> map = null;
	
	public static Map<String,String> getMap()
	{
		if(map==null)
		{
			map = new HashMap<String,String>();
			map.put("PlanetService.getPlaneten", "select * from planet");
			map.put("PlanetService.getAnzahlNutzer", "SELECT count(heimatPlanetId) as anzahlNutzer FROM nutzer where heimatPlanetId = ?");
			map.put("SchiffsmodellService.getBonusListe","select bSchiffsmodellId as schiffsmodellId, bonus from schiffsmodellbonus where aSchiffsmodellId = ?");
		}
		return map;
	}

	public static String get(String name)
	{
		return getMap().get(name);
	}
}