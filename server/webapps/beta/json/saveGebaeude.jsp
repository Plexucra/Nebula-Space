<%@page import="org.colony.lib.ContextListener"%>
<%@page import="org.colony.data.Gebaeude"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@ page pageEncoding="UTF-8"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.colony.lib.DbEngine"%>
<%

	try
	{
		Gebaeude g = new Gebaeude();
		ContextListener.getService().insertGebaeude(
			ContextListener.getService().getNutzer(session), 
			Integer.parseInt(request.getParameter("x")), 
			Integer.parseInt(request.getParameter("y")), 
			Integer.parseInt(request.getParameter("modellId")));
		out.print("{}");
	}
	catch(Exception ex)
	{
		ex.printStackTrace();
		out.print("{'success':false, 'errorMessage':'"+ex.getLocalizedMessage()+"'}");
	}

%>
