package org.colony.data;

public class Modell
{
	int id;
	Typ typ;
	String bezeichnung;
	int stockwerke;
	int tiefe;
	int breite;
	int anzahlBewertungen;
	int bewertung;
	Nutzer ersteller;
	Produkt produkt;
	int kapazitaet;
	public int getBaukosten()
	{
		return getKapazitaet()*100;
	}
	public int getBauzeit()
	{
		return getKapazitaet();
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public Typ getTyp()
	{
		return typ;
	}

	public void setTyp(Typ typ)
	{
		this.typ = typ;
	}

	public String getBezeichnung()
	{
		return bezeichnung;
	}

	public void setBezeichnung(String bezeichnung)
	{
		this.bezeichnung = bezeichnung;
	}

	public int getStockwerke()
	{
		return stockwerke;
	}

	public void setStockwerke(int stockwerke)
	{
		this.stockwerke = stockwerke;
	}

	public int getTiefe()
	{
		return tiefe;
	}

	public void setTiefe(int tiefe)
	{
		this.tiefe = tiefe;
	}

	public int getBreite()
	{
		return breite;
	}

	public void setBreite(int breite)
	{
		this.breite = breite;
	}

	public int getAnzahlBewertungen()
	{
		return anzahlBewertungen;
	}

	public void setAnzahlBewertungen(int anzahlBewertungen)
	{
		this.anzahlBewertungen = anzahlBewertungen;
	}

	public int getBewertung()
	{
		return bewertung;
	}

	public void setBewertung(int bewertung)
	{
		this.bewertung = bewertung;
	}

	public Nutzer getErsteller()
	{
		return ersteller;
	}

	public void setErsteller(Nutzer ersteller)
	{
		this.ersteller = ersteller;
	}

	public Produkt getProdukt()
	{
		return produkt;
	}

	public void setProdukt(Produkt produkt)
	{
		this.produkt = produkt;
	}

	public int getKapazitaet()
	{
		return kapazitaet;
	}

	public void setKapazitaet(int kapazitaet)
	{
		this.kapazitaet = kapazitaet;
	}
}