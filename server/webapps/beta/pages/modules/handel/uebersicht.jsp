<%@page import="org.colony.service.HandelService"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.colony.data.Planet"%>
<%@page import="java.util.List"%>
<%@page import="org.colony.service.PlanetService"%>
<%@page import="org.colony.data.Schiffsmodell"%>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="/pages/include/page-header.jsp" %>

<h1>Handelsplätze</h1>
<% request.setAttribute("plist",PlanetService.getPlaneten()); %>


<table>
	<tr>
		<th><%= HandelService.ress1Name %></th>
		<th><%= HandelService.ress2Name %></th>
		<th><%= HandelService.ress3Name %></th>
		<th><%= HandelService.ress4Name %></th>
		<th><%= HandelService.ress5Name %></th>
	</tr>
<c:forEach items="${ plist }" var="row">
	<tr>
		<td><span class="cn_label">Handelsplatz:</span></td>
		<td colspan="5">
			<c:choose>
				<c:when test="${ row.allianz.id ne s.allianz.id }">
					<span class="cn_label">${ row.name } </span><br/>
					<span class="cn_label">(gesperrt durch Handelsembargo von ${ row.allianz.bezeichnung})</span>
				</c:when>
				<c:otherwise>
					${ row.name }
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	<tr class="${ row.allianz.id ne s.allianz.id ? 'cn_disabled':'' }">
		<td><span class="cn_label">Fördermenge:</span></td>
		<td>${row.ress1Vorkommen}</td>
		<td>${row.ress2Vorkommen}</td>
		<td>${row.ress3Vorkommen}</td>
		<td>${row.ress4Vorkommen}</td>
		<td>${row.ress5Vorkommen}</td>
	</tr>
	<tr class="${ row.allianz.id ne s.allianz.id ? 'cn_disabled':'' }">
		<td><span class="cn_label">Letzter Kurs:</span></td>
		<td>${row.ress1Vorkommen} <c:if test="${ row.allianz.id eq s.allianz.id }"><br/><a href="#">Kauforder</a>  <br/><a href="#">Verkauforder</a> </c:if></td>
		<td>${row.ress2Vorkommen} <c:if test="${ row.allianz.id eq s.allianz.id }"><br/><a href="#">Kauforder</a>  <br/><a href="#">Verkauforder</a> </c:if></td>
		<td>${row.ress3Vorkommen} <c:if test="${ row.allianz.id eq s.allianz.id }"><br/><a href="#">Kauforder</a>  <br/><a href="#">Verkauforder</a> </c:if></td>
		<td>${row.ress4Vorkommen} <c:if test="${ row.allianz.id eq s.allianz.id }"><br/><a href="#">Kauforder</a>  <br/><a href="#">Verkauforder</a> </c:if></td>
		<td>${row.ress5Vorkommen} <c:if test="${ row.allianz.id eq s.allianz.id }"><br/><a href="#">Kauforder</a>  <br/><a href="#">Verkauforder</a> </c:if></td>
	</tr>
	<tr><td colspan="6"><hr/></td></tr>
</c:forEach>
</table>