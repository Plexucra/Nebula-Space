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
			map.put(".getLastInsertId","select LAST_INSERT_ID() as id");
			map.put("PlanetService.getPlaneten", "select * from planet");
			map.put("PlanetService.getAnzahlNutzer", "SELECT count(heimatPlanetId) as anzahlNutzer FROM nutzer where heimatPlanetId = ?");
			map.put("SchiffsmodellService.getBonusListe","select bSchiffsmodellId as schiffsmodellId, bonus from schiffsmodellbonus where aSchiffsmodellId = ?");
			map.put("SchlachtService.getOffeneSchlachten", "select * from schlacht where endeTick < 0");
			map.put("SchlachtService.getNeueKonfliktpositionen", 
					"select flotte.x as x ,flotte.y as y, heimatPlanetId from flotte " +
					"join nutzer on (nutzer.id = flotte.besitzerNutzerId) " +
					"left outer join schlacht on (schlacht.x = flotte.x and schlacht.y = flotte.y and schlacht.endeTick < 0) " +
					"where schlacht.id is null  " +
					"group by flotte.x,flotte.y HAVING COUNT(DISTINCT heimatPlanetId) > 1");
			map.put("SchlachtService.closeSchlacht","update schlacht set endeTick=? where id = ?");
			map.put("SchlachtService.deleteEmptyGeschwader","delete from geschwader where anzahl < 1");
			map.put("SchlachtService.insertSchlacht", "insert into schlacht (anfangTick,x,y,endeTick) values (?,?,?,?)");
			map.put("SchlachtService.getKaempfe", "select * from kampf where schlachtId = ?");
			map.put("FlottenService.getEmptyFlotten","select * from flotte where flotte.id in (select f.id from flotte as f left outer join geschwader on (geschwader.flotteId = f.id) where geschwader.flotteId is null)");
			map.put("FlottenService.deleteFlotte","delete from flotte where id = ?");
			map.put("NachrichtService.getUngeleseneSystemNachrichten","select * from nachricht where nutzerIdSender = 0 and gelesen = 0 and nutzerIdEmpfaenger = ? order by datumGesendet desc");
			map.put("NachrichtService.sendNachricht","insert into nachricht (nutzerIdSender, nutzerIdEmpfaenger, typ, betreff, text, datumGesendet) values (?,?,?,?,?,NOW())");
			map.put("AllianzService.getAllianzen","select * from allianz");
			map.put("NutzerService.insertLager","insert into lager (nutzerId, planetId, ress1, ress2, ress3, ress4, ress5) values (?,?,0,0,0,0,0)");
		}
		return map;
	}

	public static String get(String name)
	{
		return getMap().get(name)==null?name:getMap().get(name);
	}
}