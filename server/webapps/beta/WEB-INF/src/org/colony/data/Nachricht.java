package org.colony.data;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

public class Nachricht
{
	int id;
	int nutzerIdSender;
	int nutzerIdEmpfaenger;
	int typ;
	String betreff;
	String text;
	boolean gelesen;
	Date datumGesendet;

	public Nachricht(ResultSet rs) throws SQLException
	{
		setId(rs.getInt("id"));
		setNutzerIdSender(rs.getInt("nutzerIdSender"));
		setNutzerIdEmpfaenger(rs.getInt("nutzerIdEmpfaenger"));
		setTyp(rs.getInt("typ"));
		setBetreff(rs.getString("betreff"));
		setText(rs.getString("text"));
		setGelesen(rs.getBoolean("gelesen"));
		setDatumGesendet(rs.getTimestamp("datumGesendet"));
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public int getNutzerIdSender()
	{
		return nutzerIdSender;
	}

	public void setNutzerIdSender(int nutzerIdSender)
	{
		this.nutzerIdSender = nutzerIdSender;
	}

	public int getNutzerIdEmpfaenger()
	{
		return nutzerIdEmpfaenger;
	}

	public void setNutzerIdEmpfaenger(int nutzerIdEmpfaenger)
	{
		this.nutzerIdEmpfaenger = nutzerIdEmpfaenger;
	}

	public int getTyp()
	{
		return typ;
	}

	public void setTyp(int typ)
	{
		this.typ = typ;
	}

	public String getBetreff()
	{
		return betreff;
	}

	public void setBetreff(String betreff)
	{
		this.betreff = betreff;
	}

	public String getText()
	{
		return text;
	}

	public void setText(String text)
	{
		this.text = text;
	}

	public boolean isGelesen()
	{
		return gelesen;
	}

	public void setGelesen(boolean gelesen)
	{
		this.gelesen = gelesen;
	}

	public Date getDatumGesendet()
	{
		return datumGesendet;
	}

	public void setDatumGesendet(Date datumGesendet)
	{
		this.datumGesendet = datumGesendet;
	}

}