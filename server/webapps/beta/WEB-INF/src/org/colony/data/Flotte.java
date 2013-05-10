package org.colony.data;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.colony.lib.Cache;

public class Flotte
{
	int id;
	int x;
	int y;
	int besitzerNutzerId;
	int zielX;
	int zielY;
	int sprungAufladung;
	int sprungzeit;
	int ress1;
	int ress2;
	int ress3;
	int ress4;
	int ress5;
	
	public Flotte(ResultSet rs) throws SQLException
	{
		setId(rs.getInt("id"));
		setBesitzerNutzerId(rs.getInt("besitzerNutzerId"));
		setZielX(rs.getInt("zielX"));
		setZielY(rs.getInt("zielY"));
		setX(rs.getInt("x"));
		setY(rs.getInt("y"));
		setSprungAufladung(rs.getInt("sprungAufladung"));
		setRess1(rs.getInt("ress1"));
		setRess2(rs.getInt("ress2"));
		setRess3(rs.getInt("ress3"));
		setRess4(rs.getInt("ress4"));
		setRess5(rs.getInt("ress5"));
	}
	
	public boolean hasRess()
	{
		return getRess1() > 0 || getRess2() > 0 || getRess3() > 0 || getRess4() > 0 || getRess5() > 0;
	}
	public int getRess(int i)
	{
		if(i==1) return getRess1();
		if(i==2) return getRess2();
		if(i==3) return getRess3();
		if(i==4) return getRess4();
		if(i==5) return getRess5();
		return 0;
	}
	public void setRess(int i, int volumen)
	{
		if(i==1) setRess1(volumen);
		if(i==2) setRess2(volumen);
		if(i==3) setRess3(volumen);
		if(i==4) setRess4(volumen);
		if(i==5) setRess5(volumen);
	}
	
	//Kann zu deadlocks führen..
//	public List<Geschwader> getGeschwader() throws SQLException
//	{
//		return S.s().getGeschwader(this);
//	}

	public void setPosition(Position p)
	{
		setX( Math.round( p.getX()));
		setY( Math.round( p.getY()));
	}
	public Position getSprungziel()
	{
		Position best = null;
		double abstand, besterAbstand = 0;
		Position[] nachbarPositionen = new Position[] 
		{
			new Position(-1,-1), new Position(-1.414f, 0), new Position(-1, 1), 
			new Position( 0,-1.414f), new Position( 0, 1.414f), 
			new Position( 1,-1), new Position( 1.414f, 0), new Position( 1, 1),
		};
		for(int i=0; i<nachbarPositionen.length; i++)
		{
			nachbarPositionen[i].setX(getX()+nachbarPositionen[i].getX());
			nachbarPositionen[i].setY(getY()+nachbarPositionen[i].getY());
			
			abstand = Math.hypot( nachbarPositionen[i].getX()-getZielX(), nachbarPositionen[i].getY()-getZielY() );
			if(i==0 || abstand < besterAbstand)
			{
				best = nachbarPositionen[i];
				besterAbstand=abstand;
			}
		}
		return best;
	}
	
	public Nutzer getBesitzer()
	{
		return Cache.get().getNutzer(getBesitzerNutzerId());
	}
	public int getId()
	{
		return id;
	}
	public void setId(int id)
	{
		this.id = id;
	}
	public int getX()
	{
		return x;
	}
	public void setX(int x)
	{
		this.x = x;
	}
	public int getY()
	{
		return y;
	}
	public void setY(int y)
	{
		this.y = y;
	}
	public int getBesitzerNutzerId()
	{
		return besitzerNutzerId;
	}
	public void setBesitzerNutzerId(int besitzerNutzerId)
	{
		this.besitzerNutzerId = besitzerNutzerId;
	}
	public int getZielX()
	{
		return zielX;
	}
	public void setZielX(int zielX)
	{
		this.zielX = zielX;
	}
	public int getZielY()
	{
		return zielY;
	}
	public void setZielY(int zielY)
	{
		this.zielY = zielY;
	}
	public int getSprungAufladung()
	{
		return sprungAufladung;
	}
	public void setSprungAufladung(int sprungAufladung)
	{
		this.sprungAufladung = sprungAufladung;
	}

	public int getSprungzeit()
	{
		return sprungzeit;
	}

	public void setSprungzeit(int sprungzeit)
	{
		this.sprungzeit = sprungzeit;
	}

	public int getRess1()
	{
		return ress1;
	}

	public void setRess1(int ress1)
	{
		this.ress1 = ress1;
	}

	public int getRess2()
	{
		return ress2;
	}

	public void setRess2(int ress2)
	{
		this.ress2 = ress2;
	}

	public int getRess3()
	{
		return ress3;
	}

	public void setRess3(int ress3)
	{
		this.ress3 = ress3;
	}

	public int getRess4()
	{
		return ress4;
	}

	public void setRess4(int ress4)
	{
		this.ress4 = ress4;
	}

	public int getRess5()
	{
		return ress5;
	}

	public void setRess5(int ress5)
	{
		this.ress5 = ress5;
	}
}