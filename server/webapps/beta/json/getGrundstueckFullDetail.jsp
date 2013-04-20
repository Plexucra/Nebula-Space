<%@page import="flexjson.JSONSerializer"%>
<%@page import="org.colony.data.Gebaeude"%>
<%@page import="org.colony.lib.ContextListener"%>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="include/init.jsp" %>
<%
	Gebaeude g = ContextListener.getService().getGebaeude(Integer.parseInt(request.getParameter("id")));
	JSONSerializer json = new JSONSerializer();
	session.setAttribute("selGrundstueckX",g.getGrundstueckX());
	session.setAttribute("selGrundstueckY",g.getGrundstueckY());
%>
{
	"gebaeude":<%= json.deepSerialize(g) %>,
	"einfluesse":<%= json.deepSerialize(ContextListener.getService().getEinfluesse(g, null)) %>,
	"effizienz":<%= json.deepSerialize(ContextListener.getService().getEffizienz(g, null)) %>
}
