<%@page import="org.colony.service.StatistikService"%>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="/pages/include/page-header.jsp" %>
<%
pageContext.setAttribute("hs", StatistikService.getNutzerhighscore());
%>
<div>
	<h1>Nutzerstatistik</h1>
	<table class="cn_matrix">
		<tr>
			<th>Nutzer</td>
			<th>Heimatplanet</td>
			<th>Allianz</td>
			<th align="right">Anzahl Gebäude</td>
			<th align="right">Kapazität Gebäude</td>
			<th align="right">Flottenstärke</td>
			<th align="right">Rohstoffbesitz</td>
			<th align="right">Credits</td>
			<th align="right">Highscore</td>
		</tr>
		<c:forEach items="${hs}" var="row">
			<tr>
				<td>${row.nutzer.alias}</td>
				<td>${row.nutzer.heimatPlanet.name}</td>
				<td>${row.nutzer.allianz.bezeichnung}</td>
				<td align="right"><fmt:formatNumber>${row.anzahlGebaeude}</fmt:formatNumber></td>
				<td align="right"><fmt:formatNumber>${row.kapazitaetGebaeude}</fmt:formatNumber></td>
				<td align="right"><fmt:formatNumber>${row.flottenstaerke}</fmt:formatNumber></td>
				<td align="right"><fmt:formatNumber>${row.rohstoffbesitz}</fmt:formatNumber></td>
				<td align="right"><fmt:formatNumber>${row.nutzer.kontostand}</fmt:formatNumber></td>
				<td align="right"><fmt:formatNumber>${row.highscore}</fmt:formatNumber></td>
			</tr>
		</c:forEach>
	</table>
</div>

