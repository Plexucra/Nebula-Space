<%@page import="org.colony.data.Nutzer"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@ page pageEncoding="UTF-8"%>
<%@page import="org.colony.lib.ContextListener"%>
<%
try
{
	if(request.getParameter("key")==null || request.getParameter("alias")==null)
		throw new NullPointerException("Der Nutzer konnte nicht angelegt werden da der Alias oder der Nutzer-Schlüssel nicht übergeben wurden.");
	Nutzer nutzer = new Nutzer();
	nutzer.setAlias(request.getParameter("alias"));
	nutzer.setKey(request.getParameter("key"));
	nutzer.setHeimatPlanetId(Integer.parseInt(request.getParameter("planetId")));
	
	ContextListener.getService().insertNutzer(nutzer);
	session.setAttribute("userId", ContextListener.getService().getNutzerByKey(request.getParameter("key")).getId());
	out.println("{\"success\":true}");
}
catch(Exception ex)
{
	Logger.getLogger(this.getClass().getName()).log(Level.ALL, ex.toString());
	String text = ex.getLocalizedMessage();
	if(text!=null) text=text.replaceAll("\"", "'");
	out.println("{\"success\":false,\"errorMessage\":\""+text+"\"}");
}
%>
