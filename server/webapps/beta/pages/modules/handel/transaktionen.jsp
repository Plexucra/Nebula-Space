<%@page import="org.colony.lib.Cache"%>
<%@page import="org.colony.data.Transaktion"%>
<%@page import="org.colony.service.HandelService"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="/pages/include/page-header.jsp" %>

<table>
<tr>
	<td>Ressource</td>
	<td>Kurs</td>
	<td>Volumen</td>
	<td>Tick</td>
	<td>Handeslplatz</td>
	<td>Käufer</td>
	<td>Verkäufer</td>
</tr>
<%
for(Transaktion t : HandelService.getLetzteTransaktionen(s.getNutzer()))
{
	%>
	<tr>
		<td><%= HandelService.getRessName(t.getRess()) %></td>
		<td><%= t.getKurs() %></td>
		<td><%= t.getVolumen() %></td>
		<td><%= t.getTick() %></td>
		<td><%= Cache.get().getPlanet( t.getPlanetId()).getName() %></td>
		<td><%= t.getNutzerIdKaeufer()==0?"planetarer Staatskonzern":Cache.get().getNutzer(t.getNutzerIdKaeufer()).getAlias() %></td>
		<td><%= t.getNutzerIdVerkaeufer()==0?"planetarer Staatskonzern":Cache.get().getNutzer(t.getNutzerIdVerkaeufer()).getAlias() %></td>
	</tr>
	<%
}
%>
</table>