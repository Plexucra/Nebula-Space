package org.colony.lib;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.colony.data.Einfluss;
import org.colony.data.Flotte;
import org.colony.data.Gebaeude;
import org.colony.data.Geschwader;
import org.colony.data.Modell;
import org.colony.data.Nutzer;
import org.colony.data.Planet;
import org.colony.data.Produkt;
import org.colony.data.Schiffsmodell;
import org.colony.data.Typ;

public class Service
{
	List<Einfluss> einfluesse = new ArrayList<Einfluss>();
	Map<Integer,Produkt> produkte = new HashMap<Integer, Produkt>();
	Map<Integer,Typ> typen = new HashMap<Integer, Typ>();
	Map<Integer,Modell> modelle = new HashMap<Integer, Modell>();
	List<Modell> modellListe = new ArrayList<Modell>();
	Map<Integer,Schiffsmodell> schiffsmodelle = new HashMap<Integer, Schiffsmodell>();
	Map<Integer,Planet> planeten = new HashMap<Integer, Planet>();
	private Map<Integer,Nutzer> nutzer = new HashMap<Integer, Nutzer>();
	public boolean debug = false;

	synchronized public void updateTick() throws Exception
	{
		long lt = 0;
		if(debug) {System.out.println("updateTick1 milis: "+(System.currentTimeMillis()-lt)); lt=System.currentTimeMillis(); }
		Connection c = DbEngine.getConnection();
		try
		{
			Statement statement;
			//------------------------- Flotten bewegen --------------------------
			List<Flotte> sprungFlotten = getSprungFlotten(c);
			for(Flotte f: sprungFlotten)
			{
				System.out.println(f.getId()+" x:"+f.getX()+" y:"+f.getY());
				f.setPosition(f.getSprungziel());
				if( f.getX()==f.getZielX() && f.getY()==f.getZielY())
				{
					f.setSprungAufladung(-1);
				}
				else
				{
//					Position sprungZiel = f.getSprungziel();
					int sprungzeit = 0;
					for(Geschwader g : getGeschwader(f, c))
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

			

			//------------------------- Gebäude updaten --------------------------
			Planet s = getPlanet(1);
			List<Gebaeude> relGebs = getRelevanteGebaeude(s);
			List<Gebaeude> planetGebs = getGebaeude(s);
			if(debug) {System.out.println("updateTick3 milis: "+(System.currentTimeMillis()-lt)); lt=System.currentTimeMillis(); }
			for(Gebaeude g : planetGebs)
			{
				g.setAlter(g.getAlter()+1);
				if(g.getAlter()<0)
				{
					g.setAusgaben(0);
					g.setAuslastung(0);
					g.setEffizienz(0);
					g.setEinnahmen(0);
				}
				else
				{
					g.setEffizienz(getEffizienz(g, relGebs));
					g.setAuslastung(getAuslastung(g));
					g.setEinnahmen(getEinnahmen(g));
					g.setAusgaben(getAusgaben(g));
				}
			}
			if(debug) {System.out.println("updateTick4 milis: "+(System.currentTimeMillis()-lt)); lt=System.currentTimeMillis(); }
			updateGebaeude(c, planetGebs);

			
			//------------------------- Globale updates --------------------------
			statement = c.createStatement();
		    statement.addBatch("update flotte set sprungAufladung = sprungAufladung - 1 where sprungAufladung >= 0;");
		    statement.addBatch("update nutzer set einnahmen = COALESCE((SELECT sum(gebaeude.einnahmen)-sum(gebaeude.ausgaben)+50 FROM gebaeude where besitzerNutzerId = nutzer.id),0 )");
		    statement.addBatch("update nutzer set kontostand = kontostand+einnahmen");
		    statement.executeBatch();
		    statement.close();
			loadNutzer(c);
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

	public Nutzer getNutzer(int id)
	{
		return nutzer.get(id);
	}
	public Produkt getProdukt(int id)
	{
		return produkte.get(id);
	}
	public Modell getModell(int id)
	{
		return modelle.get(id);
	}
	public Schiffsmodell getSchiffsmodell(int id)
	{
		return schiffsmodelle.get(id);
	}
	public Planet getPlanet(int id)
	{
		return planeten.get(id);
	}
	public Typ getTyp(int id)
	{
		return typen.get(id);
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
	
	public void updateGebaeude(Connection c, List<Gebaeude> gebs) throws SQLException
	{
		for(Gebaeude g : gebs)
		{
			PreparedStatement ps = c.prepareStatement("update gebaeude set auslastung = ?, ausgaben = ?, einnahmen = ?, `alter` = ? where id = ?");
			ps.setInt(1, g.getAuslastung());
			ps.setInt(2, g.getAusgaben());
			ps.setInt(3, g.getEinnahmen());
			ps.setInt(4, g.getAlter());
			ps.setInt(5, g.getId());
			ps.executeUpdate();
			ps.close();
		}
	}


	public List<Flotte> getFlotten(int x, int y) throws Exception
	{
		Connection c = DbEngine.getConnection();
		try
		{
			return getFlotten(x, y, c);
		}
		finally { c.close(); }
	}

	private String generateQsForIn(int numQs)
	{
	    StringBuffer items = new StringBuffer(numQs*5);
	    for (int i = 0; i < numQs; i++) 
	    {
	        if (i != 0) items.append(", ");
	        items.append("?");
	    }
	    return items.toString();
	}

	public List<Flotte> getFlotten(List<Integer> ids, Nutzer nutzer) throws Exception
	{
		Connection c = DbEngine.getConnection();
		try
		{
			return getFlotten(ids, nutzer, c);
		}
		finally { c.close(); }
	}
	public List<Flotte> getFlotten(List<Integer> ids, Nutzer nutzer, Connection c) throws Exception
	{
		List<Flotte> results = new ArrayList<Flotte>();
		PreparedStatement ps = c.prepareStatement("	SELECT * from flotte where besitzerNutzerId = ? and id in ("+generateQsForIn(ids.size())+")");
		ps.setInt(1, nutzer.getId());
		for(int i=0; i<ids.size(); i++)
			ps.setInt(2+i, ids.get(i));
		ResultSet rs = ps.executeQuery();
		while(rs != null && rs.next()) results.add(new Flotte(rs));
		if(rs!=null) rs.close();
		ps.close();
		return results;
	}


	public void updateFlotten(List<Integer> ids, Nutzer nutzer, int zielX, int zielY) throws Exception
	{
		Connection c = DbEngine.getConnection();
		try
		{
			updateFlotten(ids, nutzer, zielX, zielY, c);
			c.commit();
		}
		finally { c.close(); }
	}

	public void updateFlotten(List<Integer> ids, Nutzer nutzer, int zielX, int zielY, Connection c) throws Exception
	{
		PreparedStatement ps = c.prepareStatement("update flotte set sprungAufladung=30, zielX = ?, zielY = ? where besitzerNutzerId = ? and id in ("+generateQsForIn(ids.size())+")");
		ps.setInt(1, zielX);
		ps.setInt(2, zielY);
		ps.setInt(3, nutzer.getId());
		for(int i=0; i<ids.size(); i++)
			ps.setInt(4+i, ids.get(i));
		System.out.println(ps.toString()+"\n\n x:"+nutzer.getId());
		ps.executeUpdate();
		ps.close();
	}

	
	public List<Flotte> getFlotten(int x, int y, Connection c) throws Exception
	{
		List<Flotte> results = new ArrayList<Flotte>();
		PreparedStatement ps = c.prepareStatement("	SELECT * from flotte where x = ? and y = ?");
		ps.setInt(1, x);
		ps.setInt(2, y);
		ResultSet rs = ps.executeQuery();
		while(rs != null && rs.next()) results.add(new Flotte(rs));
		if(rs!=null) rs.close();
		ps.close();
		return results;
	}
	
	
	
	/**
	 * Liefert alle Geschwader einer Flotten bzw. alle nach Schiffmodellen gruppierten Unterflotten einer Flotte.
	 */
	public List<Geschwader> getGeschwader(Flotte f) throws Exception
	{
		Connection c = DbEngine.getConnection();
		try
		{
			return getGeschwader(f, c);
		}
		finally { c.close(); }
	}
	
	/**
	 * Liefert alle Geschwader einer Flotten bzw. alle nach Schiffmodellen gruppierten Unterflotten einer Flotte.
	 */
	public List<Geschwader> getGeschwader(Flotte f, Connection c) throws Exception
	{
		List<Geschwader> results = new ArrayList<Geschwader>();
		PreparedStatement ps = c.prepareStatement("	SELECT * from Geschwader where flotteId = "+f.getId());
		ResultSet rs = ps.executeQuery();
		while(rs != null && rs.next()) results.add(new Geschwader(rs));
		if(rs!=null) rs.close();
		ps.close();
		return results;
	}

	/**
	 * Liefert die Flotten welche gerade im Begriff sind zu "springen".
	 */
	public List<Flotte> getSprungFlotten(Connection c) throws Exception
	{
		List<Flotte> results = new ArrayList<Flotte>();
		PreparedStatement ps = c.prepareStatement("	SELECT   id,  besitzerNutzerId, zielX,  zielY, x, y, sprungAufladung from flotte where sprungAufladung = 0 and zielX is not null");
		ResultSet rs = ps.executeQuery();
		while(rs != null && rs.next()) results.add(new Flotte(rs));
		if(rs!=null) rs.close();
		ps.close();
		return results;
	}

	public Gebaeude getGebaeude(int x, int y) throws Exception
	{
		Connection c = DbEngine.getConnection();
		try
		{
			return getGebaeude(x, y, c);
		}
		finally { c.close(); }
	}
	public Gebaeude getGebaeude(int x, int y, Connection c) throws Exception
	{
		Gebaeude results = null;
		PreparedStatement ps;
		ResultSet rs;
		// ----------------------------------------------------------------------------------------------------
		// ----------------------------------------- Gebäude -----------------------------------
		// ----------------------------------------------------------------------------------------------------
		StringBuffer sb = new StringBuffer(200);
		sb.append("	select gebaeude.id as id, `alter`, ausgaben, auslastung, gebaeude.besitzerNutzerId as besitzerNutzerId, ");
		sb.append("	effizienz, einnahmen, grundstueck.id as grundstueckId, ");
		sb.append("	grundstueck.x as grundstueckX, ");
		sb.append("	grundstueck.y as grundstueckY, ");
		sb.append("	gebaeude.modellId as modellId, ");
		sb.append("	grundstueck.planetId as planetId ");
		sb.append("	from gebaeude ");
		sb.append("	join modell on (modell.id = gebaeude.modellId) ");
		sb.append("	join grundstueck on (grundstueck.gebaeudeId = gebaeude.id) ");
		sb.append("	where grundstueck.x = ?");
		sb.append("	and grundstueck.y = ?");
		ps = c.prepareStatement(sb.toString());
		ps.setInt(1, x);
		ps.setInt(2, y);
		if(debug) System.out.println(ps.toString()+"\n\n x:"+x+" y:"+y);

		rs = ps.executeQuery();
		if(rs != null && rs.next())
		{
			Gebaeude g = new Gebaeude();
			g.setId(rs.getInt("id"));
			g.setAlter(rs.getInt("alter"));
			g.setAusgaben(rs.getInt("ausgaben"));
			g.setAuslastung(rs.getInt("auslastung"));
			g.setBesitzer(getNutzer(rs.getInt("besitzerNutzerId")));
			g.setEffizienz(rs.getFloat("effizienz"));
			g.setEinnahmen(rs.getInt("einnahmen"));
			g.setGrundstueckId(rs.getInt("grundstueckId"));
			g.setGrundstueckX(rs.getInt("grundstueckX"));
			g.setGrundstueckY(rs.getInt("grundstueckY"));
			g.setModell(getModell(rs.getInt("modellId")));
			g.setPlanet(getPlanet(rs.getInt("planetId")));
			results = g;
		}
		if(rs!=null) rs.close();
		ps.close();
		return results;
	}
	
	public List<Gebaeude> getGebaeude(Planet s) throws Exception
	{
		List<Gebaeude> results = new ArrayList<Gebaeude>();
		Connection c = DbEngine.getConnection();
		try
		{
			PreparedStatement ps;
			ResultSet rs;
			// ----------------------------------------------------------------------------------------------------
			// ----------------------------------------- Gebäude -----------------------------------
			// ----------------------------------------------------------------------------------------------------
			StringBuffer sb = new StringBuffer(200);
			sb.append("	select gebaeude.id as id, `alter`, ausgaben, auslastung, gebaeude.besitzerNutzerId as besitzerNutzerId, ");
			sb.append("	effizienz, einnahmen, grundstueck.id as grundstueckId, ");
			sb.append("	grundstueck.x as grundstueckX, ");
			sb.append("	grundstueck.y as grundstueckY, ");
			sb.append("	gebaeude.modellId as modellId, ");
			sb.append("	grundstueck.planetId as planetId ");
			sb.append("	from gebaeude ");
			sb.append("	join modell on (modell.id = gebaeude.modellId) ");
			sb.append("	join grundstueck on (grundstueck.gebaeudeId = gebaeude.id) ");
			sb.append("	where planetId = ?");
			ps = c.prepareStatement(sb.toString());
			
			ps.setInt(1, s.getId());
			rs = ps.executeQuery();
			while(rs != null && rs.next())
			{
				Gebaeude g = new Gebaeude();
				g.setId(rs.getInt("id"));
				g.setAlter(rs.getInt("alter"));
				g.setAusgaben(rs.getInt("ausgaben"));
				g.setAuslastung(rs.getInt("auslastung"));
				g.setBesitzer(getNutzer(rs.getInt("besitzerNutzerId")));
				g.setEffizienz(rs.getFloat("effizienz"));
				g.setEinnahmen(rs.getInt("einnahmen"));
				g.setGrundstueckId(rs.getInt("grundstueckId"));
				g.setGrundstueckX(rs.getInt("grundstueckX"));
				g.setGrundstueckY(rs.getInt("grundstueckY"));
				g.setModell(getModell(rs.getInt("modellId")));
				g.setPlanet(getPlanet(rs.getInt("planetId")));
				results.add(g);
			}
			if(rs!=null) rs.close();
			ps.close();
		}
		finally { c.close(); }
		return results;
	}
	public Gebaeude getGebaeude(int id) throws Exception
	{
		Gebaeude g=null;
		Connection c = DbEngine.getConnection();
		try
		{
			PreparedStatement ps;
			ResultSet rs;
			// ----------------------------------------------------------------------------------------------------
			// ----------------------------------------- Gebäude -----------------------------------
			// ----------------------------------------------------------------------------------------------------
			StringBuffer sb = new StringBuffer(200);
			sb.append("	select gebaeude.id as id, `alter`, ausgaben, auslastung, gebaeude.besitzerNutzerId as besitzerNutzerId, ");
			sb.append("	effizienz, einnahmen, grundstueck.id as grundstueckId, ");
			sb.append("	grundstueck.x as grundstueckX, ");
			sb.append("	grundstueck.y as grundstueckY, ");
			sb.append("	gebaeude.modellId as modellId, ");
			sb.append("	grundstueck.planetId as planetId ");
			sb.append("	from gebaeude ");
			sb.append("	join modell on (modell.id = gebaeude.modellId) ");
			sb.append("	join grundstueck on (grundstueck.gebaeudeId = gebaeude.id) ");
			sb.append("	where gebaeude.id = ?");
			
			ps = c.prepareStatement(sb.toString());
			ps.setInt(1, id);
			rs = ps.executeQuery();
			if (rs != null && rs.next())
			{
				g = new Gebaeude();
				g.setId(rs.getInt("id"));
				g.setAlter(rs.getInt("alter"));
				g.setAusgaben(rs.getInt("ausgaben"));
				g.setAuslastung(rs.getInt("auslastung"));
				g.setBesitzer(getNutzer(rs.getInt("besitzerNutzerId")));
				g.setEffizienz(rs.getFloat("effizienz"));
				g.setEinnahmen(rs.getInt("einnahmen"));
				g.setGrundstueckId(rs.getInt("grundstueckId"));
				g.setGrundstueckX(rs.getInt("grundstueckX"));
				g.setGrundstueckY(rs.getInt("grundstueckY"));
				g.setModell(getModell(rs.getInt("modellId")));
				g.setPlanet(getPlanet(rs.getInt("planetId")));
				rs.close();
			}
			ps.close();
		}
		finally { c.close(); }
		return g;
	}
	
	synchronized private void loadSchiffsmodelle(Connection c) throws SQLException
	{
		schiffsmodelle = new HashMap<Integer, Schiffsmodell>();
		PreparedStatement ps;
		ResultSet rs;
		ps = c.prepareStatement("select * from schiffsmodell");
		rs = ps.executeQuery();
		while (rs != null && rs.next())
		{
			Schiffsmodell p = new Schiffsmodell(rs);
			schiffsmodelle.put(p.getId(),p);
		}
		rs.close();
		ps.close();
	}
	
	synchronized private void loadModelle(Connection c) throws SQLException
	{
		modellListe = new ArrayList<Modell>();
		modelle = new HashMap<Integer, Modell>();
		
		PreparedStatement ps;
		ResultSet rs;
		ps = c.prepareStatement("select * from modell join typ on (typ.id = modell.typId) left outer join produkt on (produkt.id = modell.produktId) order by produkt.bezeichnung, typ.bezeichnung, modell.bezeichnung, modell.kapazitaet;");
		rs = ps.executeQuery();
		while (rs != null && rs.next())
		{
			Modell p = new Modell();
			p.setId(rs.getInt("modell.id"));
			p.setTyp(getTyp(rs.getInt("modell.typId")));
			p.setAnzahlBewertungen(rs.getInt("modell.anzahlBewertungen"));
			p.setBewertung(rs.getInt("modell.bewertung"));
			p.setBezeichnung(rs.getString("modell.bezeichnung"));
			p.setBreite(rs.getInt("modell.breite"));
			p.setErsteller(getNutzer( rs.getInt("modell.erstellerNutzerId") ));
			p.setKapazitaet(rs.getInt("modell.kapazitaet"));
			p.setProdukt(getProdukt(rs.getInt("modell.produktId")));
			p.setStockwerke(rs.getInt("modell.stockwerke"));
			p.setTiefe(rs.getInt("modell.tiefe"));
			p.setTyp(getTyp(rs.getInt("modell.typId")));
			modelle.put(p.getId(),p);
			modellListe.add(p);
		}
		rs.close();
		ps.close();
	}

	synchronized private void loadNutzer(Connection c) throws SQLException
	{
		PreparedStatement ps;
		ResultSet rs;
		// ----------------------------------------------------------------------------------------------------
		// ----------------------------------------- Nutzer -----------------------------------
		// ----------------------------------------------------------------------------------------------------
		ps = c.prepareStatement("select *, (select count(*) from gebaeude where besitzerNutzerId = nutzer.id) as anzahlGebaeude from nutzer ");
		rs = ps.executeQuery();
		while (rs != null && rs.next())
		{
			Nutzer p = new Nutzer();
			p.setId(rs.getInt("id"));
			p.setAlias(rs.getString("alias"));
			p.setKey(rs.getString("key"));
			p.setKontostand(rs.getInt("kontostand"));
			p.setGewinn(rs.getInt("einnahmen"));
			p.setAnzahlGebaeude(rs.getInt("anzahlGebaeude"));
			nutzer.put(p.getId(),p);
		}
		rs.close();
		ps.close();
	}
	public Service() throws Exception
	{
		Connection c = DbEngine.getConnection();
		try
		{
			PreparedStatement ps;
			ResultSet rs;
			loadNutzer(c);
			// ----------------------------------------------------------------------------------------------------
			// ----------------------------------------- Planet -----------------------------------
			// ----------------------------------------------------------------------------------------------------
			ps = c.prepareStatement("select * from planet");
			rs = ps.executeQuery();
			while (rs != null && rs.next())
			{
				Planet p = new Planet();
				p.setId(rs.getInt("id"));
				p.setX(rs.getInt("x"));
				p.setY(rs.getInt("y"));
				planeten.put(p.getId(),p);
			}
			rs.close();
			ps.close();
			// ----------------------------------------------------------------------------------------------------
			// ----------------------------------------- Typen -----------------------------------
			// ----------------------------------------------------------------------------------------------------
			ps = c.prepareStatement("select * from typ");
			rs = ps.executeQuery();
			while (rs != null && rs.next())
			{
				Typ p = new Typ();
				p.setId(rs.getInt("id"));
				p.setBezeichnung(rs.getString("bezeichnung"));
				p.setBeschreibung(rs.getString("beschreibung"));
				typen.put(p.getId(),p);
			}
			rs.close();
			ps.close();
			// ----------------------------------------------------------------------------------------------------
			// ----------------------------------------- Produkte -----------------------------------
			// ----------------------------------------------------------------------------------------------------
			ps = c.prepareStatement("select * from produkt");
			rs = ps.executeQuery();
			while (rs != null && rs.next())
			{
				Produkt p = new Produkt();
				p.setId(rs.getInt("id"));
				p.setBezeichnung(rs.getString("bezeichnung"));
				p.setEndprodukt(rs.getBoolean("istEndprodukt"));
				produkte.put(p.getId(),p);
			}
			rs.close();
			ps.close();
			for(Produkt p : produkte.values())
			{
				ps = c.prepareStatement("select * from produktzuordnung where produktId = ?");
				ps.setInt(1, p.getId());
				rs = ps.executeQuery();
				while (rs != null && rs.next())
					p.getBenoetigtProdukte().put(rs.getInt("benoetigtProduktId"), getProdukt(rs.getInt("benoetigtProduktId")));
				if(rs!=null)
					rs.close();
				ps.close();
			}
			// ----------------------------------------------------------------------------------------------------
			// ----------------------------------------- Einfluss -----------------------------------
			// ----------------------------------------------------------------------------------------------------
			ps = c.prepareStatement("select * from einfluss");
			rs = ps.executeQuery();
			while (rs != null && rs.next())
			{
				//objektart 2 = produkt | objektart 1 = typ
				Einfluss f = new Einfluss();
//				f.setBeziehung(rs.getInt("beziehung"));
				f.setaId(rs.getInt("aId"));
				f.setbId(rs.getInt("bId"));
				f.setRadius(rs.getInt("radius"));
				f.setaObjektart(rs.getInt("aObjektart"));
				f.setbObjektart(rs.getInt("bObjektart"));

				if(f.getaObjektart() == 2)
				{
					f.setaBezeichnung(getProdukt(f.getaId()).getBezeichnung());
					f.setaProdukt(getProdukt(f.getaId()));
				}
				else
				{
					f.setaBezeichnung(getTyp(f.getaId()).getBezeichnung());
					f.setaTyp( getTyp(f.getaId()) );
				}
				if(f.getbObjektart() == 2)
				{
					f.setbBezeichnung(getProdukt(f.getbId()).getBezeichnung());
					f.setbProdukt(getProdukt(f.getbId()));
				}
				else
				{
					f.setbBezeichnung(getTyp(f.getbId()).getBezeichnung());
					f.setbTyp(getTyp(f.getbId()));
				}
				
				f.setDurchAuslastung(rs.getBoolean("durchAuslastung"));
				f.setDurchExistenz(rs.getBoolean("durchExistenz"));
				f.setEinfluss(rs.getFloat("einfluss"));
				f.setMaxEinfluss(rs.getInt("maxEinfluss"));
				f.setMinEinfluss(rs.getInt("minEinfluss"));
				einfluesse.add(f);
			}
			rs.close();
			ps.close();
			loadModelle(c);
			loadSchiffsmodelle(c);

		}
		finally
		{
			c.close();
		}
	}

	public List<Einfluss> getEinfluesse(Gebaeude g, List<Gebaeude> relevanteGebs) throws Exception
	{
//		boolean fired=false;
		List<Einfluss> results = new ArrayList<Einfluss>();
		for(Einfluss f : getEinfluesse())
		{
			if(g.getModell().getProdukt()!=null && f.getaObjektart()==2 && f.getaId()==g.getModell().getProdukt().getId())
				results.add(f.clone());
			if(f.getaObjektart()==1 && f.getaId()==g.getModell().getTyp().getId())
				results.add(f.clone());
		}
		List<Gebaeude> gebs = relevanteGebs!=null ? relevanteGebs : getRelevanteGebaeude(g);
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
	synchronized public String insertNutzer(Nutzer nutzer) throws Exception
	{
		Connection c = null;
		try
		{
			c = DbEngine.getConnection();
			PreparedStatement ps;
			ps = c.prepareStatement("insert into nutzer (`key`,`alias`) values (?,?)");
			ps.setString(1, nutzer.getKey());
			ps.setString(2, nutzer.getAlias());
			ps.executeUpdate();
			ps.close();
			c.commit();
			loadNutzer(c);
		}
		catch(Exception ex)
		{
			c.rollback();
			throw ex;
		}
		finally { c.close(); }
		return null;
	}
	public void destroyGebaeude(Nutzer nutzer, int x, int y) throws Exception
	{
		Connection c = DbEngine.getConnection();
		try
		{
			Gebaeude g = getGebaeude(x,y,c);
			if(g==null) throw new Exception("Das zu zerstörende Gebäude konnte nicht gefunden werden.");

			if(g.getBesitzer().getId()!=nutzer.getId())
				throw new Exception("Das zu löschende Gebäude ist nicht Ihr Eigentum.");
			
			PreparedStatement ps = c.prepareStatement("delete from gebaeude where id = ?");
			ps.setInt(1, g.getId());
			ps.executeUpdate();
			ps.close();
			c.commit();
		}
		catch(Exception ex)
		{
			c.rollback();
			throw ex;
		}
		finally
		{
			if(c!=null) c.close();
		}
	}
	synchronized public void insertGebaeude(Nutzer nutzer, int x, int y, int modellId) throws Exception
	{
		Connection c = DbEngine.getConnection();
		try
		{
			Gebaeude g = getGebaeude(x,y,c);
			int kosten = getModell(modellId).getBaukosten();
			if(g==null) kosten += nutzer.getBauplatzKosten();
			if(kosten > nutzer.getKontostand())
				throw new Exception("Nicht genug Geld für diese Investition");
			if(g!=null)
			{
				if(g.getBesitzer().getId()!=nutzer.getId())
					throw new Exception("Das neu zu bebauende Gebäude ist nicht Ihr Eigentum.");
				
				PreparedStatement ps = c.prepareStatement("update gebaeude set modellId=?, besitzerNutzerId=?, `alter`=? where id = ?");
				ps.setInt(1, modellId);
				ps.setInt(2, nutzer.getId());
				ps.setInt(3, -1 * getModell(modellId).getBauzeit() );
				ps.setInt(4, g.getId());
				ps.executeUpdate();
				ps.close();
				
				ps = c.prepareStatement("update nutzer set kontostand=kontostand-? where id = ?");
				ps.setInt(1, kosten);
				ps.setInt(2, nutzer.getId());
				ps.executeUpdate();
				ps.close();
				
				c.commit();
				nutzer.setKontostand(nutzer.getKontostand()-kosten);
			}
			else
			{
				PreparedStatement ps = c.prepareStatement("INSERT INTO gebaeude (modellId, besitzerNutzerId, `alter`) VALUES (?, ?, ?)");
				ps.setInt(1, modellId);
				ps.setInt(2, nutzer.getId());
				ps.setInt(3, -1 * getModell(modellId).getBauzeit() );
				ps.executeUpdate();
				ps.close();
	
				ps = c.prepareStatement("INSERT INTO grundstueck (gebaeudeId, planetId, x, y) VALUES (LAST_INSERT_ID(), ?, ?, ?)");
				ps.setInt(1, 1);
				ps.setInt(2, x);
				ps.setInt(3, y);
				ps.executeUpdate();
				ps.close();
				
				ps = c.prepareStatement("update nutzer set kontostand=kontostand-? where id = ?");
				ps.setInt(1, kosten);
				ps.setInt(2, nutzer.getId());
				ps.executeUpdate();
				ps.close();
				
				c.commit();
				nutzer.setKontostand(nutzer.getKontostand()-kosten);
				nutzer.setAnzahlGebaeude(nutzer.getAnzahlGebaeude()+1);
			}
		}
		catch(Exception ex)
		{
			c.rollback();
			throw ex;
		}
		finally
		{
			if(c!=null) c.close();
		}
	}
	
	public List<Gebaeude> getRelevanteGebaeude(Gebaeude forG) throws Exception
	{
		return getRelevanteGebaeude(forG.getPlanet());
	}
	public List<Gebaeude> getRelevanteGebaeude(Planet s) throws Exception
	{
		List<Gebaeude> results = new ArrayList<Gebaeude>();
		Connection c = DbEngine.getConnection();
		try
		{
			
			PreparedStatement ps;
			ResultSet rs;
			// ----------------------------------------------------------------------------------------------------
			// ----------------------------------------- Gebäude -----------------------------------
			// ----------------------------------------------------------------------------------------------------
			StringBuffer sb = new StringBuffer(200);
			sb.append("	select gebaeude.id as id, `alter`, ausgaben, auslastung, gebaeude.besitzerNutzerId as besitzerNutzerId, ");
			sb.append("	effizienz, einnahmen, grundstueck.id as grundstueckId, ");
			sb.append("	grundstueck.x as grundstueckX, ");
			sb.append("	grundstueck.y as grundstueckY, ");
			sb.append("	gebaeude.modellId as modellId, ");
			sb.append("	grundstueck.planetId as planetId ");
			sb.append("	from gebaeude ");
			sb.append("	join modell on (modell.id = gebaeude.modellId) ");
			sb.append("	join grundstueck on (grundstueck.gebaeudeId = gebaeude.id) ");
			sb.append("	where `alter` > 0");
			ps = c.prepareStatement(sb.toString());
//			
//			ps = c.prepareStatement("select * from v_gebaeude "+
//				" where v_gebaeude.planetId in ( "+
//				" select id from planet s "+
//				" where  "+
//				"     (s.x = ? and s.y = ?) "+
//				" or  (s.x = ? and s.y = ?) "+
//				" or  (s.x = ? and s.y = ?) "+
//				" or  (s.x = ? and s.y = ?) "+
//				" or  (s.x = ? and s.y = ?) "+
//				" or  (s.x = ? and s.y = ?) "+
//				" or  (s.x = ? and s.y = ?) "+
//				" or  (s.x = ? and s.y = ?) "+
//				" or  (s.x = ? and s.y = ?) "+
//				" ) ");
//
//			ps.setInt(1, s.getX());
//			ps.setInt(2, s.getY());
//			ps.setInt(3, s.getX());
//			ps.setInt(4, s.getY()+1);
//			ps.setInt(5, s.getX());
//			ps.setInt(6, s.getY()-1);
//
//			ps.setInt(7, s.getX()+1);
//			ps.setInt(8, s.getY());
//			ps.setInt(9, s.getX()+1);
//			ps.setInt(10, s.getY()+1);
//			ps.setInt(11, s.getX()+1);
//			ps.setInt(12, s.getY()-1);
//
//			ps.setInt(13, s.getX()-1);
//			ps.setInt(14, s.getY());
//			ps.setInt(15, s.getX()-1);
//			ps.setInt(16, s.getY()+1);
//			ps.setInt(17, s.getX()-1);
//			ps.setInt(18, s.getY()-1);

			rs = ps.executeQuery();
			while(rs != null && rs.next())
			{
				Gebaeude g = new Gebaeude();
				g.setId(rs.getInt("id"));
				g.setAlter(rs.getInt("alter"));
				g.setAusgaben(rs.getInt("ausgaben"));
				g.setAuslastung(rs.getInt("auslastung"));
				g.setBesitzer(getNutzer(rs.getInt("besitzerNutzerId")));
				g.setEffizienz(rs.getFloat("effizienz"));
				g.setEinnahmen(rs.getInt("einnahmen"));
				g.setGrundstueckId(rs.getInt("grundstueckId"));
				g.setGrundstueckX(rs.getInt("grundstueckX"));
				g.setGrundstueckY(rs.getInt("grundstueckY"));
				g.setModell(getModell(rs.getInt("modellId")));
				g.setPlanet(getPlanet(rs.getInt("planetId")));
				results.add(g);
			}
			if(rs!=null) rs.close();
			ps.close();
		}
		finally { c.close(); }
		return results;	}

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
	public List<Einfluss> getEinfluesse()
	{
		return einfluesse;
	}

	public Map<Integer, Produkt> getProdukte()
	{
		return produkte;
	}

	public Map<Integer, Typ> getTypen()
	{
		return typen;
	}
	public Map<Integer, Modell> getModelle()
	{
		return modelle;
	}
	public Map<Integer, Planet> getPlaneten()
	{
		return planeten;
	}
	public Map<Integer, Nutzer> getNutzer()
	{
		return nutzer;
	}
	public Nutzer getNutzerByKey(String key) throws Exception
	{
		for(Nutzer n : getNutzer().values())
			if(key.equals(n.getKey()))
				return n;
		return null;
	}
	public Nutzer getNutzer(HttpSession session)
	{
		return getNutzer((Integer)session.getAttribute("userId"));
	}

	public List<Modell> getModellListe()
	{
		return modellListe;
	}
}