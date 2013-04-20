package org.colony.lib;

import javax.servlet.http.HttpServletRequest;

import org.colony.data.Nutzer;

public class S
{
	HttpServletRequest request;
	public S(HttpServletRequest request)
	{
		this.request = request;
		request.setAttribute("ns", request.getServletPath().replaceAll("/", "_").replaceAll("\\.jsp", ""));
	}
	public Nutzer getNutzer()
	{
		return service().getNutzer(request.getSession());
	}
	public Ticker getTicker()
	{
		return ContextListener.getTicker();
	}

	public int getInt(String parameterName)
	{
		return Integer.parseInt(request.getParameter(parameterName));
	}

	public boolean getBool(String parameterName)
	{
		return Boolean.getBoolean(request.getParameter(parameterName));
	}

	public String getString(String parameterName)
	{
		return request.getParameter(parameterName);
	}
	public boolean has(String parameterName)
	{
		return request.getParameter(parameterName)!=null;
	}
	
	public Service service()
	{
		return ContextListener.getService();
	}
}