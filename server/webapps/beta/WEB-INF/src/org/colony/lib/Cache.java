package org.colony.lib;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.colony.data.Allianz;
import org.colony.data.Einfluss;
import org.colony.data.Modell;
import org.colony.data.Nutzer;
import org.colony.data.Planet;
import org.colony.data.Produkt;
import org.colony.data.Schiffsmodell;
import org.colony.data.Typ;
import org.colony.service.AllianzService;

public class Cache
{
	public static Cache get()
	{
		return ContextListener.getService().getCache();
	}
	
	List<Einfluss> einfluesse = new ArrayList<Einfluss>();
	Map<Integer,Produkt> produkte = new HashMap<Integer, Produkt>();
	Map<Integer,Typ> typen = new HashMap<Integer, Typ>();
	Map<Integer,Modell> modelle = new HashMap<Integer, Modell>();
	List<Modell> modellListe = new ArrayList<Modell>();
	Map<Integer,Schiffsmodell> schiffsmodelle = new HashMap<Integer, Schiffsmodell>();
	Map<Integer,Planet> planeten = new HashMap<Integer, Planet>();
	Map<Integer,Allianz> allianzen = new HashMap<Integer, Allianz>();
	Map<Integer,Nutzer> nutzer = new HashMap<Integer, Nutzer>();
	
	public Produkt getProdukt(int id)
	{
		return getProdukte().get(id);
	}
	
	public Typ getTyp(int id)
	{
		return getTypen().get(id);
	}
	
	public Modell getModell(int id)
	{
		return getModelle().get(id);
	}
	
	public Schiffsmodell getSchiffsmodell(int id)
	{
		return getSchiffsmodelle().get(id);
	}
	
	public Planet getPlanet(int id)
	{
		return getPlaneten().get(id);
	}
	
	public Allianz getAllianz(int id)
	{
		return getAllianzen().get(id);
	}
	
	public Nutzer getNutzer(int id)
	{
		return getNutzer().get(id);
	}
	
	
	public Cache() throws SQLException
	{
		Connection c = null;
		try
		{
			c = DbEngine.getConnection();
			PreparedStatement ps;
			ResultSet rs;
			loadNutzer(c);
			loadAllianzen(c);
			// ----------------------------------------------------------------------------------------------------
			// ----------------------------------------- Planet -----------------------------------
			// ----------------------------------------------------------------------------------------------------
			ps = c.prepareStatement("select * from planet");
			rs = ps.executeQuery();
			while (rs != null && rs.next())
			{
				Planet p = new Planet(rs);
				planeten.put(p.getId(),new Planet(rs));
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
	
	
	synchronized public void loadSchiffsmodelle(Connection c) throws SQLException
	{
		schiffsmodelle = new HashMap<Integer, Schiffsmodell>();
		PreparedStatement ps;
		ResultSet rs;
		ps = c.prepareStatement("select * from schiffsmodell");
		rs = ps.executeQuery();
		while (rs != null && rs.next())
		{
			Schiffsmodell p = new Schiffsmodell(c, rs);
			schiffsmodelle.put(p.getId(),p);
		}
		rs.close();
		ps.close();
	}
	
	synchronized public void loadModelle(Connection c) throws SQLException
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

	
	synchronized public void loadAllianzen(Connection c) throws SQLException
	{
		Map<Integer,Allianz> t_allianzen = new HashMap<Integer, Allianz>();
		for(Allianz a: AllianzService.getAllianzen(c))
			t_allianzen.put(a.getId(), a);
		setAllianzen(t_allianzen);
	}

	synchronized public void loadNutzer(Connection c) throws SQLException
	{
		Map<Integer,Nutzer> t_nutzer = new HashMap<Integer, Nutzer>();
		PreparedStatement ps;
		ResultSet rs;
		ps = c.prepareStatement("select * from nutzer ");
		rs = ps.executeQuery();
		while (rs != null && rs.next())
		{
			Nutzer p = new Nutzer();
			p.setId(rs.getInt("id"));
			p.setAlias(rs.getString("alias"));
			p.setKey(rs.getString("key"));
			p.setKontostand(rs.getLong("kontostand"));
			p.setGewinn(rs.getInt("einnahmen"));
//			p.setAnzahlGebaeude(rs.getInt("anzahlGebaeude"));
			p.setHeimatPlanetId(rs.getInt("heimatPlanetId"));
			t_nutzer.put(p.getId(),p);
		}
		
		rs.close();
		ps.close();
		setNutzer(t_nutzer);
	}

	public List<Einfluss> getEinfluesse()
	{
		return einfluesse;
	}
	public void setEinfluesse(List<Einfluss> einfluesse)
	{
		this.einfluesse = einfluesse;
	}
	public Map<Integer, Produkt> getProdukte()
	{
		return produkte;
	}
	public void setProdukte(Map<Integer, Produkt> produkte)
	{
		this.produkte = produkte;
	}
	public Map<Integer, Typ> getTypen()
	{
		return typen;
	}
	public void setTypen(Map<Integer, Typ> typen)
	{
		this.typen = typen;
	}
	public Map<Integer, Modell> getModelle()
	{
		return modelle;
	}
	public void setModelle(Map<Integer, Modell> modelle)
	{
		this.modelle = modelle;
	}
	public List<Modell> getModellListe()
	{
		return modellListe;
	}
	public void setModellListe(List<Modell> modellListe)
	{
		this.modellListe = modellListe;
	}
	public Map<Integer, Schiffsmodell> getSchiffsmodelle()
	{
		return schiffsmodelle;
	}
	public void setSchiffsmodelle(Map<Integer, Schiffsmodell> schiffsmodelle)
	{
		this.schiffsmodelle = schiffsmodelle;
	}
	public Map<Integer, Planet> getPlaneten()
	{
		return planeten;
	}
	public void setPlaneten(Map<Integer, Planet> planeten)
	{
		this.planeten = planeten;
	}
	public Map<Integer, Allianz> getAllianzen()
	{
		return allianzen;
	}
	public void setAllianzen(Map<Integer, Allianz> allianzen)
	{
		this.allianzen = allianzen;
	}
	public Map<Integer, Nutzer> getNutzer()
	{
		return nutzer;
	}
	public void setNutzer(Map<Integer, Nutzer> nutzer)
	{
		this.nutzer = nutzer;
	}
}