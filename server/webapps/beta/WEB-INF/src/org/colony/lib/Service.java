package org.colony.lib;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.colony.data.Einfluss;
import org.colony.data.Flotte;
import org.colony.data.Gebaeude;
import org.colony.data.Geschwader;
import org.colony.data.Nutzer;
import org.colony.data.Planet;
import org.colony.data.Schiffsmodell;
import org.colony.service.FlottenService;
import org.colony.service.GebaeudeService;
import org.colony.service.HandelService;
import org.colony.service.SchlachtService;

public class Service
{

	public boolean debug = false;
	public Cache cache;

	synchronized public void updateTick() throws Exception
	{
		long lt = 0;
		if(debug) {System.out.println("updateTick1 milis: "+(System.currentTimeMillis()-lt)); lt=System.currentTimeMillis(); }
		Connection c=null;
		try
		{
			c = DbEngine.getConnection();
			c.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
			c.commit();
			Statement statement;
			//------------------------- Flotten bewegen --------------------------
			List<Flotte> sprungFlotten = FlottenService.getSprungFlotten(c);
			for(Flotte f: sprungFlotten)
			{
				f.setPosition(f.getSprungziel());
				if( f.getX()==f.getZielX() && f.getY()==f.getZielY())
				{
					f.setSprungAufladung(-1);
				}
				else
				{
//					Position sprungZiel = f.getSprungziel();
					int sprungzeit = 0;
					for(Geschwader g : FlottenService.getGeschwader(f, c))
					{
						if(g.getSchiffsmodell().getSprungzeit() > sprungzeit)
							sprungzeit=g.getSchiffsmodell().getSprungzeit();
					}
//					f.setSprungAufladung( (int) Math.round(sprungzeit * Math.hypot( f.getX()-sprungZiel.getX(), f.getY()-sprungZiel.getY() )  ));
					f.setSprungAufladung( (int) sprungzeit);
					f.setSprungzeit(f.getSprungAufladung());
				}
			}
			statement = c.createStatement();
			for(Flotte f: sprungFlotten)
			{
				StringBuffer sb = new StringBuffer("update flotte set sprungAufladung = ");
				sb.append(f.getSprungAufladung());
				sb.append(", x=");
				sb.append(f.getX());
				sb.append(", y=");
				sb.append(f.getY());
				sb.append(" where id=");
				sb.append(f.getId());
				statement.addBatch(sb.toString());
			}
		    statement.executeBatch();
		    statement.close();
		    SchlachtService.updateSchlachten(c);
		    c.commit();

			
		    DbEngine.exec(c, "update gebaeude set `alter` = `alter` + 1");
			//------------------------- Gebäude updaten --------------------------
			for(Planet p : getCache().getPlaneten().values())
			{
				List<Gebaeude> relGebs = GebaeudeService.getRelevanteGebaeude(p);
//				List<Gebaeude> planetGebs = getGebaeude(p);
				List<Gebaeude> changedPlanetGebs = new ArrayList<Gebaeude>(100);
				if(debug) {System.out.println("updateTick3 milis: "+(System.currentTimeMillis()-lt)); lt=System.currentTimeMillis(); }
				for(Gebaeude g : relGebs)
				{
					int t_ausgaben		= g.getAusgaben();
					int t_auslastung	= g.getAuslastung();
					int t_einnahmen		= g.getEinnahmen();
					float t_effizienz	= g.getEffizienz();
//					g.setAlter(g.getAlter()+1);
//					if(g.getAlter()<0)
//					{
//						g.setAusgaben(0);
//						g.setAuslastung(0);
//						g.setEffizienz(0);
//						g.setEinnahmen(0);
//					}
//					else
//					{
						g.setEffizienz(getEffizienz(g, relGebs));
						g.setAuslastung(getAuslastung(g));
						g.setEinnahmen(getEinnahmen(g));
						g.setAusgaben(getAusgaben(g));
//					}
					if(g.getModell().getTyp().getId() == 7 && g.getAuslastung()==g.getModell().getKapazitaet())
					{
						List<Flotte> hFlotten = FlottenService.getHeimatFlotten(g.getBesitzer(),c);
						Flotte f = null; 
						if(hFlotten!=null && hFlotten.size()>0) f = hFlotten.get(0);
						else f = insertHeimatflotte(c, g.getBesitzer());
						Schiffsmodell neuesSchiff = null;
						for(Schiffsmodell sm : getCache().getSchiffsmodelle().values())
							if(sm.getFabrikModellId() == g.getModell().getId())
								neuesSchiff = sm;
						FlottenService.insertFlottenschiff(c, f,neuesSchiff);
					}
					
					if(
							t_ausgaben		!= g.getAusgaben() ||
							t_auslastung	!= g.getAuslastung() ||
							t_einnahmen		!= g.getEinnahmen() ||
							t_effizienz		!= g.getEffizienz())
						changedPlanetGebs.add(g);

				}
				if(debug) {System.out.println("updateTick4 milis: "+(System.currentTimeMillis()-lt)); lt=System.currentTimeMillis(); }
				GebaeudeService.updateGebaeude(c, changedPlanetGebs);
				c.commit();
			}
			//------------------------- Globale updates --------------------------
			statement = c.createStatement();
			statement.addBatch("update flotte set sprungAufladung = sprungAufladung - 1 where sprungAufladung >= 0;");
			statement.addBatch("update nutzer set einnahmen = COALESCE((SELECT sum(gebaeude.einnahmen)-sum(gebaeude.ausgaben)+50 FROM gebaeude where besitzerNutzerId = nutzer.id),0 )");
			statement.addBatch("update nutzer set kontostand = kontostand+einnahmen");
			statement.executeBatch();
			statement.close();
			c.commit();
			HandelService.mergeOrdersToTransaktionen(c);
			getCache().loadNutzer(c);
			c.commit();
		}
		catch(Exception ex)
		{
			c.rollback();
			throw ex;
		}
		finally
		{
			c.close();
		}
		if(debug) {System.out.println("updateTick5 milis: "+(System.currentTimeMillis()-lt)); lt=System.currentTimeMillis(); }
	}
	
	
	public int getAuslastung(Gebaeude g)
	{
		int result = 0;
		
		if(g.getModell().getTyp().getId()==3)
		{
	//		g.setAuslastung(	Math.round(((float)g.getModell().getKapazitaet())*mietAuslastung));
			//bei Gebäuden drückt sich zu und abwanderung in auslastung nieder
			int zuwachs =  Math.round( 10f*g.getEffizienz() )-5;
			result = g.getAuslastung()+zuwachs;
			if(result > g.getModell().getKapazitaet()) result = g.getModell().getKapazitaet() ;
			if(result < 0) result = 0;
	//		g.setEinnahmen(		Math.round((float)g.getAuslastung()*g.getEffizienz() ));
		}
		else if(g.getModell().getTyp().getId()==2)
		{
			result = 	Math.round(((float)g.getModell().getKapazitaet())*g.getEffizienz());
	//		g.setEinnahmen(		g.getAuslastung());
		}
		else if(g.getModell().getTyp().getId()==7)
		{
			if(g.getAuslastung()>g.getModell().getKapazitaet()) result = 0;
			else result = g.getAuslastung()+1;
		}
		else
		{
			result = g.getModell().getKapazitaet();
		}
		return result;
	}
	
	
	
