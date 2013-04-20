package org.colony.lib;

import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class ContextListener implements ServletContextListener
{
	static Ticker ticker;
	public static Service getService()
	{
		return getTicker().getService();
	}
	
	@Override
	public void contextDestroyed(ServletContextEvent arg0)
	{
		if(getService().debug)
			System.out.println("Web-Anwendung nebula-space.de wird herunter gefahren..");
		Enumeration<Driver> drivers = DriverManager.getDrivers();
		while (drivers.hasMoreElements())
		{
			Driver driver = drivers.nextElement();
			try
			{
				DriverManager.deregisterDriver(driver);
//				Logger.getLogger(this.getClass().getName()).log(Level.INFO, String.format("deregistering jdbc driver: %s", driver));
			} catch (SQLException e)
			{
				Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, String.format("Error deregistering driver %s", driver), e);
			}

		}
		ticker.interrupt();
		try
		{
			Thread.sleep(1000);
		}
		catch (InterruptedException e)
		{
			e.printStackTrace();
		}
	}

	@Override
	public void contextInitialized(ServletContextEvent arg0)
	{
		try
		{
			ticker = new Ticker();
			ticker.start();
		} catch (Exception e)
		{
			e.printStackTrace();
			Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, e.toString());
		}
		if(getService().debug)
			System.out.println("Web-Anwendung nebula-space.de wird hoch gefahren..");
	}

	public static Ticker getTicker()
	{
		return ticker;
	}

	public static void setTicker(Ticker ticker)
	{
		ContextListener.ticker = ticker;
	}

}