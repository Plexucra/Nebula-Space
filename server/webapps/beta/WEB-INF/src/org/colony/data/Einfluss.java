package org.colony.data;

public class Einfluss implements Cloneable
{
	int id;
	int aId;
	int bId;
	boolean durchAuslastung;
	boolean durchExistenz;
	float einfluss;
	float currentEinfluss;
	int maxEinfluss;
	int minEinfluss;
//	int beziehung;
	int aObjektart;
	int bObjektart;
	String aBezeichnung;
	String bBezeichnung;
	Typ aTyp;
	Typ bTyp;
	Produkt aProdukt;
	Produkt bProdukt;
	int radius;
	public Einfluss clone()
	{
		Einfluss e = new Einfluss();
		e.setId(id);
		e.setaId(aId);
		e.setbId(bId);
		e.setDurchAuslastung(durchAuslastung);
		e.setDurchExistenz(durchExistenz);
		e.setEinfluss(einfluss);
		e.setMaxEinfluss(maxEinfluss);
		e.setMinEinfluss(minEinfluss);
//		e.setBeziehung(beziehung);
		e.setaBezeichnung(aBezeichnung);
		e.setbBezeichnung(bBezeichnung);
		e.setaTyp(aTyp);
		e.setbTyp(bTyp);
		e.setaProdukt(aProdukt);
		e.setbProdukt(bProdukt);
		e.setCurrentEinfluss(currentEinfluss);
		e.setaObjektart(aObjektart);
		e.setbObjektart(bObjektart);
		e.setRadius(radius);
		return e;
	}
	
	public int getId()
	{
		return id;
	}
	public void setId(int id)
	{
		this.id = id;
	}
	public int getaId()
	{
		return aId;
	}
	public void setaId(int aId)
	{
		this.aId = aId;
	}
	public int getbId()
	{
		return bId;
	}
	public void setbId(int bId)
	{
		this.bId = bId;
	}
	public boolean isDurchAuslastung()
	{
		return durchAuslastung;
	}
	public void setDurchAuslastung(boolean durchAuslastung)
	{
		this.durchAuslastung = durchAuslastung;
	}
	public boolean isDurchExistenz()
	{
		return durchExistenz;
	}
	public void setDurchExistenz(boolean durchExistenz)
	{
		this.durchExistenz = durchExistenz;
	}
	public int getMaxEinfluss()
	{
		return maxEinfluss;
	}
	public void setMaxEinfluss(int maxEinfluss)
	{
		this.maxEinfluss = maxEinfluss;
	}
	public int getMinEinfluss()
	{
		return minEinfluss;
	}
	public void setMinEinfluss(int minEinfluss)
	{
		this.minEinfluss = minEinfluss;
	}
//	public int getBeziehung()
//	{
//		return beziehung;
//	}
//	public void setBeziehung(int beziehung)
//	{
//		this.beziehung = beziehung;
//	}
	public String getaBezeichnung()
	{
		return aBezeichnung;
	}
	public void setaBezeichnung(String aBezeichnung)
	{
		this.aBezeichnung = aBezeichnung;
	}
	public String getbBezeichnung()
	{
		return bBezeichnung;
	}
	public void setbBezeichnung(String bBezeichnung)
	{
		this.bBezeichnung = bBezeichnung;
	}

	public Typ getaTyp()
	{
		return aTyp;
	}

	public void setaTyp(Typ aTyp)
	{
		this.aTyp = aTyp;
	}

	public Typ getbTyp()
	{
		return bTyp;
	}

	public void setbTyp(Typ bTyp)
	{
		this.bTyp = bTyp;
	}

	public Produkt getaProdukt()
	{
		return aProdukt;
	}

	public void setaProdukt(Produkt aProdukt)
	{
		this.aProdukt = aProdukt;
	}

	public Produkt getbProdukt()
	{
		return bProdukt;
	}

	public void setbProdukt(Produkt bProdukt)
	{
		this.bProdukt = bProdukt;
	}

	public float getEinfluss()
	{
		return einfluss;
	}

	public void setEinfluss(float einfluss)
	{
		this.einfluss = einfluss;
	}

	public float getCurrentEinfluss()
	{
		return currentEinfluss;
	}

	public void setCurrentEinfluss(float currentEinfluss)
	{
		this.currentEinfluss = currentEinfluss;
	}

	public int getaObjektart()
	{
		return aObjektart;
	}

	public void setaObjektart(int aObjektart)
	{
		this.aObjektart = aObjektart;
	}

	public int getbObjektart()
	{
		return bObjektart;
	}

	public void setbObjektart(int bObjektart)
	{
		this.bObjektart = bObjektart;
	}

	public int getRadius()
	{
		return radius;
	}

	public void setRadius(int radius)
	{
		this.radius = radius;
	}

}