	public int getAusgaben(Gebaeude g)
	{
		int result = 0;
		result+=		getWartungskostenanteil(g);
		result+=		getArbeitskostenanteil(g);
		return result;
	}

	public int getEinnahmen(Gebaeude g)
	{
		if(g.getModell().getTyp().getId()==3)
		{
			return Math.round((float)g.getAuslastung()*g.getEffizienz()/5 );
		}
		else if(g.getModell().getTyp().getId()==2)
		{
			return g.getAuslastung()*4;
		}
		return 0;
	}
	
	public int getWartungskostenanteil(Gebaeude g)
	{
		if(g.getModell().getProdukt()!=null)
			return Math.round(((float)g.getModell().getKapazitaet())*0.2f);
		else
			return Math.round(((float)g.getModell().getKapazitaet())*0.1f);
	}
	
	public int getArbeitskostenanteil(Gebaeude g)
	{
		if(g.getModell().getProdukt()!=null || g.getModell().getTyp().getId()==5)
			return Math.round(((float)g.getModell().getKapazitaet())*2f);
		if( g.getModell().getTyp().getId()==6)
			return Math.round(((float)g.getModell().getKapazitaet())*0.1f);
		else return 0;
	}

//	
//	public void updatePlanetBewohner(Connection c, Planet s, int wohnraum) throws SQLException
//	{
//		float planetGeburtenrate = 1.1f;
//		int planetBewohner = Math.round(s.getBewohner()*planetGeburtenrate);
//		if(planetBewohner > wohnraum)
//		{
//			if(planetBewohner>100)
//				planetBewohner = wohnraum;
//			else
//				planetBewohner = s.getBewohner();
//		}
//		PreparedStatement planetPs = c.prepareStatement("update planet set bewohner = ? where id = ?");
//		planetPs.setInt(1, planetBewohner);
//		planetPs.setInt(2, s.getId());
//		planetPs.executeUpdate();
//		planetPs.close();
//		s.setBewohner(planetBewohner);
//	}


