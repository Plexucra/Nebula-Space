<%-- 



-------------- Deprecated --------------




--%><%@page import="java.sql.PreparedStatement"--%>
<%@ include file="include/init.jsp" %>
<%@ page pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.colony.lib.DbEngine"%>

<%
Connection c = DbEngine.getConnection();
try
{
	Map<String,String> map = new HashMap<String,String>();
	PreparedStatement ps = c.prepareStatement("select * from nutzer where email = ? and kennwort=?");
	ps.setString(1, request.getParameter("email"));
	ps.setString(2, request.getParameter("kennwort"));
	ResultSet rs = ps.executeQuery();
	StringBuffer sb = new StringBuffer(5000);
	if(rs!=null)
	{
		while(rs.next())
		{
			session.setAttribute("currentNutzerAlias", rs.getString("alias"));
			session.setAttribute("currentNutzerEmail", rs.getString("email"));
			session.setAttribute("currentNutzerKontostand", rs.getString("kontostand"));
			session.setAttribute("currentNutzerReputation", rs.getString("reputation"));
			session.setAttribute("currentNutzerEinnahmen", rs.getString("einnahmen"));
			session.setAttribute("currentNutzerId", rs.getString("id"));
		}
	}
	rs.close();
	ps.close();
	if(session.getAttribute("currentNutzerId")==null)
	{
		throw new Exception("Die Kombination aus Kennwort und E-Mail ist nich korrekt. Bitte Eingaben prüfen.");
	}
	out.println("{\"success\":true}");
}
catch(Exception ex)
{
	String text = ex.getLocalizedMessage();
	if(text!=null) text=text.replaceAll("\"", "'");
	out.println("{\"success\":false,\"errorMessage\":\""+text+"\"}");
}
finally
{
	if(c!=null) c.close();
}
%>