package org.colony.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.colony.data.Flotte;
import org.colony.data.Geschwader;
import org.colony.data.Schlacht;
import org.colony.lib.ContextListener;
import org.colony.lib.DbEngine;
import org.colony.lib.Query;
import org.colony.lib.S;

public class SchlachtService
{
	public static final String cm = "SchlachtService.";
	public static List<Geschwader> getUeberlebende(int kampftick, List<Geschwader> angreifer, List<Geschwader> verteidiger)
	{
		// schadensbonus *= 1+( Math.random()/4 );
		List<Geschwader> results = new ArrayList<Geschwader>();
		double verteidigerMasse = 0;
		for (Geschwader tg : verteidiger)
			verteidigerMasse += tg.getAnzahl() * tg.getSchiffsmodell().getMasse();

		for (Geschwader vg : verteidiger)
		{
			double multi = ((double) (vg.getMasse())) / verteidigerMasse;
			double angriffswert = 0;
			for (Geschwader ag : angreifer)
				angriffswert += ag.getMasse() * ag.getSchiffsmodell().getAngriffsbonus(vg.getSchiffsmodell());
			angriffswert *= 0.5f + (kampftick / 20d);
			angriffswert *= multi;

			long verluste = Math.round(angriffswert / vg.getSchiffsmodell().getMasse());

			if (verluste < vg.getAnzahl())
			{
				Geschwader r = vg.clone();
				r.setAnzahl(vg.getAnzahl() - ((int) verluste));
				results.add(r);
			}
		}
		return results;
	}
	
	public static void updateSchlachten(Connection c)
	{
		
		try
		{
			Query q = new Query(S.concat(cm,"getNeueKonfliktpositionen"), c);
			while(q.nextResult())
			{
				Schlacht s = new Schlacht(q.getResult(), ContextListener.getTicker().getTick(), -1);
				DbEngine.exec(c, S.concat(cm,"insertSchlacht"), s.getAnfangTick(),s.getX(),s.getY(),s.getEndeTick());
				Query q1 = new Query(".getLastInsertId");
				if(q1.nextResult()) s.setId(q1.getResult().getInt("id"));
				q1.close();
				
				List<Integer> nutzerIds = new ArrayList<Integer>();
				for(Flotte f : FlottenService.getFlotten(s.getX(), s.getY(), c))
					if(!nutzerIds.contains(f.getBesitzerNutzerId()))
						NachrichtService.sendSystemNachricht(c, f.getBesitzer(), NachrichtService.TYP_SCHLACHT, "<span data_typ='"+NachrichtService.TYP_SCHLACHT+"' data_y='"+s.getY()+"' data_x='"+s.getX()+"' data_schlachtId='"+s.getId()+"'>Bei Position "+s.getX()+":"+s.getY()+" hat eine Schlacht begonnen an der ihre Flotten beteiligt sind.</span>");
			}
			q.close(c);
			
			q = new Query(S.concat(cm,"getOffeneSchlachten"), c);
			while(q.nextResult())
				updateSchlacht(c, new Schlacht(q.getResult()));
			q.close(c);
			
			DbEngine.exec(c, S.concat(cm,"deleteEmptyGeschwader"));
			FlottenService.destroyEmptyFlotten(c);
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
	}
	public static void updateSchlacht(Connection c, Schlacht schlacht)
	{
		System.out.println("updateSchlacht"+schlacht.getId());
		try
		{
			List<Flotte> flotten = FlottenService.getFlotten(schlacht.getX(), schlacht.getY(), c);
			Map<Integer, List<Geschwader>> sf = new HashMap<Integer, List<Geschwader>>();

			for (Flotte f : flotten)
			{
				int id = f.getBesitzer().getHeimatPlanetId();
				if (sf.get(id) == null)
					sf.put(id, new ArrayList<Geschwader>());
				for (Geschwader g : S.s().getGeschwader(f))
				{
					g.setNutzerId(f.getBesitzerNutzerId());
					sf.get(id).add(g);
				}
			}
			if (sf.keySet().size() >= 2)
			{
				Integer[] pids = sf.keySet().toArray(new Integer[] {});
				insertKampftick(c, schlacht, sf.get(pids[0]), sf.get(pids[1]));
			}
			else
			{
				DbEngine.exec(c, "SchlachtService.closeSchlacht", ContextListener.getTicker().getTick(), schlacht.getId());
			}
		} catch (SQLException ex)
		{
			ex.printStackTrace();
		}
	}

	public static void insertKampftick(Connection c, Schlacht schlacht, List<Geschwader> armeeAufgebot1, List<Geschwader> armeeAufgebot2)
	{
		try
		{
			List<Geschwader> armeeUeberlebend1 = getUeberlebende(schlacht.getKampftick(), armeeAufgebot2, armeeAufgebot1);
			List<Geschwader> armeeUeberlebend2 = getUeberlebende(schlacht.getKampftick(), armeeAufgebot1, armeeAufgebot2);
			Map<Integer, Geschwader> armeeUeberlebend1_map = new HashMap<Integer, Geschwader>();
			Map<Integer, Geschwader> armeeUeberlebend2_map = new HashMap<Integer, Geschwader>();
			for (Geschwader g : armeeUeberlebend1)
				armeeUeberlebend1_map.put(g.getId(), g);
			for (Geschwader g : armeeUeberlebend2)
				armeeUeberlebend2_map.put(g.getId(), g);

			Statement statement = c.createStatement();
			for (Geschwader g : armeeAufgebot1)
			{
				int ueberlebend = 0;
				if (armeeUeberlebend1_map.get(g.getId()) != null)
					ueberlebend = armeeUeberlebend1_map.get(g.getId()).getAnzahl();

				statement.addBatch("insert into kampf (schlachtId, anzahlAufgebot, anzahlUeberlebend, schiffsmodellId, nutzerId, tick) " + "values (" + "'" + schlacht.getId() + "'," + "'" + g.getAnzahl() + "'," + "'" + ueberlebend + "'," + "'" + g.getSchiffsmodellId() + "'," + "'" + g.getNutzerId() + "',"+S.getTick()+")");
				statement.addBatch("update geschwader set anzahl = " + ueberlebend + " where id = " + g.getId());
			}
			for (Geschwader g : armeeAufgebot2)
			{
				int ueberlebend = 0;
				if (armeeUeberlebend2_map.get(g.getId()) != null)
					ueberlebend = armeeUeberlebend2_map.get(g.getId()).getAnzahl();

				statement.addBatch("insert into kampf (schlachtId, anzahlAufgebot, anzahlUeberlebend, schiffsmodellId, nutzerId, tick) " + "values (" + "'" + schlacht.getId() + "'," + "'" + g.getAnzahl() + "'," + "'" + ueberlebend + "'," + "'" + g.getSchiffsmodellId() + "'," + "'" + g.getNutzerId() + "',"+S.getTick()+")");
				statement.addBatch("update geschwader set anzahl = " + ueberlebend + " where id = " + g.getId());
			}
			statement.executeBatch();
			statement.close();
		} catch (SQLException ex)
		{
			ex.printStackTrace();
		}
	}
}