	public Service() throws Exception
	{
		setCache(new Cache());
	}

	public List<Einfluss> getEinfluesse(Gebaeude g, List<Gebaeude> relevanteGebs) throws Exception
	{
//		boolean fired=false;
		List<Einfluss> results = new ArrayList<Einfluss>();
		for(Einfluss f : getCache().getEinfluesse())
		{
			if(g.getModell().getProdukt()!=null && f.getaObjektart()==2 && f.getaId()==g.getModell().getProdukt().getId())
				results.add(f.clone());
			if(f.getaObjektart()==1 && f.getaId()==g.getModell().getTyp().getId())
				results.add(f.clone());
		}
		List<Gebaeude> gebs = relevanteGebs!=null ? relevanteGebs : GebaeudeService.getRelevanteGebaeude(g);
		boolean selbstEinflussWurdeBerechnet = false;
		float selbstEinfluss = 0;
		
		for(Einfluss f : results)
		{
			float tEinfluss = 0;
			for(Gebaeude t_g : gebs)
			{
				if(t_g.getId()!=g.getId())
				{
					if((f.getbTyp()!=null && t_g.getModell().getTyp().getId()==f.getbTyp().getId()) || (f.getbProdukt()!=null && t_g.getModell().getProdukt()!=null && t_g.getModell().getProdukt().getId()==f.getbProdukt().getId()))
					{
						float abstand = (float)Math.hypot(t_g.getGrundstueckX()-g.getGrundstueckX(), t_g.getGrundstueckY()-g.getGrundstueckY());
						if(abstand <= f.getRadius())
						{
							if(f.isDurchAuslastung())
							{
								tEinfluss +=  (1f-(abstand/(float)f.getRadius())) * (f.getEinfluss()) * (((float)t_g.getAuslastung())/((float)g.getModell().getKapazitaet()))   ;
//								if(!fired)
//								{
//									fired=true;
//									System.out.print("\n 1:"+(1f-(abstand/(float)getEinflussRadius()))   );
//									System.out.print("\t 2:"+((float)f.getEinfluss())   );
//									System.out.print("\t 3:"+(((float)t_g.getAuslastung())/((float)g.getModell().getKapazitaet()))   );
//									System.out.print("\t 4:"+(((float)t_g.getAuslastung()))   );
//									System.out.print("\t 5:"+((float)g.getModell().getKapazitaet())   );
//								}
							}
							else
								tEinfluss += (1f-(abstand/(float)f.getRadius()))*f.getEinfluss();
						}
					}
					
					if(!selbstEinflussWurdeBerechnet && t_g.getModell().getTyp() == g.getModell().getTyp())
					{
						//vorerst werden nur Betriebe durch sich selbst geschwächt 
						if(g.getModell().getTyp().getId()==2 && g.getModell().getProdukt()==t_g.getModell().getProdukt())
						{
							float abstand = (float)Math.hypot(t_g.getGrundstueckX()-g.getGrundstueckX(), t_g.getGrundstueckY()-g.getGrundstueckY());
							//abstand der relevant ist auf fix 7 gesetzt!
							if(abstand <= 7f)
							{
								selbstEinfluss +=  (-10f) * (1f-(abstand/7f)) * Math.sqrt( (((float)t_g.getModell().getKapazitaet())/((float)g.getModell().getKapazitaet())) );
//								if(g.getId() == 154 || g.getId() == 153)
//								{
//									System.out.println(g.getId()+" < :"	+	g.getId() + " <-> " + t_g.getId()	);
//									System.out.println(g.getId()+" < dss1:"+(((float)g.getModell().getKapazitaet())));
//									System.out.println(g.getId()+" < dss2:"+(((float)t_g.getModell().getKapazitaet())));
//									System.out.println(g.getId()+" < ds:"+(((float)t_g.getModell().getKapazitaet())/((float)g.getModell().getKapazitaet())));
//									System.out.println(g.getId()+" < ds2:"+ ( (-10f) * (1f-(abstand/7f)) *  (((float)t_g.getModell().getKapazitaet())/((float)g.getModell().getKapazitaet())))   );
//								}
							}
						}
					}
				}
			}
			selbstEinflussWurdeBerechnet = true;
			if(tEinfluss > f.getMaxEinfluss()) tEinfluss=f.getMaxEinfluss();
			if(tEinfluss < f.getMinEinfluss()) tEinfluss=f.getMinEinfluss();
			f.setCurrentEinfluss(tEinfluss);
		}
		if( selbstEinfluss != 0 )
		{
			Einfluss tf = new Einfluss();
			tf.setCurrentEinfluss(selbstEinfluss);
			tf.setbBezeichnung("Konkurenz / Marktsättigung");
			results.add(tf);
		}
		return results;
	}

