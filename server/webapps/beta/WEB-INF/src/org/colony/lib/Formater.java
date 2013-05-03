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
	public static String tickToTime(int tick)
	{
		System.out.println("tick:"+tick+" ContextListener.getTicker().getDuration():"+ContextListener.getTicker().getDuration()+" = "+(ContextListener.getTicker().getDuration()*tick));
		int sek = (int)Math.round(((double)(ContextListener.getTicker().getDuration()*tick))/1000f);
		int min = 0;
		int h = 0;
		int d = 0;
		
		if(sek>60)
		{
			min = Math.round(((float)sek)/60f);
			sek -= min*60;
		}
		if(min>60)
		{
			h = Math.round(((float)min)/60f);
			min -= h*60;
		}
		if(h>24)
		{
			d = Math.round(((float)h)/24f);
			h -= d*24;
		}
		StringBuffer sb = new StringBuffer();
		if(d>0) { sb.append(d); sb.append("T "); }
		if(h>0) { sb.append(h); sb.append("h "); }
		if(min>0) { sb.append(min); sb.append("min "); }
		if(sek>0) { sb.append(sek); sb.append("sek "); }
		return sb.toString();
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