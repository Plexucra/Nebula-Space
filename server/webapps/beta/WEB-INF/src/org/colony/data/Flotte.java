package org.colony.data;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.colony.lib.ContextListener;
import org.colony.lib.S;

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
	
	public Flotte(ResultSet rs) throws SQLException
	{
		setId(rs.getInt("id"));
		setBesitzerNutzerId(rs.getInt("besitzerNutzerId"));
		setZielX(rs.getInt("zielX"));
		setZielY(rs.getInt("zielY"));
		setX(rs.getInt("x"));
		setY(rs.getInt("y"));
		setSprungAufladung(rs.getInt("sprungAufladung"));
	}
	
	public List<Geschwader> getGeschwader() throws SQLException
	{
		return S.s().getGeschwader(this);
	}

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
		return ContextListener.getService().getNutzer(getBesitzerNutzerId());
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
}