	synchronized public Flotte insertHeimatflotte(Connection c, Nutzer n) throws Exception
	{
		Flotte result = null;
		PreparedStatement ps = c.prepareStatement("insert into flotte (besitzerNutzerId,zielX,zielY,x,y,sprungAufladung) values (?,?,?,?,?,-1)");
		ps.setInt(1, n.getId());
		ps.setInt(2, n.getHeimatPlanet().getX());
		ps.setInt(3, n.getHeimatPlanet().getY());
		ps.setInt(4, n.getHeimatPlanet().getX());
		ps.setInt(5, n.getHeimatPlanet().getY());
		ps.executeUpdate();
		ps.close();
		
		ResultSet rs = c.prepareStatement("select * from flotte where id = LAST_INSERT_ID()").executeQuery();
		if(rs!=null && rs.next())
		{
			result = new Flotte(rs);
			rs.close();
		}
		return result;
	}


	public float getEffizienz(Gebaeude g, List<Gebaeude> relevanteGebs) throws Exception
	{
		return getEffizienz(getEinfluesse(g, relevanteGebs));
	}
	public float getEffizienz(List<Einfluss> ein)
	{
		int tEinfluss = 0;
		for(Einfluss f : ein)
			tEinfluss+=f.getCurrentEinfluss();
		float result = (float)tEinfluss/100f;
		if(result<getMinimalEffizienz()) result=getMinimalEffizienz();
		return result;
	}

	private float getMinimalEffizienz()
	{
		// TODO wert aus db lesn
		return 0.0f;
	}
	public int getSektorGroesse()
	{
		//TODO: wert aus db lesn
		return 30;
	}




	public Cache getCache()
	{
		return cache;
	}


	public void setCache(Cache cache)
	{
		this.cache = cache;
	}
}