<%@page import="org.colony.data.Modell"%>
<%@page import="java.util.List"%>
<%@page import="flexjson.JSONSerializer"%>
<%@page import="org.colony.data.Gebaeude"%>
<%@page import="org.colony.lib.ContextListener"%>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="include/init.jsp" %>
<%
Gebaeude g = new Gebaeude();
g.setGrundstueckX(Integer.parseInt(request.getParameter("x")));
g.setGrundstueckY(Integer.parseInt(request.getParameter("y")));
List<Gebaeude> gs = ContextListener.getService().getRelevanteGebaeude(g);

Modell bestM = null;
float bestE=0;
for(Modell m :ContextListener.getService().getModelle().values())
{
	if(bestM==null) bestM = m;
	g.setModell(m);
	float ef = ContextListener.getService().getEffizienz(g, gs);
	if(ef > bestE)
	{
		bestM = m;
		bestE = ef;
	}
}
JSONSerializer json = new JSONSerializer();

%>
{
	"modell":<%= json.deepSerialize(bestM) %>,
	"effizienz":<%= bestE %>
}
