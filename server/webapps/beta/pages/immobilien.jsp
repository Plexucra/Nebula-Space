<%@page import="org.colony.service.GebaeudeService"%>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="include/page-header.jsp" %>

<div>
	<h3>Immobilienübersicht:</h3>
	<%
	request.setAttribute("gebaeude", GebaeudeService.getNutzerGebaeude(s.getNutzer()));
	%>
	<table>
		<tr>
			<th>Position</th>
			<th>Gewinn</th>
			<th>Typ</th>
			<th>Modell</th>
		</tr>
		<c:forEach items="${ gebaeude }" var="row">
			<tr>
				<td><a href="karte.jsp?x=${row.grundstueckX}&y=${row.grundstueckY}">${row.grundstueckX}:${row.grundstueckY}</a></td>
				<td>${ row.einnahmen - row.ausgaben }</td>
				<td>${row.modell.typ.bezeichnung}</td>
				<td>${row.modell.bezeichnung}</td>
			</tr>
		</c:forEach>
	</table>
</div>

<%@ include file="include/page-footer.jsp" %>
