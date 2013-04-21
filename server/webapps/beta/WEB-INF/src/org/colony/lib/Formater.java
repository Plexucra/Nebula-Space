package org.colony.lib;

import java.text.NumberFormat;
import java.util.Locale;

public class Formater
{
	static NumberFormat cf;
	static 
	{
		cf = NumberFormat.getNumberInstance(Locale.GERMANY);
		cf.setGroupingUsed(true);
		cf.setMaximumFractionDigits(0);
	}
	public static String formatDiffCurrency(int value)
	{
		StringBuffer sb = new StringBuffer();
		if(value<0)
		{
			sb.append("<span class='cn_negativ'>");
		}
		else
		{
			sb.append("<span class='cn_positiv'>+");
		}
		sb.append(cf.format(value));
		sb.append("</span>");
		return sb.toString();
	}
	public static String formatCurrency(int value)
	{
		StringBuffer sb = new StringBuffer();
		if(value<0)
		{
			sb.append("<span class='cn_negativ'>");
		}
		else
		{
			sb.append("<span class='cn_positiv'>");
		}
		sb.append(cf.format(value));
		sb.append("</span>");
		return sb.toString();
	}
	public static String formatCurrency(long value)
	{
		StringBuffer sb = new StringBuffer();
		if(value<0)
		{
			sb.append("<span class='cn_negativ'>");
		}
		else
		{
			sb.append("<span class='cn_positiv'>");
		}
		sb.append(cf.format(value));
		sb.append("</span>");
		return sb.toString();
	}
}